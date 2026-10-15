-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_sales_order_detail") }}

select
    sales_order_id,
    sales_order_detail_id,
    carrier_tracking_number,
    order_qty,
    product_id,
    special_offer_id,
    unit_price,
    unit_price_discount,
    line_total,
    rowguid,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_sales', 'sales_order_detail') }}
