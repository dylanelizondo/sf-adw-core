-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    name,
    sales_person_id,
        -- demographics: StoreSurvey XML, shredded -------------------------------
    try_to_decimal(xmlget(parse_xml(demographics), 'AnnualSales'     ):"$"::varchar, 18, 2) as demographics_annual_sales,
    try_to_decimal(xmlget(parse_xml(demographics), 'AnnualRevenue'   ):"$"::varchar, 18, 2) as demographics_annual_revenue,
    xmlget(parse_xml(demographics), 'BankName'        ):"$"::varchar as demographics_bank_name,
    xmlget(parse_xml(demographics), 'BusinessType'    ):"$"::varchar as demographics_business_type,
    try_to_number(xmlget(parse_xml(demographics), 'YearOpened'      ):"$"::varchar) as demographics_year_opened,
    xmlget(parse_xml(demographics), 'Specialty'       ):"$"::varchar as demographics_specialty,
    try_to_number(xmlget(parse_xml(demographics), 'SquareFeet'      ):"$"::varchar) as demographics_square_feet,

    -- NOT numeric: the source carries "4+" alongside "2" and "3". Never cast.
    xmlget(parse_xml(demographics), 'Brands'          ):"$"::varchar as demographics_brand_count,

    xmlget(parse_xml(demographics), 'Internet'        ):"$"::varchar as demographics_internet_connection_type,
    try_to_number(xmlget(parse_xml(demographics), 'NumberEmployees' ):"$"::varchar) as demographics_number_employees,

    rowguid,
    modified_date
from {{ source('adventure_works_sales', 'store') }}
