{{ config(
    materialized='incremental',
    unique_key='user_id'
) }}

-- User profile resolution to link accounts based on email usage patterns
-- goal is to create a complete, accurate view of each unique person across all their
-- interactions with the platform, even when they appear as multiple separate identities in the data

with new_user_actions as (
    select *
    from {{ source('application_db', 'user_actions') }}
    {% if is_incremental() %}
        where
            created_at > (select max(__created_at) from {{ this }})
    {% endif %}
),

affected_users as (
    -- Get all user_ids that might be affected by new data
    select distinct user_id
    from new_user_actions
    where
        user_id is not null

    {% if is_incremental() %}
        union

        -- Also include users who might be linked to the new users via email
        select distinct user_actions.user_id
        from {{ source('application_db', 'user_actions') }} as user_actions
            inner join (
                select distinct email
                from new_user_actions
                where
                    email is not null
            ) as new_emails on user_actions.email = new_emails.email
        where
            user_actions.user_id is not null
    {% endif %}
),

email_user_timeline as (
    -- Get all email-user combinations with their first and last activity dates
    -- Only process affected users and their email chains
    select
        email,
        user_id,
        min(created_at) as first_seen,
        max(created_at) as last_seen,
        count(*) as activity_count,
        bool_or(event = 'delete') as account_deleted
    from {{ source('application_db', 'user_actions') }}
    where
        email is not null
        and (
            {% if is_incremental() %}
                user_id in (select user_id from affected_users)
                or email in (
                    select distinct email
                    from {{ source('application_db', 'user_actions') }}
                    where
                        user_id in (select user_id from affected_users)
                        and email is not null
                )
            {% else %}
                1=1
            {% endif %}
        )
    group by
        email,
        user_id
),

email_transitions as (
    select
        email,
        user_id,
        first_seen,
        last_seen,
        account_deleted,
        activity_count,
        lead(user_id) over (partition by email order by first_seen) as next_user_id,
        lead(first_seen) over (partition by email order by first_seen) as next_user_first_seen,
        case
            when
                account_deleted = true
                and lead(user_id) over (partition by email order by first_seen) is not null
                then lead(user_id) over (partition by email order by first_seen)
            else user_id
        end as resolved_user_id
    from email_user_timeline
),

-- handles direct mappings like user_003 -> user_006
user_mapping_base as (
    select
        user_id,
        resolved_user_id
    from email_transitions
    group by
        user_id,
        resolved_user_id
),

-- chain resolution 1 level higher incase user_003 -> user_006 -> user_009
user_mapping_level_1 as (
    select
        user_mapping_base.user_id,
        coalesce(user_mapping_base_inner.resolved_user_id, user_mapping_base.resolved_user_id) as resolved_user_id
    from user_mapping_base
        left join user_mapping_base as user_mapping_base_inner
            on
                user_mapping_base.resolved_user_id = user_mapping_base_inner.user_id
                and user_mapping_base.resolved_user_id != user_mapping_base_inner.resolved_user_id
    group by
        user_mapping_base.user_id,
        coalesce(user_mapping_base_inner.resolved_user_id, user_mapping_base.resolved_user_id)
),

-- chain resolution 1 level higher incase user_003 -> user_006 -> user_009 -> user_012
-- we cap out here
user_mapping_level_2 as (
    select
        user_mapping_level_1.user_id,
        coalesce(user_mapping_level_1_inner.resolved_user_id, user_mapping_level_1.resolved_user_id) as resolved_user_id
    from user_mapping_level_1
        left join user_mapping_level_1 as user_mapping_level_1_inner
            on
                user_mapping_level_1.resolved_user_id = user_mapping_level_1_inner.user_id
                and user_mapping_level_1.resolved_user_id != user_mapping_level_1_inner.resolved_user_id
    group by
        user_mapping_level_1.user_id,
        coalesce(user_mapping_level_1_inner.resolved_user_id, user_mapping_level_1.resolved_user_id)
),

users_to_process as (
    -- Get all user_ids that need to be in final output
    {% if is_incremental() %}
        -- For incremental: affected users + existing users that might have changed
        select user_id from affected_users
        union
        select user_id
        from {{ this }}
        where
            resolved_user_id in (select user_id from affected_users)
            or user_id in (select resolved_user_id from user_mapping_level_2)
    {% else %}
        -- For full refresh: all users
        select distinct user_id
        from {{ source('application_db', 'user_actions') }}
        where user_id is not null
    {% endif %}
),

-- Get comprehensive user analytics for each user_id
-- this brings in all historical data for all users to process, so it's not ideal
-- but it's a lot more simple than maintaining more incremental logic to recalculate metrics
user_analytics_base as (
    select
        user_id,
        min(created_at) as first_seen_at,
        max(created_at) as last_seen_at,
        count(*) as total_actions,
        count(distinct email) as email_count,
        array_agg(distinct email order by email) filter (where email is not null) as all_emails_used,
        bool_or(event = 'signup') as has_signup,
        bool_or(event = 'delete') as has_delete,
        bool_or(event = 'email_change') as has_email_change,
        count(*) filter (where event = 'signup') as signup_count,
        count(*) filter (where event = 'delete') as delete_count,
        count(*) filter (where event = 'email_change') as email_change_count,
        -- Get the email used at signup and deletion
        max(email) filter (where event = 'signup') as signup_email,
        max(email) filter (where event = 'delete') as delete_email
    from {{ source('application_db', 'user_actions') }}
    where
        user_id in (select user_id from users_to_process)
        and user_id is not null
    group by user_id
),

user_emails_flattened as (
    -- Flatten all emails used by each user for easier aggregation
    select
        user_mapping_level_2.resolved_user_id,
        unnest(user_analytics_base.all_emails_used) as email
    from user_mapping_level_2
        inner join user_analytics_base on user_mapping_level_2.user_id = user_analytics_base.user_id
    where
        user_analytics_base.all_emails_used is not null

    union all

    select
        user_analytics_base.user_id as resolved_user_id,
        unnest(user_analytics_base.all_emails_used) as email
    from user_analytics_base
    where
        user_analytics_base.user_id not in (select user_id from user_mapping_level_2)
        and user_analytics_base.all_emails_used is not null
),

resolved_user_analytics as (
    -- Aggregate analytics for the resolved user identity
    select
        user_mapping_level_2.resolved_user_id,
        min(user_analytics_base.first_seen_at) as resolved_first_seen_at,
        max(user_analytics_base.last_seen_at) as resolved_last_seen_at,
        sum(user_analytics_base.total_actions) as resolved_total_actions,
        count(user_analytics_base.user_id) as identity_count,
        array_agg(user_analytics_base.user_id order by user_analytics_base.first_seen_at) as all_user_ids,
        sum(user_analytics_base.signup_count) as resolved_signup_count,
        sum(user_analytics_base.delete_count) as resolved_delete_count,
        sum(user_analytics_base.email_change_count) as resolved_email_change_count
    from user_mapping_level_2
        inner join user_analytics_base on user_mapping_level_2.user_id = user_analytics_base.user_id
    group by user_mapping_level_2.resolved_user_id

    union all

    -- Include users who don't have mappings (they resolve to themselves)
    select
        user_analytics_base.user_id as resolved_user_id,
        user_analytics_base.first_seen_at as resolved_first_seen_at,
        user_analytics_base.last_seen_at as resolved_last_seen_at,
        user_analytics_base.total_actions as resolved_total_actions,
        1 as identity_count,
        array[user_analytics_base.user_id] as all_user_ids,
        user_analytics_base.signup_count as resolved_signup_count,
        user_analytics_base.delete_count as resolved_delete_count,
        user_analytics_base.email_change_count as resolved_email_change_count
    from user_analytics_base
    where
        user_analytics_base.user_id not in (select user_id from user_mapping_level_2)
),

resolved_user_emails as (
    -- Aggregate distinct emails for each resolved user
    select
        resolved_user_id,
        array_agg(distinct email order by email) as resolved_all_emails
    from user_emails_flattened
    group by resolved_user_id
),

final_resolution as (
    select
        users_to_process.user_id,
        coalesce(user_mapping_level_2.resolved_user_id, users_to_process.user_id) as resolved_user_id,
        coalesce(coalesce(user_mapping_level_2.resolved_user_id, users_to_process.user_id) != users_to_process.user_id, false) as is_resolved_identity,

        -- Individual user analytics
        user_analytics_base.first_seen_at,
        user_analytics_base.last_seen_at,
        user_analytics_base.total_actions,
        user_analytics_base.email_count,
        user_analytics_base.all_emails_used,
        user_analytics_base.has_signup,
        user_analytics_base.has_delete,
        user_analytics_base.has_email_change,
        user_analytics_base.signup_email,
        user_analytics_base.delete_email,

        -- Resolved identity analytics
        resolved_user_analytics.resolved_first_seen_at,
        resolved_user_analytics.resolved_last_seen_at,
        resolved_user_analytics.resolved_total_actions,
        resolved_user_analytics.identity_count,
        resolved_user_analytics.all_user_ids,
        resolved_user_analytics.resolved_signup_count,
        resolved_user_analytics.resolved_delete_count,
        resolved_user_analytics.resolved_email_change_count,
        resolved_user_emails.resolved_all_emails,

        -- Calculated insights
        coalesce(resolved_user_analytics.identity_count > 1, false) as is_multi_identity_user,

        extract(days from resolved_user_analytics.resolved_last_seen_at - resolved_user_analytics.resolved_first_seen_at) as resolved_lifecycle_days,

        coalesce(resolved_user_analytics.resolved_delete_count > 0 and resolved_user_analytics.resolved_signup_count > resolved_user_analytics.resolved_delete_count, false) as has_returned_after_delete,

        current_timestamp as __created_at

    from users_to_process
        left join user_mapping_level_2
            on users_to_process.user_id = user_mapping_level_2.user_id
        left join user_analytics_base
            on users_to_process.user_id = user_analytics_base.user_id
        left join resolved_user_analytics
            on coalesce(user_mapping_level_2.resolved_user_id, users_to_process.user_id) = resolved_user_analytics.resolved_user_id
        left join resolved_user_emails
            on coalesce(user_mapping_level_2.resolved_user_id, users_to_process.user_id) = resolved_user_emails.resolved_user_id
)

select
    user_id,
    resolved_user_id,
    is_resolved_identity,

    -- Individual user metrics
    first_seen_at,
    last_seen_at,
    total_actions,
    email_count,
    all_emails_used,
    has_signup,
    has_delete,
    has_email_change,
    signup_email,
    delete_email,

    -- Resolved identity metrics  
    resolved_first_seen_at,
    resolved_last_seen_at,
    resolved_total_actions,
    identity_count,
    all_user_ids,
    resolved_signup_count,
    resolved_delete_count,
    resolved_email_change_count,
    resolved_all_emails,

    -- Analytics insights
    is_multi_identity_user,
    resolved_lifecycle_days,
    has_returned_after_delete,

    __created_at
from final_resolution
