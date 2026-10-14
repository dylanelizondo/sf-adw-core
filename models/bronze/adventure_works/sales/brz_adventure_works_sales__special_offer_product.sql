-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_special_offer_product") }}

select
    special_offer_id,
    product_id,
    rowguid,
    modified_date
from {{ source('adventure_works_sales', 'special_offer_product') }}
