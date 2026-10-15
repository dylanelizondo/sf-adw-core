-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_sales_tax_rate") }}

select
    sales_tax_rate_id,
    state_province_id,
    tax_type,
    tax_rate,
    name,
    rowguid,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_sales', 'sales_tax_rate') }}
