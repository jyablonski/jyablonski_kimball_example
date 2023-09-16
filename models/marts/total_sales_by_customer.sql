select
    customers.customer_key,
    sum(sales.total_amount) as total_sales
from {{ ref('sales') }}
    inner join {{ ref('customers') }} on sales.customer_key = customers.customer_key
group by customers.customer_key
