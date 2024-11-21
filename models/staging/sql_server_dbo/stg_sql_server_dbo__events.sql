{{ config(materialized="view") }}

with
    src_events as (select * from {{ source("sql_server_dbo", "events") }}),

    renamed_casted as (
        select
            event_id,
            page_url,
            event_type,
            user_id,
            product_id,
            session_id,
            convert_timezone('UTC', created_at) as created_at,
            order_id,
            case when _fivetran_deleted is null then false end as deleted,
            convert_timezone('UTC', _fivetran_synced) as date_load
        from src_events
    )

select *
from renamed_casted
