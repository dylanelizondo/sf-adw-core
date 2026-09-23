-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    transactionid,
    productid,
    referenceorderid,
    referenceorderlineid,
    transactiondate,
    transactiontype,
    quantity,
    actualcost,
    modifieddate
from {{ source('adventure_works_production', 'transaction_history_archive') }}
