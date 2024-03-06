with customer_payments_by_invoice as (
    select
        invoice_id,
        customer_id,
        sum(payment_amount) as invoice_amount_paid
    from {{ ref('payments') }}
    group by
        invoice_id,
        customer_id
),

invoices as (
    select
        orders_generalized.*,
        coalesce(customer_payments_by_invoice.invoice_amount_paid, 0) as invoice_amount_paid,
        case
            when
                customer_payments_by_invoice.invoice_amount_paid = orders_generalized.invoice_total_amount then 1
            else 0
        end as is_invoice_closed
    from {{ ref('orders_generalized') }}
        left join customer_payments_by_invoice on orders_generalized.invoice_id = customer_payments_by_invoice.invoice_id
)

select *
from invoices
