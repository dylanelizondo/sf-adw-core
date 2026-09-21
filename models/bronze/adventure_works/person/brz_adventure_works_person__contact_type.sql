-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    contact_type_id,
    name,
    modified_date
from {{ source('adventure_works_person', 'contact_type') }}
