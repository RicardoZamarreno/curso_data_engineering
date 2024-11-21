{{ config(
    materialized='view'
    )
}}

with src_users as(
    select *
    from {{source('sql_server_dbo', 'users')}}
    ),

renamed_casted as (
    select 
        user_id,
        CONVERT_TIMEZONE('UTC', updated_at) AS updated_at,
        address_id,
        last_name,
        CONVERT_TIMEZONE('UTC', created_at) AS created_at,
        phone_number,
        first_name,
        email,
        case when _fivetran_deleted is null then false end deleted,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
    from src_users
    )

select * from renamed_casted