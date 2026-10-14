-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_product_photo") }}

select
    product_photo_id,
    thumbnail_photo_file_name,
    large_photo_file_name,
    modified_date
from {{ source('adventure_works_production', 'product_photo') }}
