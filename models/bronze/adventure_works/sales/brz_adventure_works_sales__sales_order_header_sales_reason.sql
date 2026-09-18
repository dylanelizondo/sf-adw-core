-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    sales_order_id,
    sales_reason_id,
    modified_date
from {{ source('adventure_works_sales', 'sales_order_header_sales_reason') }}
