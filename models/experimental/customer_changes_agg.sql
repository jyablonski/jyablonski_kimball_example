{{
    config(
        materialized='incremental',
        unique_key="customer_id"
    )
}}

/*
can test with this insert command after initially building the table

INSERT INTO source.customer_audit
(id, audit_type, customer_id, customer_name, customer_email, address, address_2, city, zip_code, state, country, created_at, modified_at)
VALUES(10, 1, 1, 'Johnny Allstar', 'johnny@allstar.com', '15 Sagefoot', null, 'Trabuco Canyon', 44433, 'CA', 'USA', CURRENT_TIMESTAMP + INTERVAL '2 days', CURRENT_TIMESTAMP + INTERVAL '2 days');
*/

-- grab all new records w/ a max timestamp > what we already have in the table
with all_incoming_records as (
    select
        customer_id,
        count(*) as num_records,
        max(modified_at) as max_modified_at
    from {{ source('application_db', 'customer_audit') }}
    {% if is_incremental() %}
        where modified_at > (select max(max_modified_at) from {{ this }})
    {% endif %}
    group by customer_id
),

-- find all new records that **dont** exist yet in the table that we can just insert
new_records_to_insert as (
    select *
    from all_incoming_records
    {% if is_incremental() %}
        where customer_id not in (select customer_id from {{ this }})
    {% endif %}
)

-- for all new customer ids that **already** exist in the table,
-- join them together and sum up their aggregations so we can update the table
-- afterwards
{% if is_incremental() %}
    ,

    existing_records_to_update as (
        select
            current_table.customer_id,
            current_table.num_records + all_incoming_records.num_records as num_records,
            all_incoming_records.max_modified_at
        from {{ this }} as current_table
            inner join all_incoming_records
                on current_table.customer_id = all_incoming_records.customer_id

    )

{% endif %}

select * from new_records_to_insert
{% if is_incremental() %}
    union all
    select * from existing_records_to_update
{% endif %}
