-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    credit_card_id,
    modified_date
from {{ source('adventure_works_sales', 'person_credit_card') }}
