-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    scrap_reason_id,
    name,
    modified_date
from {{ source('adventure_works_production', 'scrap_reason') }}
