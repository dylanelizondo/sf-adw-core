-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_review_id,
    product_id,
    reviewer_name,
    review_date,
    email_address,
    rating,
    comments,
    modified_date
from {{ source('adventure_works_production', 'product_review') }}
