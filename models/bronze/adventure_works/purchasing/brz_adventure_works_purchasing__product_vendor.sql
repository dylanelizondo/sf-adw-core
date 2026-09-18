-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_id,
    business_entity_id,
    average_lead_time,
    standard_price,
    last_receipt_cost,
    last_receipt_date,
    min_order_qty,
    max_order_qty,
    on_order_qty,
    unit_measure_code,
    modified_date
from {{ source('adventure_works_purchasing', 'product_vendor') }}
