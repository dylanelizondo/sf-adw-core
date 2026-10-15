-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_human_resources_department") }}

select
    department_id,
    name,
    group_name,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_human_resources', 'department') }}
