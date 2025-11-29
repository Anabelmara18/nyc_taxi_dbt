{{ config(materialized='table') }}

select 
    payment_type as payment_type_id,
    case payment_type
        when 1 then 'Credit Card'
        when 2 then 'Cash'
        when 3 then 'No Charge'
        when 4 then 'Dispute'
        when 5 then 'Unknown'
        when 6 then 'Voided Trip'
        else 'Other'
    end as payment_type_desc
from {{ source('trip_source', 'silver') }}
group by payment_type
order by payment_type






