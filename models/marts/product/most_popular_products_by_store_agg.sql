with store_products as (
    select
        stores.store_name,
        products.product_name,
        products.product_category_name,
        sum(quantity) as units_sold
    from {{ ref('orders_detailed') }}
        inner join {{ ref('stores') }} on orders_detailed.store_id = stores.store_id
        inner join {{ ref('products') }} on orders_detailed.product_id = products.product_id
    group by
        stores.store_name,
        products.product_name,
        products.product_category_name
)

select *
from store_products
