{{ config(materialized='materialized_view') }}

-- the first time it builds it does the create materialized view if not exists and passes in this query
-- in subsequent builds it calls `refresh materialized view "postgres"."marts"."product_price_history_scd2"`

-- during --full-refresh builds, it will first create a tmp materialized view to ensure the sql actually runs
-- before dropping the current materialized view
-- `create materialized view if not exists "postgres"."marts"."product_price_history_scd2__dbt_tmp`
-- `alter materialized view "postgres"."marts"."product_price_history_scd2" rename to "product_price_history_scd2__dbt_backup"`
with products as (
    select
        product.id,
        product_price.id as product_price_id,
        product.product_name,
        product_price.price,
        product_price.is_active,
        product_price.valid_from,
        product_price.valid_to,
        product_price.created_at,
        product_price.modified_at
    from {{ source('application_db', 'product_price') }}
        inner join {{ source('application_db', 'product') }}
            on product_price.product_id = product.id
    order by product_name, valid_from
)

select *
from products
