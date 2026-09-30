-- Snowflake has no TRY_PARSE_XML, so a malformed value fails the whole run at
-- PARSE_XML time. This test fails FIRST, with the offending ids, and tells you
-- to switch block 5 of slv_person to the regexp_substr fallback.
select
    business_entity_id,
    check_xml(demographics) as xml_error
from {{ ref('brz_adventure_works_person__person') }}
where demographics is not null
  and check_xml(demographics) is not null