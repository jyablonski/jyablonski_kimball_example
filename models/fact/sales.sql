select
    sales.sale_date,
    customers.customer_key,
    products.product_key,
    sales.quantity,
    sales.total_amount
from {{ source('source', 'sales') }}
inner join {{ ref('customers') }} on sales.customer_id = customers.customer_key
inner join {{ ref('products') }} on sales.product_id = products.product_key