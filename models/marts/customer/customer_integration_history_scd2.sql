-- SCD2 Table to track customer integation history
-- typical use case is for billing, accounting, or for historical accuracy

with customer_records as (
    select
        id,
        customer_id,
        integration_type,
        is_active,
        created_at
    from {{ source('application_db', 'integration') }}
),

max_dates as (
    select
        customer_id,
        integration_type,
        max(created_at) as max_created_at
    from customer_records
    group by
        customer_id,
        integration_type
),

windowed as (
    select
        customer_id,
        integration_type,
        is_active,
        created_at as valid_from,
        lag(created_at, 1) over (
            partition by customer_id, integration_type order by created_at desc
        ) as valid_to
    from customer_records

),

final as (
    select
        windowed.customer_id,
        windowed.integration_type::text,
        windowed.is_active,
        windowed.valid_from,
        windowed.valid_to,
        case when windowed.valid_from = max_dates.max_created_at then 1 else 0 end as is_current_integration_record
    from windowed
        inner join max_dates
            on
                windowed.customer_id = max_dates.customer_id
                and windowed.integration_type = max_dates.integration_type
)

-- test 123
select *
from final
