with outstanding_invoices as (
    select
        *,
        invoice_total_amount - invoice_amount_paid as invoice_remaining_balance
    from {{ ref('customer_payments_by_invoice') }}
    where is_invoice_closed = 0
),

customer_last_payment_on_invoice as (
    -- start with outstanding invoices to limit the fk out of the data passed into here
    select
        payments.invoice_id,
        max(payments.payment_created_at) as latest_payment_made
    from outstanding_invoices
        left join {{ ref('payments') }} on outstanding_invoices.invoice_id = payments.invoice_id
    group by payments.invoice_id


),

final as (
    select
        outstanding_invoices.invoice_id,
        customers.customer_name,
        customers.customer_email,
        outstanding_invoices.invoice_total_amount,
        outstanding_invoices.invoice_amount_paid,
        outstanding_invoices.invoice_remaining_balance,
        outstanding_invoices.invoice_created_at,
        latest_payment_made
    from outstanding_invoices
        inner join {{ ref('customers') }} on outstanding_invoices.customer_id = customers.customer_id
        left join customer_last_payment_on_invoice on outstanding_invoices.invoice_id = customer_last_payment_on_invoice.invoice_id
)

select *
from final
