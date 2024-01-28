with customer_payment_invoice_sum as (
    select
        customer_id,
        invoice_id,
        sum(amount) as total_amount_paid
    from {{ ref('customer_payment_history') }}
    group by customer_id, invoice_id
),

pending_invoices as (
    select
        customer_orders_aggregated.order_id,
        customer_orders_aggregated.invoice_id,
        customer_orders_aggregated.customer_name,
        customer_orders_aggregated.order_total_amount,
        coalesce(customer_payment_invoice_sum.total_amount_paid, 0) as total_amount_paid,
        order_total_amount - coalesce(customer_payment_invoice_sum.total_amount_paid, 0) as total_amount_remaining,
        date_part('day', order_created_at - current_date) as days_outstanding,
        order_created_at,
        order_modified_at
    from {{ ref('customer_orders_aggregated') }}
        left join customer_payment_invoice_sum
            on customer_orders_aggregated.invoice_id = customer_payment_invoice_sum.invoice_id
    where coalesce(customer_payment_invoice_sum.total_amount_paid, 0) != customer_orders_aggregated.order_total_amount
)

select *
from pending_invoices
