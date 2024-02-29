{{
    config(
        materialized='incremental',
        unique_key="payment_id"
    )
}}


with payments as (
    select
        payment.id as payment_id,
        payment.amount as payment_amount,
        payment_type.payment_type,
        payment_type.payment_type_description,
        invoice.id as invoice_id,
        invoice.total_amount as invoice_total_amount,
        financial_account.financial_account_name,
        financial_account.financial_account_type
    from {{ source('application_db', 'payment') }}
        inner join {{ source('application_db', 'payment_type') }} on payment.payment_type_id = payment_type.id
        inner join {{ source('application_db', 'invoice') }} on payment.invoice_id = invoice.id
        inner join {{ source('application_db', 'financial_account') }} on payment.financial_account_id = financial_account.id
    {% if is_incremental() %}

        where "payment".id not in (select payment_id from {{ this }})

    {% endif %}
)

select *
from payments
