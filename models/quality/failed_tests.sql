{{
    config(
        materialized='incremental',
        unique_key="id"
    )
}}

-- this is kinda fucked because it runs before elemenmtary updates the table w/
-- results from the current run
with failed_tests as (
    select
        id,
        test_alias as test_name,
        status as test_status,
        test_short_name as test_type,
        detected_at as generated_at
    from {{ ref('elementary_test_results') }}
    where
        status = 'fail'
    {% if is_incremental() %}
            and id not in (select id from {{ this }})
        {% endif %}

)

select *
from failed_tests
