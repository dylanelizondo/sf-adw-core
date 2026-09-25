WITH bounds AS (
    SELECT DATE_FROM_PARTS(YEAR(CURRENT_DATE) - 1, 1, 1)                  AS start_date
         , DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 5, 1, 1)) AS end_date
),
calendar_dates AS (
    SELECT DATEADD(DAY, g.seq, b.start_date) AS calendar_date
    FROM bounds b
    CROSS JOIN (
        SELECT SEQ4() AS seq
        FROM TABLE(GENERATOR(ROWCOUNT => 4100))   -- 4100 > 10 años (máx. 3653 días)
    ) g
    WHERE DATEADD(DAY, g.seq, b.start_date) <= b.end_date
)
SELECT
      calendar_date                                          AS DATE_KEY
    , YEAR(calendar_date)                                    AS YEAR
    , MONTH(calendar_date)                                   AS MONTH
    , MONTHNAME(calendar_date)                               AS MONTHNAME
    , DAY(calendar_date)                                     AS DAY
    , DAYNAME(calendar_date)                                 AS DAYNAME
    , QUARTER(calendar_date)                                 AS QUARTER
    , WEEK(calendar_date)                                    AS WEEK
    , DAYOFMONTH(calendar_date)                              AS DAYOFMONTH
    , DAYOFWEEK(calendar_date)                               AS DAYOFWEEK
    , DAYOFYEAR(calendar_date)                               AS DAYOFYEAR
    , LAST_DAY(calendar_date)                                AS LAST_DAY_OF_MONTH
    , LAST_DAY(calendar_date, 'QUARTER')                     AS LAST_DAY_OF_QUARTER
    , LAST_DAY(calendar_date, 'YEAR')                        AS LAST_DAY_OF_YEAR
    , LAST_DAY(calendar_date, 'WEEK')                        AS LAST_DAY_OF_WEEK
    , WEEKOFYEAR(calendar_date)                              AS WEEKOFYEAR
    , YEAROFWEEK(calendar_date)                              AS YEAROFWEEK
    , YEAROFWEEKISO(calendar_date)                           AS YEAROFWEEKISO
    , WEEKISO(calendar_date)                                 AS WEEKISO
    , DAYOFWEEKISO(calendar_date)                            AS DAYOFWEEKISO
    , CEIL(DAYOFMONTH(calendar_date) / 7)                    AS WEEK_OF_MONTH
    , DATE_TRUNC('QUARTER', calendar_date)::DATE             AS FIRST_DAY_OF_QUARTER
    , DATEDIFF(DAY, DATE_TRUNC('QUARTER', calendar_date), calendar_date) + 1
                                                             AS DAY_OF_QUARTER
    , DATEDIFF(DAY, DATE_TRUNC('QUARTER', calendar_date),
                    LAST_DAY(calendar_date, 'QUARTER')) + 1  AS DAYS_IN_QUARTER
    , CEIL((DATEDIFF(DAY, DATE_TRUNC('QUARTER', calendar_date), calendar_date) + 1) / 7)
                                                             AS WEEK_OF_QUARTER
FROM calendar_dates
ORDER BY calendar_date;