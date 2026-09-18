-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_subcategory_id,
    product_category_id,
    name,
    rowguid,
    modified_date
from {{ source('adventure_works_production', 'product_subcategory') }}
