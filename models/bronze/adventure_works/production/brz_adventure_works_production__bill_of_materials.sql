-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_production_bill_of_materials") }}

select
    bill_of_materials_id,
    product_assembly_id,
    component_id,
    start_date,
    end_date,
    unit_measure_code,
    bomlevel,
    per_assembly_qty,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_production', 'bill_of_materials') }}
