{{ config(severity = 'warn') }}



select *
from {{ ref('dim_stores') }}
where is_shipping_enabled_state != 1
