select
    id as product_id,
    product_name,
    product_category_id,
    product_price
from {{ source('application_db', 'product') }}
