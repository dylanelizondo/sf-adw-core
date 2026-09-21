-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    transaction_id,
    product_id,
    reference_order_id,
    reference_order_line_id,
    transaction_date,
    transaction_type,
    quantity,
    actual_cost,
    modified_date
from {{ source('adventure_works_production', 'transaction_history') }}
