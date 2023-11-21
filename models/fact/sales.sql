select
    sales.sale_id,
    sales.sale_date,
    sales.customer_id,
    sales.product_id,
    sales.quantity,
    sales.total_amount,
    sales.created_at,
    invoices.invoice_id,
    invoices.is_voided,
    invoices.created_at as invoice_created_at,
    invoices.modified_at as invoice_modified_at,
    payments.payment_id,
    payments.amount,
    payments.payment_type,
    payments.payment_type_info,
    payments.created_at as payment_created_at,
    payments.modified_at as payment_modified_at
from {{ source('application_db', 'sales') }}
    inner join {{ source('application_db', 'invoices') }} on sales.sale_id = invoices.sale_id
    inner join {{ source('application_db', 'payments') }} on invoices.invoice_id = payments.invoice_id
{{ env_limit(2) }}
