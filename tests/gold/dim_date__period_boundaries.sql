-- Boundary test for the first/last day columns.
--
-- Month, quarter and year boundaries are re-derived without LAST_DAY() so a wrong
-- date part argument in the model is caught. last_day_of_week follows the Snowflake
-- WEEK_START session parameter, so it is only asserted to land inside the seven day
-- window starting at date_key -- that holds under any WEEK_START. Returns the
-- offending rows.
SELECT date_key
     , first_day_of_quarter
     , last_day_of_month
     , last_day_of_quarter
     , last_day_of_year
     , last_day_of_week
FROM {{ ref('dim_date') }}
WHERE first_day_of_quarter <> DATE_FROM_PARTS(YEAR(date_key), (quarter - 1) * 3 + 1, 1)
   OR last_day_of_month    <> DATEADD(DAY, -1, DATEADD(MONTH,   1, DATE_TRUNC('MONTH',   date_key)))
   OR last_day_of_quarter  <> DATEADD(DAY, -1, DATEADD(QUARTER, 1, DATE_TRUNC('QUARTER', date_key)))
   OR last_day_of_year     <> DATE_FROM_PARTS(YEAR(date_key), 12, 31)
   OR last_day_of_week      NOT BETWEEN date_key AND DATEADD(DAY, 6, date_key)
