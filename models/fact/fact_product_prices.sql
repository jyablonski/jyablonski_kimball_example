{{
    config(
        materialized='incremental',
        unique_key="product_price_id"
    )
}}

-- dunno how to mingle this w/ orders_detailed just yet.  redundant info kinda

with product_prices as (
    select
        id as product_price_id,
        product_id,
        price,
        is_active,
        valid_from,
        valid_to,
        created_at as product_price_created_at,
        modified_at as product_price_modified_at
    from {{ source('application_db', 'product_price') }}
    {% if is_incremental() %}

        where modified_at > (select max(product_price_modified_at) from {{ this }})

    {% endif %}
)

select *
from product_prices
