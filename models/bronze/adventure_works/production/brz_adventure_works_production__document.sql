-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    document_node,
    document_level,
    title,
    owner,
    folder_flag,
    file_name,
    file_extension,
    revision,
    change_number,
    status,
    document_summary,
    rowguid,
    modified_date
from {{ source('adventure_works_production', 'document') }}
