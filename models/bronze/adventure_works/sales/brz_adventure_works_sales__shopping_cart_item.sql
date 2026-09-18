-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    shopping_cart_item_id,
    shopping_cart_id,
    quantity,
    product_id,
    date_created,
    modified_date
from {{ source('adventure_works_sales', 'shopping_cart_item') }}
