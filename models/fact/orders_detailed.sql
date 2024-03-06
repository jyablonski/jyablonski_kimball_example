{{
    config(
        materialized='incremental',
        unique_key="order_detail_id"
    )
}}


with orders_detailed as (
    select
        order_detail.id as order_detail_id,
        "order".id as order_id,
        "order".store_id as store_id,
        product.id as product_id,
        "order".customer_id as customer_id,
        product_category.id as product_category_id,
        order_detail.quantity,
        product_price.id as product_price_id,
        product_price.price as product_price,
        order_detail.created_at as order_detail_created_at,
        order_detail.modified_at as order_detail_modified_at
    from {{ source('application_db', 'product') }}
        inner join {{ source('application_db', 'product_category') }} on product.product_category_id = product_category.id
        inner join {{ source('application_db', 'order_detail') }} on product.id = order_detail.product_id
        inner join {{ source('application_db', 'order') }} on order_detail.order_id = "order".id
        inner join {{ source('application_db', 'product_price') }} on order_detail.product_price_id = product_price.id
    {% if is_incremental() %}

        where "order_detail".modified_at > (select max(order_detail_modified_at) from {{ this }})

    {% endif %}

)

select *
from orders_detailed
