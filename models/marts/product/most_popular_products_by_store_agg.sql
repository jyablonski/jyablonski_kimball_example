with store_products as (
    select
        dim_stores.store_name,
        dim_products.product_name,
        dim_products.product_category_name,
        sum(quantity) as units_sold
    from {{ ref('fact_orders_detailed') }}
        inner join {{ ref('dim_stores') }} on fact_orders_detailed.store_id = dim_stores.store_id
        inner join {{ ref('dim_products') }} on fact_orders_detailed.product_id = dim_products.product_id
    group by
        dim_stores.store_name,
        dim_products.product_name,
        dim_products.product_category_name
)

select *
from store_products
