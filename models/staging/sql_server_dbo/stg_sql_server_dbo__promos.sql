{{  
    config(materialized="view")
}}

with src_promos as (
    select *

    from {{source('sql_server_dbo', 'promos')}}
),

renamed_casted as (
    select
        md5(promo_id::varchar) AS promo_id,
        CAST(discount as float) as discount,
        status,
        case when _fivetran_deleted is null then false else true end as deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
    
    from
        src_promos
),

union_row as (

    select 
        md5('sin_promo') AS promo_id,
        0 as discount,
        'inactive' as status,
        false as deleted,
         convert_timezone('UTC', current_timestamp()) date_load
)

select *
from renamed_casted

UNION ALL

select *
from union_row

