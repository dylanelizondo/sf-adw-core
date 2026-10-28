-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_culture") }}

select
    culture_id,
    name,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_production', 'culture') }}
