-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_human_resources_employee") }}

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
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_human_resources', 'employee') }}
