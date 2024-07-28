select
    product.id as product_id,
    product.product_name,
    product_category.product_category_name,
    product.created_at,
    product.modified_at
from {{ source('application_db', 'product') }}
    inner join {{ source('application_db', 'product_category') }} on product.product_category_id = product_category.id
