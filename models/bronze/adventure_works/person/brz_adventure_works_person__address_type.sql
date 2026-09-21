-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    address_type_id,
    name,
    rowguid,
    modified_date
from {{ source('adventure_works_person', 'address_type') }}
