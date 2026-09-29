-- One bad tie-break in block 4 would corrupt every team's keys at once.
-- Returns rows (= fails) if slv_person no longer has exactly one row per person.
with source as (
    select count(*) as n from {{ ref('brz_adventure_works_person__person') }}
),
model as (
    select count(*) as n from {{ ref('slv_person') }}
)
select source.n as source_rows, model.n as model_rows
from source cross join model
where source.n != model.n