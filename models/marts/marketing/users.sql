{{ config(materialized="table")}}

WITH stg_users AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__users') }}
    ),

    stg_addresses AS (
    SELECT * 
    FROM {{ ref('stg_sql_server_dbo__addresses') }}
    ),

    renamed_casted AS (
    SELECT
        user_id
        , first_name
        , last_name
        , email
        , phone_number
        , created_at
        , updated_at
        , address_id
        , date_load
    FROM stg_users
    ),

    renamed_address AS (
    SELECT
        zipcode,
        address,
        address_id
    
    FROM
        stg_addresses
    )


SELECT * 
FROM renamed_casted left join
renamed_address on
renamed_address.address_id = renamed_casted.address_id
