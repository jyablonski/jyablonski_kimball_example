{{
    config(
        materialized='incremental',
        unique_key="id",
        on_schema_change='append_new_columns',
        post_hook="delete from {{ this }} where id not in (select id from {{ source('application_db', 'order') }} )"
    )
}}
-- post hook - after running, delete any record in this table that has been deleted in the source table
{% set run_date = get_run_date() %}

select
    id,
    customer_id as c_id,
    created_at,
    modified_at,
    '{{ run_date }}'::date as hell

from {{ source('application_db', 'order') }}

{% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    -- (uses > to include records whose timestamp occurred since the last run of this model)
    where id not in (select id from {{ this }})

{% endif %}
