-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    national_idnumber,
    login_id,
    organization_node,
    organization_level,
    job_title,
    birth_date,
    marital_status,
    gender,
    hire_date,
    salaried_flag,
    vacation_hours,
    sick_leave_hours,
    current_flag,
    rowguid,
    modified_date
from {{ source('adventure_works_human_resources', 'employee') }}
