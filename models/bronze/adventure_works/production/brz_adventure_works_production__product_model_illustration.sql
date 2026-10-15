-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_product_model_illustration") }}

select
    product_model_id,
    illustration_id,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_production', 'product_model_illustration') }}
