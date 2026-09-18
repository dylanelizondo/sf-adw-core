-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    purchase_order_id,
    purchase_order_detail_id,
    due_date,
    order_qty,
    product_id,
    unit_price,
    line_total,
    received_qty,
    rejected_qty,
    stocked_qty,
    modified_date
from {{ source('adventure_works_purchasing', 'purchase_order_detail') }}
