-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    work_order_id,
    product_id,
    order_qty,
    stocked_qty,
    scrapped_qty,
    start_date,
    end_date,
    due_date,
    scrap_reason_id,
    modified_date
from {{ source('adventure_works_production', 'work_order') }}
