-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    account_number,
    name,
    credit_rating,
    preferred_vendor_status,
    active_flag,
    purchasing_web_service_url,
    modified_date
from {{ source('adventure_works_purchasing', 'vendor') }}
