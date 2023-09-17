select
    customers.customer_id,
    sum(sales.total_amount) as total_sales
from {{ source('application_db', 'sales') }}
    inner join {{ source('application_db', 'customers') }} on sales.customer_id = customers.customer_id
group by customers.customer_id
