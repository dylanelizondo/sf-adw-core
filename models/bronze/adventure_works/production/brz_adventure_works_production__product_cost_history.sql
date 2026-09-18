-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_id,
    start_date,
    end_date,
    standard_cost,
    modified_date
from {{ source('adventure_works_production', 'product_cost_history') }}
