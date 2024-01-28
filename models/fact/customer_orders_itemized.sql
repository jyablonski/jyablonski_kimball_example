-- table with 1 row for each product in every order
with orders as (
    select
        {{ dbt_utils.generate_surrogate_key(['"order".id', 'order_detail.id']) }} as order_item_pk,
        "order".id as order_id,
        order_detail.id as order_detail_id,
        invoice.id as invoice_id,
        "order".customer_id,
        customers.customer_name,
        order_detail.product_id,
        order_detail.product_price_id,
        product.product_name,
        product_category.product_category_name,
        order_detail.quantity,
        product_price.price,
        "order".created_at,
        "order".modified_at
    from {{ source('application_db', 'order') }}
        inner join {{ ref('customers') }}
            on "order".customer_id = customers.customer_id
        inner join {{ source('application_db', 'order_detail') }}
            on "order".id = order_detail.order_id
        inner join {{ source('application_db', 'product') }}
            on order_detail.product_id = product.id
        inner join {{ source('application_db', 'product_category') }}
            on product.product_category_id = product_category.id
        inner join {{ source('application_db', 'product_price') }}
            on order_detail.product_price_id = product_price.id
        inner join {{ source('application_db', 'invoice') }}
            on "order".id = invoice.order_id
)

select *
from orders
