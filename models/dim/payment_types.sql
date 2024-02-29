select
    id,
    payment_type,
    payment_type_description,
    created_at,
    modified_at
from {{ source('application_db', 'payment_type') }}
