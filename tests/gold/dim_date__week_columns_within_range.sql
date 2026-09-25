-- Range test for the week columns whose values depend on the Snowflake WEEK_START
-- and WEEK_OF_YEAR_POLICY session parameters.
--
-- Their exact numbering shifts with those parameters, so asserting fixed values
-- would fail on a session configured differently. These assertions hold under any
-- setting: week and weekofyear are the same function so they must agree, the week
-- numbers stay inside the possible range, dayofweek spans at most 0 to 7, and the
-- week owning year is never more than one year away from the calendar year.
-- weekiso and dayofweekiso are policy independent and covered by the accepted_values
-- tests in the model properties instead. Returns the offending rows.
SELECT date_key
     , year
     , week
     , weekofyear
     , weekiso
     , yearofweek
     , yearofweekiso
     , dayofweek
FROM {{ ref('dim_date') }}
WHERE week          <> weekofyear
   OR week           NOT BETWEEN 1 AND 54
   OR weekiso        NOT BETWEEN 1 AND 53
   OR dayofweek      NOT BETWEEN 0 AND 7
   OR yearofweek     NOT BETWEEN year - 1 AND year + 1
   OR yearofweekiso  NOT BETWEEN year - 1 AND year + 1
