-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_product_product_photo") }}

select
    product_id,
    product_photo_id,
    primary,
    modified_date
from {{ source('adventure_works_production', 'product_product_photo') }}
