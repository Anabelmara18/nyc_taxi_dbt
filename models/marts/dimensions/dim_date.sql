{{ config(materialized='table') }}

WITH calendar AS (
    SELECT explode(
        sequence(
            to_date('2020-01-01'),
            current_date(),
            interval 1 day
        )
    ) AS date_day
)

SELECT
    date_day AS date,
    year(date_day) AS year,
    month(date_day) AS month,
    day(date_day) AS day,
    weekofyear(date_day) AS week,
    quarter(date_day) AS quarter,
    date_format(date_day, 'MMMM') AS month_name,
    date_format(date_day, 'EEEE') AS day_name
FROM calendar
ORDER BY date_day




