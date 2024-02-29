select
    id,
    financial_account_name,
    financial_account_description,
    financial_account_type,
    is_active,
    created_at,
    modified_at
from {{ source('application_db', 'financial_account') }}
