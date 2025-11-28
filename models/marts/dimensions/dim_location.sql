{{ config(materialized='table') }}


with locations as (
    select distinct PULocationID as location_id from {{ source('trip_source', 'silver') }}
    union
    select distinct DOLocationID as location_id from {{ source('trip_source', 'silver') }}
)

select
    location_id,
    case 
        when location_id = 1 then 'Location A'
        when location_id = 2 then 'Location B'
        when location_id = 3 then 'Location C'
        else 'Other'
    end as location_name
from locations
order by location_id



