-- customers who made a purchase in the last year, but not in the last 30 days 
-- that we could potentially market to

with past_customer_orders as (
    select
        fact_orders_detailed.order_detail_id,
        dim_customers.customer_name,
        dim_customers.customer_email,
        dim_products.product_name,
        dim_products.product_category_name
    from {{ ref('fact_orders_detailed') }}
        inner join {{ ref('dim_customers') }} on fact_orders_detailed.customer_id = dim_customers.customer_id
        inner join {{ ref('dim_products') }} on fact_orders_detailed.product_id = dim_products.product_id
    where
        fact_orders_detailed.order_detail_created_at < current_date - interval '30 days'
        and fact_orders_detailed.order_detail_created_at >= current_date - interval '1 year'
)

select *
from past_customer_orders
