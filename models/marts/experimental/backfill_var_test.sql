{{
  config(
    materialized='incremental',
    unique_key='session_id',
    on_schema_change='sync_all_columns'
  )
}}

-- these don't have to be set in `dbt_project.yml` because we're passing in defaults
{% set backfill_from = var('BACKFILL_FROM_DATE', none) %}
{% set backfill_to = var('BACKFILL_TO_DATE', none) %}

with source_data as (
    select
        session_id,
        user_id,
        session_start,
        session_end,
        device,
        country,
        current_timestamp as __created_at
    from {{ source('application_db', 'user_sessions') }}

    -- Backfill mode: use specified date range
    {% if backfill_from and backfill_to %}
    where
        session_start >= '{{ backfill_from }}'
        and session_start < '{{ backfill_to }}'
        
    -- Standard incremental mode: only process new records
    {% elif is_incremental() %}
        where
            session_start > (select max(session_start) from {{ this }})

    -- if the vars aren't set and we're not in incremental mode, then backfill only 2020 data
    {% else %}
    where
        session_start >= '2020-01-01'
        and session_start < '2021-01-01'
  {% endif %}
)

select *
from source_data
