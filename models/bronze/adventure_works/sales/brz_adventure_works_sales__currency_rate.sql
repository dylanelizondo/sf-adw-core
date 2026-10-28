-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_currency_rate") }}

select
    currency_rate_id,
    currency_rate_date,
    from_currency_code,
    to_currency_code,
    average_rate,
    end_of_day_rate,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_sales', 'currency_rate') }}
