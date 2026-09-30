-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
--
-- The source columns are named without separators (SALESREASONID, REASONTYPE,
-- MODIFIEDDATE) while the rest of the SALES schema uses snake_case. Bronze keeps
-- the source names as they are; aligning them belongs in the silver layer.

select
    salesreasonid,
    name,
    reasontype,
    modifieddate
from {{ source('adventure_works_sales', 'sales_reason') }}
