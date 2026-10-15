-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_illustration") }}

select
    illustration_id,
    diagram,
    try_to_timestamp(modified_date) as modified_date
from {{ source('adventure_works_production', 'illustration') }}
