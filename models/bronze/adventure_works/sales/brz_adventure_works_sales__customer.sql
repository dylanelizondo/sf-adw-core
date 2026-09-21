-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    customer_id,
    person_id,
    store_id,
    territory_id,
    account_number,
    rowguid,
    modified_date
from {{ source('adventure_works_sales', 'customer') }}
