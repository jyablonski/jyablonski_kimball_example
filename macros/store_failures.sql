{% macro store_failures() %}

  {% set source_table = 'elementary_test_results' %}
  {% set target_table = 'failed_test_tracking' %}
  
  with failed_tests as (
      select
          id,
          test_alias as test_name,
          status as test_status,
          test_short_name as test_type,
          detected_at as generated_at
      from {{ source_table }}
      where 
          status = 'fail'
          and id not in (select id from {{ target_table }})
  )

  insert into {{ target_table }} (id, test_name, test_status, test_type, generated_at)
  select
      id,
      test_name,
      test_status,
      test_type,
      generated_at
  from failed_tests

{% endmacro %}
