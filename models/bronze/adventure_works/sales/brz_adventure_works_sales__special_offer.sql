-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    special_offer_id,
    description,
    discount_pct,
    type,
    category,
    start_date,
    end_date,
    min_qty,
    max_qty,
    rowguid,
    modified_date
from {{ source('adventure_works_sales', 'special_offer') }}
