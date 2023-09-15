with customer_records as (
    select
        customer_id,
        integration_type,
        is_active,
        created_at
    from {{ source('application_db', 'integrations') }}
),

max_dates as (
    select
        customer_id,
        max(created_at) as most_recent_record
    from customer_records
    group by customer_id
),

customer_integration_effective_dates as (
    select
        customer_id,
        integration_type,
        is_active,
        min(created_at) as valid_from,
        max(created_at) as max_created_date
    from customer_records
    group by customer_id, integration_type, is_active
),

final as (
    select
        customer_integration_effective_dates.customer_id,
        customer_integration_effective_dates.integration_type,
        customer_integration_effective_dates.is_active,
        valid_from,
        case when max_created_date = most_recent_record then '9999-12-31' else most_recent_record end as valid_to,
        case when max_created_date = most_recent_record then 1 else 0 end as is_current_record
    from customer_integration_effective_dates
    inner join max_dates on customer_integration_effective_dates.customer_id = max_dates.customer_id
)

select *
from final