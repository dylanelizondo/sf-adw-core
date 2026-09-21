-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    department_id,
    name,
    group_name,
    modified_date
from {{ source('adventure_works_human_resources', 'department') }}
