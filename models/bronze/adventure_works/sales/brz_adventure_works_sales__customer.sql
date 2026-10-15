-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_customer") }}

select
    customer_id,
    person_id,
    store_id,
    territory_id,
    account_number,
    rowguid,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_sales', 'customer') }}
