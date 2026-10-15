-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_human_resources_employee_department_history") }}

select
    business_entity_id,
    department_id,
    shift_id,
    start_date,
    end_date,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_human_resources', 'employee_department_history') }}
