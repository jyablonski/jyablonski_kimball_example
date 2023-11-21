{{
    config(
        materialized='incremental',
        unique_key="sale_id",
    )
}}

select *

from {{ source('application_db', 'sales') }}

{% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    -- (uses > to include records whose timestamp occurred since the last run of this model)
    where modified_at > (select max(modified_at) from {{ this }})

{% endif %}
