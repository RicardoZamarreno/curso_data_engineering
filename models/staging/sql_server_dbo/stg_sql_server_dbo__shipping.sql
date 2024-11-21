{{ config(materialized="view") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),

    renamed_casted as (
        select
        	{{ dbt_utils.surrogate_key([
				'order_id', 
				'tracking_id'
			])
		}} as tracking_id,
            shipping_service,
            user_id,
            status,
            CONVERT_TIMEZONE('UTC', estimated_delivery_at) AS estimated_delivery_at,
            CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at,
            case when _fivetran_deleted is null then false end as deleted,
            CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
        from src_orders
    )

select *
from renamed_casted
