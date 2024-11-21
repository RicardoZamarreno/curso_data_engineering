{{ config(materialized="view") }}

with
    src_addresses as (select * from {{ source("sql_server_dbo", "addresses") }}),

    renamed_casted as (
        select
            address_id,
            case when length(zipcode) not in (5, 9) then 0 else zipcode end as zipcode,
            country,
            lower(trim(address)) as address,
            state,
            case when _fivetran_deleted is null then false end as deleted,
            convert_timezone('UTC', _fivetran_synced) as date_load
        from src_addresses
    )

select *
from renamed_casted
