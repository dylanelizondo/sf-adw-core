-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    state_province_id,
    state_province_code,
    country_region_code,
    is_only_state_province_flag,
    name,
    territory_id,
    rowguid,
    modified_date
from {{ source('adventure_works_person', 'state_province') }}
