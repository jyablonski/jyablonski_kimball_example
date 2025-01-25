{{
    config(
        materialized='incremental',
        unique_key="payment_id"
    )
}}


with payments as (
    select
        payment.id as payment_id,
        payment_type.id as payment_type_id,
        invoice.id as invoice_id,
        "order".id as order_id,
        "order".customer_id,
        financial_account.id as financial_account_id,
        payment.amount as payment_amount,
        payment.created_at as payment_created_at,
        payment.modified_at as payment_modified_at
    from {{ source('application_db', 'payment') }}
        inner join {{ source('application_db', 'payment_type') }} on payment.payment_type_id = payment_type.id
        inner join {{ source('application_db', 'invoice') }} on payment.invoice_id = invoice.id
        inner join {{ source('application_db', 'order') }} on invoice.order_id = "order".id
        inner join {{ source('application_db', 'financial_account') }} on payment_type.financial_account_id = financial_account.id
    {% if is_incremental() %}

        where payment.modified_at > (select max(payment_created_at) from {{ this }})

    {% endif %}
)

select *
from payments
