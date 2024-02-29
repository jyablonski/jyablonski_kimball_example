{{ config(materialized='ephemeral') }}

with customer_payment_invoice_sum as (
    select
        customer_id,
        invoice_id,
        sum(amount) as total_amount_paid
    from {{ ref('customer_payment_history') }}
    group by
        customer_id,
        invoice_id
)

select *
from customer_payment_invoice_sum
