-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

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
    modified_date
from {{ source('adventure_works_sales', 'sales_order_detail') }}
