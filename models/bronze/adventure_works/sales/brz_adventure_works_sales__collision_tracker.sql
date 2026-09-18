-- Bronze passthrough view. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.

select
    incident_number,
    service_area,
    driver_last_name,
    driver_first_name,
    incident_date,
    incident_title,
    day_of_week,
    time_of_day,
    conclusion,
    collision_type,
    collision_initiated_by,
    vehicle_activity_at_collision,
    mph_at_collision,
    cdl_holder,
    collision_location,
    safety_professional,
    territory,
    kore_camera_assisted,
    notes
from {{ source('adventure_works_sales', 'collision_tracker') }}
