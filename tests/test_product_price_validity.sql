-- shouldn't have any active product prices with a valid_to timestamp
-- that's less than current times
with invalid_product_prices as (
    select id
    from {{ source('application_db', 'product_price') }}
    where
        valid_to < current_timestamp
        and is_active = true
)

select *
from invalid_product_prices
