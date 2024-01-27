select
    sale.id as sale_id,
    sale.sale_date,
    sale.customer_id,
    sale.product_id,
    sale.quantity,
    sale.total_amount,
    sale.created_at,
    invoice.id as invoice_id,
    invoice.is_voided,
    invoice.created_at as invoice_created_at,
    invoice.modified_at as invoice_modified_at,
    payment.id as payment_id,
    payment.amount,
    payment.payment_type,
    payment.payment_type_info,
    payment.created_at as payment_created_at,
    payment.modified_at as payment_modified_at
from {{ source('application_db', 'sale') }}
    inner join {{ source('application_db', 'invoice') }} on sale.id = invoice.sale_id
    inner join {{ source('application_db', 'payment') }} on invoice.id = payment.invoice_id
{{ env_limit(2) }}
