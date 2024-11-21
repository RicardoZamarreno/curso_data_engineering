{{ config(materialized = 'view')}}

with e as (SELECT *

FROM {{ref('stg_sql_server_dbo__events')}}),

u as (select *
from {{ref("stg_sql_server_dbo__users")}})

select
    e.session_id,
    u.user_id,
    u.first_name,
    u.email,
    MIN(e.created_at) first_event_time_UTC,
    MAX(e.created_at) last_event_time_UTC,
    DATEDIFF(minute, first_event_time_UTC, last_event_time_UTC) session_length_minutes,
    SUM(case when event_type = 'page_view' then 1 else 0 end) as page_view,
    SUM(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart,
    SUM(case when event_type = 'checkout' then 1 else 0 end) as checkout,
    SUM(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped

    FROM e join
            u on e.user_id = u.user_id
    GROUP BY e.session_id, u.user_id, u.first_name, u.email