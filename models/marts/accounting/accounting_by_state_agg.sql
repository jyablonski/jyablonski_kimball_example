with payments as (
    select
        dim_stores.state,
        fact_payments.financial_account_id,
        sum(fact_payments.payment_amount) as total_account_amount
    from {{ ref('fact_payments') }}
        inner join {{ ref('fact_orders_generalized') }} on fact_payments.order_id = fact_orders_generalized.order_id
        inner join {{ ref('dim_stores') }} on fact_orders_generalized.store_id = dim_stores.store_id
    group by
        dim_stores.state,
        fact_payments.financial_account_id
),

final as (
    select
        payments.state,
        dim_financial_accounts.financial_account_name,
        payments.total_account_amount,
        current_date as as_of_date
    from payments
        inner join {{ ref('dim_financial_accounts') }} on payments.financial_account_id = dim_financial_accounts.financial_account_id
)

select *
from final
