-- customers who made a purchase in the last year, but not in the last 30 days 
-- that we could potentially market to

with past_customer_orders as (
    select
        orders_detailed.order_detail_id,
        customers.customer_name,
        customers.customer_email,
        products.product_name,
        products.product_category_name
    from {{ ref('orders_detailed') }}
        inner join {{ ref('customers') }} on orders_detailed.customer_id = customers.customer_id
        inner join {{ ref('products') }} on orders_detailed.product_id = products.product_id
    where
        orders_detailed.order_detail_created_at < current_date - interval '30 days'
        and orders_detailed.order_detail_created_at >= current_date - interval '1 year'
)

select *
from past_customer_orders
