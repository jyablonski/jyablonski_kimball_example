{{
    config(
        materialized='incremental',
        unique_key="id",
        post_hook="delete from {{ this }} where id not in (select id from {{ source('application_db', 'order') }} )"
    )
}}
-- post hook - after running, delete any record in this table that has been deleted in the source table

select *

from {{ source('application_db', 'order') }}

{% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    -- (uses > to include records whose timestamp occurred since the last run of this model)
    where id not in (select id from {{ this }})

{% endif %}
