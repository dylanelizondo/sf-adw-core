-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_country_region_currency") }}

select
    country_region_code,
    currency_code,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_sales', 'country_region_currency') }}
