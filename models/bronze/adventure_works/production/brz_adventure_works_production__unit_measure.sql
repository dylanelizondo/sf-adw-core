-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_unit_measure") }}

select
    unit_measure_code,
    name,
    modified_date
from {{ source('adventure_works_production', 'unit_measure') }}
