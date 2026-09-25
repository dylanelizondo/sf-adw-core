-- Grain test. dim_date must hold exactly one row for every day between its own
-- first and last date: no gaps, no duplicates.
--
-- If the row count equals the span in days AND every date_key is distinct, then
-- every day in the range is present exactly once. Returns a single diagnostic row
-- when that does not hold.
WITH summary AS (
    SELECT MIN(date_key)             AS first_date
         , MAX(date_key)             AS last_date
         , COUNT(*)                  AS row_count
         , COUNT(DISTINCT date_key)  AS distinct_dates
    FROM {{ ref('dim_date') }}
)
SELECT first_date
     , last_date
     , row_count
     , distinct_dates
     , DATEDIFF(DAY, first_date, last_date) + 1 AS expected_row_count
FROM summary
WHERE row_count <> DATEDIFF(DAY, first_date, last_date) + 1
   OR distinct_dates <> row_count
