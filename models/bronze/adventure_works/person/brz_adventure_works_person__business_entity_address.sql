-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_person_business_entity_address") }}

select
    business_entity_id,
    address_id,
    address_type_id,
    rowguid,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_person', 'business_entity_address') }}
