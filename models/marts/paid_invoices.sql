with customer_payment_invoice_sum as (
    select *
    from {{ ref('customer_payment_invoice_sum') }}
),

paid_invoices as (
    select
        customer_orders_aggregated.order_id,
        customer_orders_aggregated.invoice_id,
        customer_orders_aggregated.customer_name,
        customer_orders_aggregated.order_total_amount,
        order_created_at,
        order_modified_at
    from {{ ref('customer_orders_aggregated') }}
        left join customer_payment_invoice_sum
            on customer_orders_aggregated.invoice_id = customer_payment_invoice_sum.invoice_id
    where coalesce(customer_payment_invoice_sum.total_amount_paid, 0) = customer_orders_aggregated.order_total_amount
)

select *
from paid_invoices
