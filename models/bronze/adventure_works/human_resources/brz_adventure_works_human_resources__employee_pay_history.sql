-- Bronze passthrough table. One column per source column, no transformations.
-- Any renaming, casting or deduplication belongs in the silver layer.
{{ config(alias="adw_human_resources_employee_pay_history") }}

select
    business_entity_id,
    rate_change_date,
    rate,
    pay_frequency,
    try_to_timestamp(modified_date::varchar) as modified_date
from {{ source('adventure_works_human_resources', 'employee_pay_history') }}
