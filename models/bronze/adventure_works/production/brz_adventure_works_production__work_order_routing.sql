-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    work_order_id,
    product_id,
    operation_sequence,
    location_id,
    scheduled_start_date,
    scheduled_end_date,
    actual_start_date,
    actual_end_date,
    actual_resource_hrs,
    planned_cost,
    actual_cost,
    modified_date
from {{ source('adventure_works_production', 'work_order_routing') }}
