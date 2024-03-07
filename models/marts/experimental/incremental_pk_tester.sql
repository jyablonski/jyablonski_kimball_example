{{
    config(
        materialized='incremental',
        unique_key="id",
        on_schema_change='append_new_columns',
        post_hook="delete from {{ this }} where id not in (select id from {{ source('application_db', 'order') }} )"
    )
}}
-- post hook - after running, delete any record in this table that has been deleted in the source table
-- {% set run_date = get_run_date() %}

select
    id,
    customer_id as c_id,
    created_at,
    modified_at,
    current_timestamp as added_at

from {{ source('application_db', 'order') }}

{% if is_incremental() %}

    -- only select records that are 1 day greater than the current date
    where date(created_at) = (select max(date(created_at)) + interval '1 day' from {{ this }})

{% endif %}
