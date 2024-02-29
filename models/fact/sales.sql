with sales as (
    select
        invoice.id as invoice_id,
        invoice.order_id,
        invoice.total_amount as invoice_total_amount,
        payment.amount as payment_amount,
        payment_type.payment_type,
        payment_type.payment_type_description,
        customer.id as customer_id,
        customer.customer_name,
        order_detail.product_id,
        order_detail.quantity,
        order_detail.product_price_id,
        product_price.price as product_price,
        product_price.valid_from as product_price_valid_from,
        product_price.valid_to as product_price_valid_to,
        invoice.created_at as invoice_created_at,
        invoice.modified_at as invoice_modified_at
    from {{ source('application_db', 'invoice') }}
        inner join {{ source('application_db', 'payment') }} on invoice.id = payment.invoice_id
        inner join {{ source('application_db', 'payment_type') }} on payment.payment_type_id = payment_type.id
        inner join {{ source('application_db', 'order_detail') }} on invoice.order_id = order_detail.order_id
        inner join {{ source('application_db', 'customer') }} on order_detail.order_id = customer.id
        inner join {{ source('application_db', 'product_price') }} on order_detail.product_price_id = product_price.id
)

select *
from sales
