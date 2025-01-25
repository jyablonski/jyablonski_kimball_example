{{
    config(
        materialized='incremental',
        unique_key="email_id"
    )
}}


with emails as (
    select
        id as email_id,
        email_name,
        messages,
        created_at,
        modified_at,
        current_timestamp as dbt_created_at
    from {{ source('application_db', 'emails') }}
    {% if is_incremental() %}

        where modified_at > (select max(dbt_created_at) from {{ this }})

    {% endif %}
)

select *
from emails
