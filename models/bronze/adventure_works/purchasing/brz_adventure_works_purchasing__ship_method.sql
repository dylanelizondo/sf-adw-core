-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_purchasing_ship_method") }}

select
    ship_method_id,
    name,
    ship_base,
    ship_rate,
    rowguid,
    modified_date
from {{ source('adventure_works_purchasing', 'ship_method') }}
