{% macro get_run_date() %}
  {% if execute %}
    {% set run_date = run_query("select date(max(created_at)) + 1 from marts.incremental_pk_tester").columns[0][0] %}

  {% else %}  
    {% set run_date = current_date %}

  {% endif %}

  {% do return(run_date) %}

{% endmacro %}