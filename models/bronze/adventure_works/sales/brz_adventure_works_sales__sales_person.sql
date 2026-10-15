-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_sales_person") }}

select
    business_entity_id,
    territory_id,
    sales_quota,
    bonus,
    commission_pct,
    sales_ytd,
    sales_last_year,
    rowguid,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_sales', 'sales_person') }}
