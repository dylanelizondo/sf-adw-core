-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    shift_id,
    name,
    start_time,
    end_time,
    modified_date
from {{ source('adventure_works_human_resources', 'shift') }}
