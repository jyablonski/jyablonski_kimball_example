{{
    config(
        materialized='incremental',
        unique_key="sale_id",
        post_hook="delete from {{ this }} where sale_id not in (select sale_id from {{ source('application_db', 'sales') }} )",
        merge_update_columns = ['customer_id', 'product_id', 'total_amount', 'created_at', 'modified_at'],
    )
}}
-- post hook - after running, delete any record in this table that has been deleted in the source table
-- merge updsate columns only works for snowflake i guess, not postgres

select *

from {{ source('application_db', 'sales') }}

{% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    -- (uses > to include records whose timestamp occurred since the last run of this model)
    where modified_at > (select max(modified_at) from {{ this }})

{% endif %}
