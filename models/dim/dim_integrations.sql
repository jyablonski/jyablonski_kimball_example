select
    integration.id,
    integration.customer_id,
    dim_customers.customer_email,
    integration.integration_type,
    integration.is_active,
    integration.created_at,
    integration.modified_at
from {{ source('application_db', 'integration') }}
    inner join {{ ref('dim_customers') }} on integration.customer_id = dim_customers.customer_id
