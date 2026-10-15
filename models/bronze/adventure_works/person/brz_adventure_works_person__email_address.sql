-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_person_email_address") }}

select
    business_entity_id,
    email_address_id,
    email_address,
    rowguid,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_person', 'email_address') }}
