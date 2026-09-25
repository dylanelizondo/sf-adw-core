-- Consistency test for the calendar attributes.
--
-- Each attribute is re-derived from date_key a different way than the model built
-- it -- day of year by date arithmetic, quarter from the month, the name columns by
-- lookup, the ISO weekday by counting days from a known Monday (2024-01-01). A
-- column that gets renamed, reordered or mis-aliased in the model shows up here.
-- Returns the offending rows.
SELECT date_key
     , year
     , month
     , day
     , dayofmonth
     , monthname
     , dayname
     , quarter
     , dayofyear
     , dayofweekiso
FROM {{ ref('dim_date') }}
WHERE year         <> YEAR(date_key)
   OR month        <> MONTH(date_key)
   OR day          <> DAY(date_key)
   OR dayofmonth   <> DAY(date_key)
   OR quarter      <> CEIL(month / 3)
   OR dayofyear    <> DATEDIFF(DAY, DATE_TRUNC('YEAR', date_key), date_key) + 1
   OR monthname    <> DECODE(month,  1, 'Jan',  2, 'Feb',  3, 'Mar',  4, 'Apr'
                                  ,  5, 'May',  6, 'Jun',  7, 'Jul',  8, 'Aug'
                                  ,  9, 'Sep', 10, 'Oct', 11, 'Nov', 12, 'Dec')
   OR dayofweekiso <> MOD(MOD(DATEDIFF(DAY, DATE '2024-01-01', date_key), 7) + 7, 7) + 1
   OR dayname      <> DECODE(dayofweekiso, 1, 'Mon', 2, 'Tue', 3, 'Wed', 4, 'Thu'
                                         , 5, 'Fri', 6, 'Sat', 7, 'Sun')
