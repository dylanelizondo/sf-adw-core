-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_product_list_price_history") }}

select
    product_id,
    start_date,
    end_date,
    list_price,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_production', 'product_list_price_history') }}
