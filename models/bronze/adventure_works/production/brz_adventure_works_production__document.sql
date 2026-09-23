-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    documentnode,
    documentlevel,
    title,
    owner,
    folderflag,
    filename,
    fileextension,
    revision,
    changenumber,
    status,
    documentsummary,
    rowguid,
    modifieddate
from {{ source('adventure_works_production', 'document') }}
