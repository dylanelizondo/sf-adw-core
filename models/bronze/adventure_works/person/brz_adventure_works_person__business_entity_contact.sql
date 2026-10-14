-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_person_business_entity_contact") }}

select
    business_entity_id,
    person_id,
    contact_type_id,
    rowguid,
    modified_date
from {{ source('adventure_works_person', 'business_entity_contact') }}
