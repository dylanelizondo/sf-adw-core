-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    purchase_order_id,
    revision_number,
    status,
    employee_id,
    vendor_id,
    ship_method_id,
    order_date,
    ship_date,
    sub_total,
    tax_amt,
    freight,
    total_due,
    modified_date
from {{ source('adventure_works_purchasing', 'purchase_order_header') }}
