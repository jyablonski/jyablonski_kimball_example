{% macro swap_warehouse(warehouse_name='DBT_XS_WH') %}

{% if execute %}
    {% set warehouse_query %}
        USE WAREHOUSE {{ warehouse_name }};
    {% endset %}

    {% do run_query(warehouse_query) %}
{% endif %}

{%- endmacro -%}
