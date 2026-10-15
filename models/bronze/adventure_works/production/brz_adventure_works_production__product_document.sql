-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_product_document") }}

select
    product_id,
    document_node,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_production', 'product_document') }}
