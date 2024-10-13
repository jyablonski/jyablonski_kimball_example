{{
    config(
        materialized='incremental',
        merge_strategy="append"
    )
}}

select
    id,
    row_number() over (partition by id order by created_at desc) as row_num,
    name,
    address,
    username,
    email,
    split_part(email, '@', 2) as domain,
    hire_date,
    status,
    color,
    salary,
    store_id,
    created_at,
    current_timestamp as __dbt_loaded_at
from {{ source('application_db', 'sales_data') }}

{% if is_incremental() %}

    -- select records with a 5-minute buffer for late-arriving data
    -- this data will get picked up on the subsequent run, and it makes it so
    -- that we don't have to worry about data arriving late
    where
        created_at > (select max(created_at) from {{ this }}) - interval '5 minutes'
        and id not in (select id from {{ this }})

{% endif %}
