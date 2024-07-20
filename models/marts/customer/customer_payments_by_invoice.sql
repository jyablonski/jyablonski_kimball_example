with customer_payments_by_invoice as (
    select
        invoice_id,
        customer_id,
        sum(payment_amount) as invoice_paid_amount
    from {{ ref('fact_payments') }}
    group by
        invoice_id,
        customer_id
),

invoices as (
    select
        fact_orders_generalized.*,
        coalesce(customer_payments_by_invoice.invoice_paid_amount, 0) as invoice_paid_amount,
        case
            when
                customer_payments_by_invoice.invoice_paid_amount = fact_orders_generalized.invoice_total_amount then 1
            else 0
        end as is_invoice_closed
    from {{ ref('fact_orders_generalized') }}
        left join customer_payments_by_invoice on fact_orders_generalized.invoice_id = customer_payments_by_invoice.invoice_id
)

select *
from invoices
