-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    credit_card_id,
    card_type,
    card_number,
    exp_month,
    exp_year,
    modified_date
from {{ source('adventure_works_sales', 'credit_card') }}
