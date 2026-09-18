-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    sales_tax_rate_id,
    state_province_id,
    tax_type,
    tax_rate,
    name,
    rowguid,
    modified_date
from {{ source('adventure_works_sales', 'sales_tax_rate') }}
