-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    rate_change_date,
    rate,
    pay_frequency,
    modified_date
from {{ source('adventure_works_human_resources', 'employee_pay_history') }}
