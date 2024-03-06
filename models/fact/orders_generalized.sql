{{
    config(
        materialized='incremental',
        unique_key="order_id"
    )
}}

with orders_generalized as (
    select
        "order".id as order_id,
        invoice.id as invoice_id,
        "order".store_id as store_id,
        "order".customer_id,
        invoice.total_amount as invoice_total_amount,
        invoice.created_at as invoice_created_at,
        invoice.modified_at as invoice_modified_at,
        "order".created_at as order_created_at,
        "order".modified_at as order_modified_at
    from {{ source('application_db', 'order') }}
        inner join {{ source('application_db', 'invoice') }} on "order".id = invoice.order_id
    {% if is_incremental() %}

        where "order".modified_at > (select max(order_modified_at) from {{ this }})

    {% endif %}
)

select *
from orders_generalized
