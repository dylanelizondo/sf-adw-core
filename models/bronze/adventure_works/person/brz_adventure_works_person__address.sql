-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    address_id,
    address_line1,
    address_line2,
    city,
    state_province_id,
    postal_code,
    spatial_location,
    rowguid,
    modified_date
from {{ source('adventure_works_person', 'address') }}
