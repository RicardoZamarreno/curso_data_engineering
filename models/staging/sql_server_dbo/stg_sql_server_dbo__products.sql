{{ config(materialized="view") }}

with
    src_products as (select * from {{ source("sql_server_dbo", "products") }}),

    renamed_casted as (
        select
            product_id,
            price,
            name,
            inventory,
            case when _fivetran_deleted is null then false end as deleted,
            convert_timezone('UTC', _fivetran_synced) as date_load
        from src_products
    )

select *
from renamed_casted