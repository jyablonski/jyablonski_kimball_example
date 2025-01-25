{{ config(
    materialized = 'incremental',
    unique_key="audit_id",
    incremental_strategy='merge',
    indexes=[
      {'columns': ['customer_id']},
    ]
) }}

/* scd2 table
the idea is whenever there's a change in the customer_audit table, we
grab the change for that `customer_id` AND their previous state so
that we can calculate accurate validity periods for both records

`is_deleted`, `is_current_record`, and `is_latest_record` are flags that help us
identify the state of the record.

- `is_deleted` indicates whether the record was deleted. only present on the most recent record
- `is_current_record` indicates the most recent record for an active customer id
- `is_latest_record` indicates the most recent record for a customer id, regardless
of whether it's active or not

both incremental and full refresh runs work as expected

pulling minimal amount of columns like audit_id, customer_id and modified_at
at the beginning to reduce the amount of data we're pulling from the source table.
at the end we join the audit id back up to the source table to grab the rest of the
columns.

postgres has merge now as of version 15 yeet bby
*/

with new_audits as (
    select
        id as audit_id,
        audit_type,
        customer_id,
        modified_at
    from {{ source('application_db', 'customer_audit') }}
    {% if is_incremental() %}
        where modified_at > (select max(valid_from) from {{ this }})
    {% endif %}
),

{% if is_incremental() %}
    new_and_prev_audits as (
        select
            audit_id,
            null as audit_type, -- null bc we dont care whether the previous record was an insert or update
            customer_id,
            valid_from as modified_at
        from {{ this }}
        where
            customer_id in (select customer_id from new_audits)
            and is_current_record = 1
        union all
        select
            audit_id,
            audit_type, -- we care about the audit type for the new record bc it might be deleted
            customer_id,
            modified_at
        from new_audits
    ),
{% endif %}

validity_periods as (
    select
        audit_id,
        customer_id,
        modified_at as valid_from,
        case
            when
                -- if the record is deleted, then set valid_to = valid_from for new record
                audit_type = 2 then modified_at
            else
                coalesce(lead(modified_at) over (
                    partition by customer_id
                    order by modified_at
                ), '9999-12-31')
        end
        as valid_to,
        row_number() over (
            partition by customer_id
            order by modified_at desc
        ) as most_recent_record
    from {% if is_incremental() %}new_and_prev_audits {% else %} new_audits {% endif %}
    -- this is needed during incremental runs to update the previous record as well as to insert the new one
),

final as (
    select
        validity_periods.audit_id,
        validity_periods.customer_id,
        customer_audit.customer_name,
        customer_audit.customer_email,
        customer_audit.address,
        customer_audit.address_2,
        customer_audit.city,
        customer_audit.zip_code,
        customer_audit.state,
        customer_audit.country,
        validity_periods.valid_from,
        validity_periods.valid_to,
        case
            when
                audit_type = 2 then 1
            else 0
        end as is_deleted,
        case
            when valid_to = '9999-12-31' then 1
            else 0
        end as is_current_record,
        case
            when
                most_recent_record = 1 then 1
            else 0
        end as is_latest_record,
        current_timestamp as dbt_updated_at
    from validity_periods
        inner join
            {{ source('application_db', 'customer_audit') }} as customer_audit
            on validity_periods.audit_id = customer_audit.id
)

select *
from final
