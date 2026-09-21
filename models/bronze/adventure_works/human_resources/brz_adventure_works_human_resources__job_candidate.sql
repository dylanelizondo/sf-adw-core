-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    job_candidate_id,
    business_entity_id,
    resume,
    modified_date
from {{ source('adventure_works_human_resources', 'job_candidate') }}
