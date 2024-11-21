{{ config(materialized="view") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),

    src_order_items as (select * from {{ source("sql_server_dbo", "order_items") }}),

    renamed_casted as (
        select
            order_id,
            shipping_cost,
            address_id,
            CONVERT_TIMEZONE('UTC', created_at) AS created_at, 
            md5(promo_id::varchar) as promo_id,
            order_cost,
            user_id,
            order_total,
            CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at,
        	{{ dbt_utils.surrogate_key([
				'order_id', 
				'tracking_id'
			])
		    }} as tracking_id,
            case when _fivetran_deleted is null then false end as deleted,
            CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
        from src_orders
    )

select *
from renamed_casted join
    src_order_items on
    renamed_casted.order_id = src_order_items.order_id
