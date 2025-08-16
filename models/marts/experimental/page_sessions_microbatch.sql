{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='session_end',
    begin='2020-01-01',
    batch_size='month',
    unique_key="session_id",
    concurrent_batches=true
) }}

with user_sessions_detailed as (
    select
        session_id,
        user_id,
        session_start,
        session_end,
        device,
        country,

        -- duration in minutes (interval -> seconds -> minutes)
        (extract(epoch from (session_end - session_start)) / 60.0) as session_duration_min,

        case
            when (extract(epoch from (session_end - session_start)) / 60.0) <= 5 then 'Short'
            else 'Long'
        end as session_length_type,

        date_trunc('day', session_start) as session_date,
        date_trunc('month', session_start) as session_month,
        to_char(session_start, 'DY') as session_dow,
        (extract(dow from session_start) in (0, 6)) as is_weekend,  -- 0=Sun,6=Sat in PG
        now() as __created_at
    from {{ source('application_db', 'user_sessions') }}
)

select *
from user_sessions_detailed
