-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_sales_credit_card") }}

select
    credit_card_id,
    card_type,
    card_number,
    exp_month,
    exp_year,
    modified_date
from {{ source('adventure_works_sales', 'credit_card') }}
