{{
    config(
        materialized='incremental',
        unique_key="order_id"
    )
}}

with orders as (
    select
        "order".id as order_id,
        "order".customer_id,
        customer.customer_name,
        order_detail.product_id,
        product.product_name,
        order_detail.quantity,
        product_price.price as product_price,
        invoice.total_amount as invoice_total_amount,
        "order".created_at as order_created_at,
        "order".modified_at as order_modified_at
    from {{ source('application_db', 'order') }}
        inner join {{ source('application_db', 'customer') }} on "order".customer_id = customer.id
        inner join {{ source('application_db', 'order_detail') }} on "order".id = order_detail.order_id
        inner join {{ source('application_db', 'product') }} on order_detail.product_id = product.id
        inner join {{ source('application_db', 'product_price') }} on order_detail.product_price_id = product_price.id
        inner join {{ source('application_db', 'invoice') }} on "order".id = invoice.order_id
    {% if is_incremental() %}

        where "order".id not in (select order_id from {{ this }})

    {% endif %}
)

select *
from orders
