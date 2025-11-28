{{ config(materialized='table') }}

WITH base AS (

    SELECT
        vendorid,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        passenger_count,
        trip_distance,
        ratecodeid,
        store_and_fwd_flag,
        pulocationid,
        dolocationid,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        congestion_surcharge,
        airport_fee

    FROM {{ ref('stg_trip') }}
),

engineered AS (

    SELECT
        *,
        -- Trip date
        CAST(tpep_pickup_datetime AS DATE) AS trip_date,

        -- Duration in minutes
        (unix_timestamp(tpep_dropoff_datetime) - unix_timestamp(tpep_pickup_datetime)) / 60
            AS trip_duration_minutes,

        -- Fare per mile
        fare_amount / NULLIF(trip_distance, 0) AS fare_per_mile,

        -- Distance category
        CASE
            WHEN trip_distance < 1 THEN 'short'
            WHEN trip_distance < 5 THEN 'medium'
            ELSE 'long'
        END AS distance_category,

        -- Fare category
        CASE
            WHEN fare_amount <= 10 THEN 'low'
            WHEN fare_amount <= 50 THEN 'medium'
            ELSE 'high'
        END AS fare_category,

        -- Duration category
        CASE
            WHEN (unix_timestamp(tpep_dropoff_datetime) - unix_timestamp(tpep_pickup_datetime)) / 60 <= 10
                THEN 'quick'
            WHEN (unix_timestamp(tpep_dropoff_datetime) - unix_timestamp(tpep_pickup_datetime)) / 60 <= 30
                THEN 'normal'
            ELSE 'long'
        END AS duration_category

    FROM base
)

SELECT * FROM engineered;

