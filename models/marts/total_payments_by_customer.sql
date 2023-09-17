select
    payment_id,
    sale_id,
    customer_id,
    amount,
    payment_type,
    payment_created_at
from {{ ref('sales') }}
