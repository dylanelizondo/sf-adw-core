-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    currency_rate_id,
    currency_rate_date,
    from_currency_code,
    to_currency_code,
    average_rate,
    end_of_day_rate,
    modified_date
from {{ source('adventure_works_sales', 'currency_rate') }}
