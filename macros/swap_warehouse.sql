/* macro used for incremental macros

in is_incremental mode, use the default warehouse. during full refreshes,
you can use a larger warehouse to get through more of the data

*/
{% macro swap_warehouse(warehouse_name='DBT_XS_WH') %}

{% if execute %}
    {% set warehouse_query %}
        USE WAREHOUSE {{ warehouse_name }};
    {% endset %}

    {% do run_query(warehouse_query) %}
{% endif %}

{%- endmacro -%}
