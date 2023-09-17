/* PostgreSQL provides two native operators -> and ->> to help you query JSON data.

The operator -> returns JSON object field by key.
The operator ->> returns JSON object field by text.
*/

select
    order_id,
    cast(external_data ->> 'id' as integer) as external_data_id,
    cast(external_data ->> 'sale_id' as integer) as sale_id,
    cast(external_data -> 'source' ->> 'transaction_timestamp' as timestamp) as source_timestamp,
    external_data -> 'source' ->> 'address' as source_address,
    external_data -> 'source' ->> 'zip_code' as source_zip_code,
    external_data -> 'source' ->> 'state' as source_state,
    external_data -> 'source' ->> 'store' as source_store,
    created_at
from {{ source('application_db', 'orders') }}
