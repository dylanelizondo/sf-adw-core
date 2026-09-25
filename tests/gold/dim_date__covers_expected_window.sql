-- Coverage test. dim_date is meant to span 1 January of last year through
-- 31 December five years out, relative to CURRENT_DATE.
--
-- This guards the GENERATOR(ROWCOUNT) in the model: the WHERE clause there caps
-- the range silently, so if the window ever grows past the generated row count
-- the dimension would come up short with no error. Returns a diagnostic row when
-- the actual bounds do not match the intended ones.
WITH expected AS (
    SELECT DATE_FROM_PARTS(YEAR(CURRENT_DATE) - 1, 1, 1)                   AS first_date
         , DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 5, 1, 1)) AS last_date
),
actual AS (
    SELECT MIN(date_key) AS first_date
         , MAX(date_key) AS last_date
    FROM {{ ref('dim_date') }}
)
SELECT a.first_date AS actual_first_date
     , e.first_date AS expected_first_date
     , a.last_date  AS actual_last_date
     , e.last_date  AS expected_last_date
FROM actual a
CROSS JOIN expected e
WHERE a.first_date <> e.first_date
   OR a.last_date  <> e.last_date
