-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    territory_id,
    name,
    country_region_code,
    "GROUP",
    sales_ytd,
    sales_last_year,
    cost_ytd,
    cost_last_year,
    rowguid,
    modified_date
from {{ source('adventure_works_sales', 'sales_territory') }}
