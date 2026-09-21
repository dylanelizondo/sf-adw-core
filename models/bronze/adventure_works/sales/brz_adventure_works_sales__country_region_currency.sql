-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    country_region_code,
    currency_code,
    modified_date
from {{ source('adventure_works_sales', 'country_region_currency') }}
