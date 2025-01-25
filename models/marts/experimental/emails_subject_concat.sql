{{
    config(
        materialized='incremental',
        unique_key="email_id"
    )
}}

with emails_to_process as (
    select *
    from {{ ref('fact_emails') }}
    {% if is_incremental() %}

        where dbt_created_at > (select max(dbt_created_at) from {{ this }})

    {% endif %}
),

unnested_messages as (
    select
        e.email_id,
        e.email_name,
        value ->> 'subject' as subject
    from
        emails_to_process as e,
        lateral jsonb_each(e.messages::jsonb)
    where
        value ->> 'subject' is not null
),

messages_with_subjects as (
    select
        email_id,
        email_name,
        string_agg(subject, ', ') as subjects -- Combine all subjects into a comma-separated string
    from
        unnested_messages
    group by
        email_id, email_name
)

select
    emails_to_process.email_id,
    emails_to_process.email_name,
    coalesce(messages_with_subjects.subjects, '(NULL) No Subject Found') as subjects, -- Use an empty string if no subjects exist
    emails_to_process.created_at,
    emails_to_process.modified_at,
    current_timestamp::timestamp as dbt_created_at
from
    emails_to_process
    left join
        messages_with_subjects
        on
            emails_to_process.email_id = messages_with_subjects.email_id
