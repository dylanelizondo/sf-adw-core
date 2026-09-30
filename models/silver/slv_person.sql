{{ config(tags = ['person', 'pii']) }}

-- slv_person
-- ONE row per person. 19,972 = Person.Person. THIS ROW COUNT IS THE CONTRACT.
--
-- Conformed identity spine of the AdventureWorks party model. person_key is minted
-- HERE and inherited by every team's gold person dimension -- never recomputed
-- downstream, or the same human gets different keys in Purchasing and Sales.
--
-- Five blocks, in order: keys | identity | role flags | resolved contact | survey.
-- Blocks 4 and 5 are where all the fan-out and parse risk lives. They sit inside
-- the table every team's keys come from, so the row-count assertion in
-- tests/assert_slv_person_row_count_matches_source.sql must never be allowed to fail.

with person as (

    select
        business_entity_id,
        person_type,
        name_style,
        title,
        first_name,
        middle_name,
        last_name,
        suffix,
        email_promotion,
        demographics,
        modified_date
    from {{ ref('brz_adventure_works_person__person') }}

),

---------------------------------------------------------------------------
-- BLOCK 3 -- role membership.
-- Existence checks over DISTINCT sets: semi-joins cannot duplicate rows, so
-- the one-row-per-person grain survives. This is the block that lets each
-- team find ITS people without touching the untrustworthy person_type.
---------------------------------------------------------------------------

employee as (
    select distinct business_entity_id
    from {{ ref('brz_adventure_works_human_resources__employee') }}
),

customer as (
    select distinct person_id as business_entity_id
    from {{ ref('brz_adventure_works_sales__customer') }}
    where person_id is not null
        and store_id is null
),

store_contact as (
    -- business_entity_contact.person_id           = the CONTACT (a person)
    -- business_entity_contact.business_entity_id  = the store/vendor BEING contacted.
    -- Easy to swap. Don't.
    select distinct bec.person_id as business_entity_id
    from {{ ref('brz_adventure_works_person__business_entity_contact') }} as bec
    inner join {{ ref('brz_adventure_works_sales__store') }} as s
        on bec.business_entity_id = s.business_entity_id
),

vendor_contact as (
    select distinct bec.person_id as business_entity_id
    from {{ ref('brz_adventure_works_person__business_entity_contact') }} as bec
    inner join {{ ref('brz_adventure_works_purchasing__vendor') }} as v
        on bec.business_entity_id = v.business_entity_id
),

---------------------------------------------------------------------------
-- BLOCK 4 -- resolved contact.
-- email, phone and address are all 1:N by schema. The tie-breaks below are
-- BUSINESS RULES ("which phone is the phone"), defined once here so six gold
-- dims don't ship six different answers. Change them here, not in gold.
---------------------------------------------------------------------------

email_ranked as (

    select
        business_entity_id,
        email_address,
        count(*)     over (partition by business_entity_id) as email_count,
        row_number() over (
            partition by business_entity_id
            order by email_address_id                    -- rule: lowest id wins
        ) as rn
    from {{ ref('brz_adventure_works_person__email_address') }}

),

phone_ranked as (

    select
        business_entity_id,
        phone_number,
        phone_number_type_id,
        count(*)     over (partition by business_entity_id) as phone_count,
        row_number() over (
            partition by business_entity_id
            -- rule: cell (1) beats work (3) beats home (2)
            order by case phone_number_type_id
                         when 1 then 1
                         when 3 then 2
                         when 2 then 3
                         else 4
                     end,
                     phone_number
        ) as rn
    from {{ ref('brz_adventure_works_person__person_phone') }}

),

address_ranked as (

    select
        bea.business_entity_id,
        bea.address_id,
        bea.address_type_id,
        count(*)     over (partition by bea.business_entity_id) as address_count,
        row_number() over (
            partition by bea.business_entity_id
            -- rule: Home beats Primary beats Main Office beats the rest
            order by case at.name
                         when 'Home'        then 1
                         when 'Primary'     then 2
                         when 'Main Office' then 3
                         else 4
                     end,
                     bea.address_id
        ) as rn
    from {{ ref('brz_adventure_works_person__business_entity_address') }} as bea
    inner join {{ ref('brz_adventure_works_person__address_type') }} as at
        on bea.address_type_id = at.address_type_id

),

---------------------------------------------------------------------------
-- BLOCK 5 -- IndividualSurvey XML, shredded.
-- Populated for the 18,484 retail customers only; everyone else carries a
-- constant 163-char empty <IndividualSurvey/> shell.
--
-- Snowflake has NO TRY_PARSE_XML (only TRY_PARSE_JSON), so PARSE_XML on a
-- malformed value ERRORS and fails the whole run instead of returning null.
-- Verified 2026-09-28: check_xml returns 0 invalid rows across the table, and
-- the default namespace does NOT interfere with local tag names in xmlget.
-- The check_xml predicate below is belt-and-braces; the real guard is
-- tests/assert_person_demographics_xml_valid.sql, which fails the build if a
-- malformed row ever lands. If that ever fires, switch this block to
-- regexp_substr (safe here -- the XML is one level deep with no repeats).
---------------------------------------------------------------------------

survey as (

    select
        business_entity_id,
        parse_xml(demographics) as doc
    from person
    where contains(demographics, '<Gender>')
      and check_xml(demographics) is null

),

survey_extracted as (

    select
        business_entity_id,
        xmlget(doc, 'TotalPurchaseYTD'    ):"$"::varchar as total_purchase_ytd,
        xmlget(doc, 'DateFirstPurchase'   ):"$"::varchar as date_first_purchase,
        xmlget(doc, 'BirthDate'           ):"$"::varchar as birth_date,
        xmlget(doc, 'Gender'              ):"$"::varchar as gender,
        xmlget(doc, 'MaritalStatus'       ):"$"::varchar as marital_status,
        xmlget(doc, 'YearlyIncome'        ):"$"::varchar as yearly_income,
        xmlget(doc, 'TotalChildren'       ):"$"::varchar as total_children,
        xmlget(doc, 'NumberChildrenAtHome'):"$"::varchar as number_children_at_home,
        xmlget(doc, 'Education'           ):"$"::varchar as education,
        xmlget(doc, 'Occupation'          ):"$"::varchar as occupation,
        xmlget(doc, 'HomeOwnerFlag'       ):"$"::varchar as home_owner_flag,
        xmlget(doc, 'NumberCarsOwned'     ):"$"::varchar as number_cars_owned,
        xmlget(doc, 'CommuteDistance'     ):"$"::varchar as commute_distance
    from survey

)

---------------------------------------------------------------------------
-- FINAL
---------------------------------------------------------------------------

select
    -- BLOCK 1 -- keys ----------------------------------------------------
    -- Equivalent to dbt_utils.generate_surrogate_key(['business_entity_id']) for a
    -- single column in dbt_utils 1.x: same md5, same varchar casts, same null
    -- sentinel. Inlined deliberately so the identity spine carries no package
    -- dependency. MUST stay byte-identical to purchasing's buyer_key -- the whole
    -- point of a conformed key is that both projects agree on it.
    -- The coalesce is redundant on a not-null PK; it is kept only so this matches
    -- the macro's contract rather than the data's current shape.
    md5(cast(coalesce(cast(p.business_entity_id as varchar),
                      '_dbt_utils_surrogate_key_null_') as varchar)) as person_key,
    p.business_entity_id,

    -- BLOCK 2 -- identity -----------------------------------------------
    p.person_type,
    p.title       as person_title,
    p.first_name  as person_first_name,
    p.middle_name as person_middle_name,
    p.last_name   as person_last_name,
    p.suffix      as person_suffix,

    -- name_style = 1 means Eastern order (family name first). Every shipped row is
    -- 0, but honour the flag rather than hardcoding Western order. Built with
    -- coalesce + space collapsing so a null middle name can't null the whole name.
    trim(regexp_replace(
        case
            when cast(p.name_style as boolean)
                then coalesce(p.last_name, '')  || ' ' || coalesce(p.first_name, '')  || ' ' || coalesce(p.middle_name, '')
            else     coalesce(p.first_name, '') || ' ' || coalesce(p.middle_name, '') || ' ' || coalesce(p.last_name, '')
        end,
        ' +', ' ')) as person_full_name,

    trim(p.last_name || ', ' || p.first_name) as person_sort_name,
    cast(p.name_style as boolean)             as person_is_eastern_name_order,
    p.email_promotion                         as person_email_promotion,

    -- BLOCK 3 -- role flags ---------------------------------------------
    -- NOT mutually exclusive: the 17 salespeople are also employees.
    e.business_entity_id  is not null as is_employee,
    c.business_entity_id  is not null as is_customer,
    sc.business_entity_id is not null as is_store_contact,
    vc.business_entity_id is not null as is_vendor_contact,

    -- BLOCK 4 -- resolved contact ---------------------------------------
    em.email_address              as primary_email_address,
    coalesce(em.email_count, 0)   as email_count,

    ph.phone_number               as primary_phone_number,
    ph.phone_number_type_id       as primary_phone_number_type_id,
    coalesce(ph.phone_count, 0)   as phone_count,

    -- address_id only: gold joins geography so city/country aren't duplicated here
    ad.address_id                 as primary_address_id,
    ad.address_type_id            as primary_address_type_id,
    coalesce(ad.address_count, 0) as address_count,

    -- BLOCK 5 -- survey (null for all but the 18,484 retail customers) ---
    -- survey_ prefix is deliberate: these are SELF-REPORTED and cover customers
    -- only, so they must not read as authoritative person attributes.
    contains(p.demographics, '<Gender>')            as has_demographics_survey,

    try_to_decimal(s.total_purchase_ytd, 18, 2)     as survey_total_purchase_ytd,
    try_to_date(s.date_first_purchase)              as survey_date_first_purchase,
    s.gender                                        as survey_gender,
    s.marital_status                                as survey_marital_status,

    -- Raw birth date deliberately NOT exposed. Banded age only, recomputed at build.
    case
        when try_to_date(s.birth_date) is null then null
        when datediff(year, try_to_date(s.birth_date), current_date()) < 30 then 'Under 30'
        when datediff(year, try_to_date(s.birth_date), current_date()) < 40 then '30-39'
        when datediff(year, try_to_date(s.birth_date), current_date()) < 50 then '40-49'
        when datediff(year, try_to_date(s.birth_date), current_date()) < 60 then '50-59'
        when datediff(year, try_to_date(s.birth_date), current_date()) < 70 then '60-69'
        else '70+'
    end as survey_age_band,

    -- These three are BANDS, not numbers. Never cast to numeric. The _sort columns
    -- exist so BI doesn't order them alphabetically ('10+ Miles' first).
    s.yearly_income as survey_yearly_income,
    case s.yearly_income
        when '0-25000'             then 1
        when '25001-50000'         then 2
        when '50001-75000'         then 3
        when '75001-100000'        then 4
        when 'greater than 100000' then 5
    end as survey_yearly_income_sort,

    s.education as survey_education,
    case s.education
        when 'Partial High School' then 1
        when 'High School'         then 2
        when 'Partial College'     then 3
        when 'Bachelors'           then 4
        when 'Graduate Degree'     then 5
    end as survey_education_sort,

    s.commute_distance as survey_commute_distance,
    case s.commute_distance
        when '0-1 Miles'  then 1
        when '1-2 Miles'  then 2
        when '2-5 Miles'  then 3
        when '5-10 Miles' then 4
        when '10+ Miles'  then 5
    end as survey_commute_distance_sort,

    s.occupation                               as survey_occupation,
    try_to_number(s.total_children)            as survey_total_children,
    try_to_number(s.number_children_at_home)   as survey_number_children_at_home,
    try_to_number(s.number_cars_owned)         as survey_number_cars_owned,
    try_to_boolean(s.home_owner_flag)          as survey_is_home_owner,

    -- audit -------------------------------------------------------------
    try_to_timestamp(p.modified_date) as person_modified_date

from person as p
left join employee         as e  on p.business_entity_id = e.business_entity_id
left join customer         as c  on p.business_entity_id = c.business_entity_id
left join store_contact    as sc on p.business_entity_id = sc.business_entity_id
left join vendor_contact   as vc on p.business_entity_id = vc.business_entity_id
left join email_ranked     as em on p.business_entity_id = em.business_entity_id and em.rn = 1
left join phone_ranked     as ph on p.business_entity_id = ph.business_entity_id and ph.rn = 1
left join address_ranked   as ad on p.business_entity_id = ad.business_entity_id and ad.rn = 1
left join survey_extracted as s  on p.business_entity_id = s.business_entity_id