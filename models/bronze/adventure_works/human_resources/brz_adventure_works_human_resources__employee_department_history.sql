-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    department_id,
    shift_id,
    start_date,
    end_date,
    modified_date
from {{ source('adventure_works_human_resources', 'employee_department_history') }}
