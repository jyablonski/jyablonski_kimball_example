select
    id as customer_id,
    customer_name,
    customer_email
from {{ source('application_db', 'customer') }}
