-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_person_address_type") }}

select
    address_type_id,
    name,
    rowguid,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_person', 'address_type') }}
