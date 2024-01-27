select
    customer.id as customer_id,
    sum(sale.total_amount) as total_sales
from {{ source('application_db', 'sale') }}
    inner join {{ source('application_db', 'customer') }} on sale.customer_id = customer.id
group by customer.id
