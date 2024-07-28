with stores as (
    select
        id as store_id,
        store_name,
        street,
        city,
        state,
        zip_code,
        -- could have some condition for each store depending on state
        case when state in ('US', 'NY', 'IL') then 1 else 0 end as is_shipping_enabled_state,
        created_at,
        modified_at
    from {{ source('application_db', 'store') }}
)

select *
from stores
