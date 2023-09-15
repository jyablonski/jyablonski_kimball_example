with customer_records as (
    select
        customer_id,
        integration_type,
        is_active,
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'integration_type', 'is_active', 'created_at']) }} as scd_id,
        created_at
    from {{ source('application_db', 'integrations') }}
),

windowed as (
    select
        scd_id,
        min(created_at) over (partition by scd_id) as valid_from,
        nullif(
            max(created_at) over (partition by scd_id),
            max(created_at) over ()
        ) as valid_to
    from customer_records
    group by 1
)

select *
from windowed