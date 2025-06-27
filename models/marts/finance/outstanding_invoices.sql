with outstanding_invoices as (
    select
        *,
        invoice_total_amount - invoice_paid_amount as invoice_remaining_balance
    from {{ ref('customer_payments_by_invoice') }}
    where
        is_invoice_closed = 0
),

customer_last_payment_on_invoice as (
    -- start with outstanding invoices to limit the fk out of the data passed into here
    select
        fact_payments.invoice_id,
        max(fact_payments.payment_created_at) as latest_payment_made
    from outstanding_invoices
        left join {{ ref('fact_payments') }} on outstanding_invoices.invoice_id = fact_payments.invoice_id
    group by fact_payments.invoice_id

),

final as (
    select
        outstanding_invoices.invoice_id,
        dim_customers.customer_name,
        dim_customers.customer_email,
        outstanding_invoices.invoice_total_amount,
        outstanding_invoices.invoice_paid_amount,
        outstanding_invoices.invoice_remaining_balance,
        outstanding_invoices.invoice_created_at,
        latest_payment_made
    from outstanding_invoices
        inner join {{ ref('dim_customers') }} on outstanding_invoices.customer_id = dim_customers.customer_id
        left join customer_last_payment_on_invoice on outstanding_invoices.invoice_id = customer_last_payment_on_invoice.invoice_id
    where
        dim_customers.is_latest_record = 1
)

select *
from final
