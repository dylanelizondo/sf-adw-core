-- Arithmetic test for the derived quarter and week-block counters.
--
-- day_of_quarter and days_in_quarter are re-derived from the quarter boundary
-- columns, and the two week-block counters from the seven day blocking rule the
-- model uses. day_of_quarter is also range checked against days_in_quarter, which
-- catches an off by one at a quarter edge. Returns the offending rows.
SELECT date_key
     , first_day_of_quarter
     , last_day_of_quarter
     , day_of_quarter
     , days_in_quarter
     , week_of_quarter
     , dayofmonth
     , week_of_month
FROM {{ ref('dim_date') }}
WHERE day_of_quarter  <> DATEDIFF(DAY, first_day_of_quarter, date_key) + 1
   OR days_in_quarter <> DATEDIFF(DAY, first_day_of_quarter, last_day_of_quarter) + 1
   OR week_of_quarter <> CEIL(day_of_quarter / 7)
   OR week_of_month   <> CEIL(dayofmonth / 7)
   OR day_of_quarter   NOT BETWEEN 1 AND days_in_quarter
