-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_id,
    start_date,
    end_date,
    list_price,
    modified_date
from {{ source('adventure_works_production', 'product_list_price_history') }}
