-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    productreviewid,
    productid,
    reviewername,
    reviewdate,
    emailaddress,
    rating,
    comments,
    modifieddate
from {{ source('adventure_works_production', 'product_review') }}
