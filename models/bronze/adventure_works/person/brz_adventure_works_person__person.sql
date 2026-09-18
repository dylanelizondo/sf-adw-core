-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

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
    additional_contact_info,
    demographics,
    rowguid,
    modified_date
from {{ source('adventure_works_person', 'person') }}
