with products as (
    select
        product.id,
        product_price.id as product_price_id,
        product.product_name,
        product_price.price,
        product_price.is_active,
        product_price.valid_from,
        product_price.valid_to,
        product_price.created_at,
        product_price.modified_at
    from {{ source('application_db', 'product_price') }}
        inner join {{ source('application_db', 'product') }}
            on product_price.product_id = product.id
    order by product_name, valid_from
)

select *
from products
