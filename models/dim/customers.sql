select
    id as customer_id,
    customer_name,
    customer_email,
    created_at,
    modified_at
from {{ source('application_db', 'customer') }}
