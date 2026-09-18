-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    report_number,
    created_date,
    date_occurred,
    event_type,
    event_report_title,
    safety_incident_description,
    department,
    location_of_event,
    osha_classification,
    nature_of_injury,
    region_of_body,
    days_restricted,
    days_lost
from {{ source('adventure_works_sales', 'injury_tracker') }}
