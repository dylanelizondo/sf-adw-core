-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    productid,
    documentnode,
    modifieddate
from {{ source('adventure_works_production', 'product_document') }}
