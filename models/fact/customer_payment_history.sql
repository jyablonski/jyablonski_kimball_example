with payments as (
    select
        payment.id as payment_id,
        payment.amount,
        payment.payment_type_detail,
        payment.invoice_id,
        payment.financial_account_id,
        customers.customer_id,
        customers.customer_name,
        financial_account.financial_account_name,
        payment_type.payment_type,
        payment.created_at,
        payment.modified_at
    from {{ source('application_db', 'payment') }}
        inner join {{ source('application_db', 'payment_type') }}
            on payment.payment_type_id = payment_type.id
        inner join {{ source('application_db', 'financial_account') }}
            on payment.financial_account_id = financial_account.id
        inner join {{ source('application_db', 'invoice') }}
            on payment.invoice_id = invoice.id
        inner join {{ source('application_db', 'order') }}
            on invoice.order_id = "order".id
        inner join {{ ref('customers') }}
            on "order".customer_id = customers.customer_id
)

select *
from payments
