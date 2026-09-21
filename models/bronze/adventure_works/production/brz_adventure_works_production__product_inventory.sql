-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_id,
    location_id,
    shelf,
    bin,
    quantity,
    rowguid,
    modified_date
from {{ source('adventure_works_production', 'product_inventory') }}
