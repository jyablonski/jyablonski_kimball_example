select
    product_id as product_key,
    product_name,
    product_category,
    product_price
from {{ source('application_db', 'products') }}
