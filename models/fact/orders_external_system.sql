/* PostgreSQL provides two native operators -> and ->> to help you query JSON data.

The operator -> returns JSON object field by key.
The operator ->> returns JSON object field by text.
*/

with orders_external as (
    select
        cast(external_data ->> 'id' as integer) as order_id,
        cast(external_data ->> 'sale_id' as integer) as sale_id,
        cast(external_data -> 'source' ->> 'transaction_timestamp' as timestamp) as source_timestamp,
        external_data -> 'source' ->> 'address' as source_address,
        cast(external_data -> 'source' ->> 'zip_code' as integer) as source_zip_code,
        external_data -> 'source' ->> 'state' as source_state,
        external_data -> 'source' ->> 'store' as source_store,
        created_at
    from {{ source('application_db', 'order_json') }}

)

select *
from orders_external
