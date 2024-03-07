with payments as (
    select
        orders_generalized.store_id,
        payments.financial_account_id,
        sum(payments.payment_amount) as total_account_amount
    from {{ ref('payments') }}
        inner join {{ ref('orders_generalized') }} on payments.order_id = orders_generalized.order_id
    group by
        orders_generalized.store_id,
        payments.financial_account_id
),

final as (
    select
        stores.store_name,
        financial_accounts.financial_account_name,
        payments.total_account_amount,
        current_date as as_of_date
    from payments
        inner join {{ ref('stores') }} on payments.store_id = stores.store_id
        inner join {{ ref('financial_accounts') }} on payments.financial_account_id = financial_accounts.financial_account_id
)

select *
from final
