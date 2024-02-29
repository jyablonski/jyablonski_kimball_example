-- this didnt work lmao
{% macro get_run_date() %}
  {% if execute %}
    {% set table_exists = run_query("select count(*) from information_schema.tables where table_schema = 'marts' and table_name = 'incremental_pk_tester'") %}

    {% if table_exists[0][0] > 0 %}
      {% set run_date = run_query("select date(max(created_at)) + 1 from marts.incremental_pk_tester").columns[0][0] %}
    {% else %}
      {% set run_date = current_date %}
    {% endif %}

  {% else %}  
    {% set run_date = current_date %}
  {% endif %}

  {% do return(run_date) %}

{% endmacro %}