{{ config(materialized="view") }}

with
    src_orders as (select * from {{ source("sql_server_dbo", "orders") }}),

    src_order_items as (select product_id, order_id from {{ source("sql_server_dbo", "order_items") }})

        select
            src_order_items.order_id,
            shipping_cost,
            address_id,
            CONVERT_TIMEZONE('UTC', created_at) AS created_at, 
            md5(promo_id::varchar) as promo_id,
            order_cost,
            user_id,
            order_total,
            CONVERT_TIMEZONE('UTC', delivered_at) AS delivered_at,
            tracking_id,
            case when _fivetran_deleted is null then false end as deleted,
            CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
        from src_orders join
    src_order_items on
    src_orders.order_id = src_order_items.order_id
    



