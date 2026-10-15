-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_human_resources_shift") }}

select
    shift_id,
    name,
    start_time,
    end_time,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_human_resources', 'shift') }}
