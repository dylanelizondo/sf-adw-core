-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_model_id,
    illustration_id,
    modified_date
from {{ source('adventure_works_production', 'product_model_illustration') }}
