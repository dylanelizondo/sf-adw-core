-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    special_offer_id,
    product_id,
    rowguid,
    modified_date
from {{ source('adventure_works_sales', 'special_offer_product') }}
