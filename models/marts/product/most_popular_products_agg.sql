with aggregate_products as (
    select
        dim_products.product_name,
        dim_products.product_category_name,
        sum(quantity) as units_sold
    from {{ ref('fact_orders_detailed') }}
        inner join {{ ref('dim_products') }} on fact_orders_detailed.product_id = dim_products.product_id
    group by
        dim_products.product_name,
        dim_products.product_category_name
)

select *
from aggregate_products
