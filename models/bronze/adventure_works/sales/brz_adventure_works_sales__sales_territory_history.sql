-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_sales_territory_history") }}

select
    business_entity_id,
    territory_id,
    start_date,
    end_date,
    rowguid,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_sales', 'sales_territory_history') }}
