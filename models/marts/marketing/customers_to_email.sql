-- customers who made a purchase in the last year, but not in the last 30 days 
-- that we could potentially market to

with customer_orders as (
    select
        orders_detailed.order_detail_id,
        customers.customer_name,
        customers.customer_email,
        products.product_name,
        products.product_category_name
    from {{ ref('orders_detailed') }}
        inner join {{ ref('customers') }} on orders_detailed.customer_id = customers.customer_id
        inner join {{ ref('products') }} on orders_detailed.product_id = products.product_id

)

select *
from customer_orders
