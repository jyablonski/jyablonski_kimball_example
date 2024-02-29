with product_sales as (
    select
        product.id as product_id,
        product.product_name,
        product_category.product_category_name,
        order_detail.quantity,
        product_price.price as product_price,
        invoice.total_amount as invoice_total_amount
    from {{ source('application_db', 'product') }}
        inner join {{ source('application_db', 'product_category') }} on product.product_category_id = product_category.id
        inner join {{ source('application_db', 'order_detail') }} on product.id = order_detail.product_id
        inner join {{ source('application_db', 'invoice') }} on order_detail.order_id = invoice.order_id
        inner join {{ source('application_db', 'product_price') }} on order_detail.product_price_id = product_price.id
)

select *
from product_sales
