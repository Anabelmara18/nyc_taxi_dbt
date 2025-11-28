{{ config(materialized='table') }}

select
    VendorID as vendor_id,
    case VendorID
        when 1 then 'Creative Mobile Technologies LLC'
        when 2 then 'VeriFone Inc'
        else 'Other'
    end as vendor_name
from {{ source('trip_source', 'silver') }}
group by VendorID
order by VendorID
