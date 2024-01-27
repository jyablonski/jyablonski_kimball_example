-- table with 1 row for each product in every order
with orders as (
    select
        "order".id as order_id,
        invoice.id as invoice_id,
        "order".customer_id,
        customer.customer_name,
        invoice.total_amount as order_total_amount,
        "order".created_at as order_created_at,
        "order".modified_at as order_modified_at
    from {{ source('application_db', 'order') }}
        inner join {{ source('application_db', 'customer') }}
            on "order".customer_id = customer.id
        inner join {{ source('application_db', 'invoice') }}
            on "order".id = invoice.order_id
)

select *
from orders
