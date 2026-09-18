-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    rowguid,
    modified_date
from {{ source('adventure_works_person', 'business_entity') }}
