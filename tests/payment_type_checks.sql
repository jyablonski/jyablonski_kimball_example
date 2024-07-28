-- check that every payment for an invoice has only 1 payment type on it
-- bc otherwise that'd be fucked up yo

with customer_payments as (
    select
        customer_id,
        invoice_id,
        count(payment_type_id) as payment_type_count
    from {{ ref('fact_payments') }}
    group by
        customer_id,
        invoice_id
)

select *
from customer_payments
where payment_type_count > 1
