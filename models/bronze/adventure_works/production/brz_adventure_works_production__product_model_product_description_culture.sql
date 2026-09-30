-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_model_id,
    product_description_id,
    culture_id,
    modified_date
from {{ source('adventure_works_production', 'product_model_product_description_culture') }}
