-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    business_entity_id,
    territory_id,
    start_date,
    end_date,
    rowguid,
    modified_date
from {{ source('adventure_works_sales', 'sales_territory_history') }}
