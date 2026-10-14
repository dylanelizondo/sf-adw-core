-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_shopping_cart_item") }}

select
    shopping_cart_item_id,
    shopping_cart_id,
    quantity,
    product_id,
    date_created,
    modified_date
from {{ source('adventure_works_sales', 'shopping_cart_item') }}
