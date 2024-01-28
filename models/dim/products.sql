select
    id as product_id,
    product_name,
    product_category_id,
    created_at,
    modified_at
from {{ source('application_db', 'product') }}
