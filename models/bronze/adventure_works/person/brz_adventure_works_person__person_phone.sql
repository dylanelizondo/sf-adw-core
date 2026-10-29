-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_person_person_phone") }}

select
    business_entity_id,
    phone_number,
    phone_number_type_id,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_person', 'person_phone') }}
