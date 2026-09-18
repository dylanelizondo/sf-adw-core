-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    bill_of_materials_id,
    product_assembly_id,
    component_id,
    start_date,
    end_date,
    unit_measure_code,
    bomlevel,
    per_assembly_qty,
    modified_date
from {{ source('adventure_works_production', 'bill_of_materials') }}
