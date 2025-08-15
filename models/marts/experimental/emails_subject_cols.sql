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

        where
            dbt_created_at > (select max(dbt_created_at) from {{ this }})

    {% endif %}
),

unnested_messages as (
    select
        e.email_id,
        e.email_name,
        row_number() over (
            partition by e.email_id
            order by key
        ) as subject_position,
        value ->> 'subject' as subject
    from
        emails_to_process as e,
        lateral jsonb_each(e.messages::jsonb)
    where
        value ->> 'subject' is not null
),

messages_subject_cols as (
    select
        email_id,
        email_name,
        max(case when subject_position = 1 then subject end) as subject_1,
        max(case when subject_position = 2 then subject end) as subject_2,
        max(case when subject_position = 3 then subject end) as subject_3,
        max(case when subject_position = 4 then subject end) as subject_4
    from
        unnested_messages
    group by
        email_id,
        email_name
    order by
        email_id
)

select
    emails_to_process.email_id,
    emails_to_process.email_name,
    messages_subject_cols.subject_1,
    messages_subject_cols.subject_2,
    messages_subject_cols.subject_3,
    messages_subject_cols.subject_4,
    emails_to_process.created_at,
    emails_to_process.modified_at,
    '{{ var("my_var") }}' as dbt_var,         -- HAS to be defined in dbt_project.yml which is where the default comes from
    '{{ env_var("MY_ENV_VAR", "yikesv2") }}' as env_var, -- doesn't have to be defined in dbt_project.yml
    '{{ env_var("MY_INT_VAR", 5) }}' as env_var_str_bad,
    '{{ env_var("MY_INT_VAR", 5) }}'::integer as env_var_int,
    current_timestamp as dbt_created_at
from emails_to_process
    left join messages_subject_cols
        on emails_to_process.email_id = messages_subject_cols.email_id
