-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    product_photo_id,
    thumbnail_photo_file_name,
    large_photo_file_name,
    modified_date
from {{ source('adventure_works_production', 'product_photo') }}
