-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    productmodelid,
    illustrationid,
    modifieddate
from {{ source('adventure_works_production', 'product_model_illustration') }}
