select
    integration.id,
    integration.customer_id,
    customers.customer_email,
    integration.integration_type,
    integration.is_active,
    integration.created_at,
    integration.modified_at
from {{ source('application_db', 'integration') }}
    inner join {{ ref('customers') }} on integration.customer_id = customers.customer_id
