select
    sales.sale_date,
    sales.quantity,
    sales.total_amount,
    customers.customer_email
from {{ ref('sales') }}
    inner join {{ ref('customers') }} on sales.customer_key = customers.customer_key
