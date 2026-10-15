-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_transaction_history_archive") }}

select
    transaction_id,
    product_id,
    reference_order_id,
    reference_order_line_id,
    transaction_date,
    transaction_type,
    quantity,
    actual_cost,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_production', 'transaction_history_archive') }}
