with customer_records as (
    select
        integration_id,
        customer_id,
        integration_type,
        is_active,
        created_at
    from {{ source('application_db', 'integrations') }}
),

max_dates as (
    select
        customer_id,
        integration_type,
        max(created_at) as max_created_at
    from customer_records
    group by customer_id, integration_type
),

windowed as (
    select
        customer_id,
        integration_type,
        is_active,
        created_at,
        created_at as valid_from,
        lag(created_at, 1) over (partition by customer_id, integration_type order by created_at desc) as valid_to
    from customer_records

),

final as (
    select
        windowed.customer_id,
        windowed.integration_type,
        windowed.is_active,
        windowed.valid_from,
        windowed.valid_to,
        case when windowed.valid_from = max_dates.max_created_at then 1 else 0 end as is_current_record
    from windowed
    inner join max_dates on windowed.customer_id = max_dates.customer_id
)

select *
from final

-- active from sep 15 to sep 22
-- inactive from sep 22 to sep 29
-- active from sep 29 to present