{{ config(materialized="table") }}

WITH date_range AS (
    SELECT DATEADD(DAY, SEQ4(), '2020-01-01') AS date_day
    FROM TABLE(GENERATOR(ROWCOUNT => 2192))
)

SELECT
    date_day,
    YEAR(date_day) AS year,
    MONTH(date_day) AS month,
    DAY(date_day) AS day,
    DAYOFWEEK(date_day) AS day_of_week,
    CASE DAYOFWEEK(date_day)
        WHEN 0 THEN 'sunday'
        WHEN 1 THEN 'monday'
        WHEN 2 THEN 'tuesday'
        WHEN 3 THEN 'wednesday'
        WHEN 4 THEN 'thursday'
        WHEN 5 THEN 'friday'
        WHEN 6 THEN 'saturday'
    END AS day_name,
    QUARTER(date_day) AS quarter
FROM date_range
