-- ============================================================================
-- Dimensión de fecha para Snowflake
-- Rango: 1-ene del (año actual - 5)  hasta  31-dic del (año actual + 4)
-- Patrón GENERATOR (idiomático en Snowflake, mucho más barato que un CTE recursivo)
-- ============================================================================

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


-- ============================================================================
-- ALTERNATIVA: la misma idea pero manteniendo el CTE recursivo ya corregido
-- (sirve si te piden explícitamente recursividad; es más lento)
-- ============================================================================
--
-- WITH RECURSIVE CalendarDates (calendar_date) AS (
--     SELECT DATE_FROM_PARTS(YEAR(CURRENT_DATE) - 5, 1, 1)
--     UNION ALL
--     SELECT DATEADD(DAY, 1, calendar_date)
--     FROM CalendarDates
--     WHERE calendar_date < DATEADD(DAY, -1, DATE_FROM_PARTS(YEAR(CURRENT_DATE) + 5, 1, 1))
-- )
-- SELECT ... FROM CalendarDates;


-- ============================================================================
-- NOTA sobre parámetros de sesión: WEEK, WEEKOFYEAR, YEAROFWEEK, DAYOFWEEK y
-- LAST_DAY(..., 'WEEK') dependen de WEEK_START y WEEK_OF_YEAR_POLICY. Si la
-- dimensión debe ser estable, fíjalos explícitamente antes de materializarla:
--
--   ALTER SESSION SET WEEK_START = 1;            -- 1 = lunes (ISO)
--   ALTER SESSION SET WEEK_OF_YEAR_POLICY = 1;   -- 1 = la semana 1 es la del 1-ene
--
-- Las columnas *ISO (WEEKISO, YEAROFWEEKISO, DAYOFWEEKISO) ignoran esos
-- parámetros y siempre siguen ISO-8601.
-- ============================================================================

SELECT COUNT(*) FROM ADVENTURE_WORKS.SALES.CURRENCY_RATE;
SELECT * FROM ADVENTURE_WORKS.SALES.SALES_ORDER_HEADER soh INNER JOIN ADVENTURE_WORKS.SALES.CURRENCY_RATE cr
ON cr.currency_rate_id = soh.currency_rate_id;