with aggregate_products as (
    select
        products.product_name,
        products.product_category_name,
        sum(quantity) as units_sold
    from {{ ref('orders_detailed') }}
        inner join {{ ref('products') }} on orders_detailed.product_id = products.product_id
    group by
        products.product_name,
        products.product_category_name
)

select *
from aggregate_products
