select
    customer_id as customer_key,
    customer_name,
    customer_email
from {{ source('application_db', 'customers') }}
