-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    email_address_id,
    email_address,
    rowguid,
    modified_date
from {{ source('adventure_works_person', 'email_address') }}
