-- pulled from https://github.com/dbt-labs/dbt-snowflake/issues/1160
-- this `QUOTED_IDENTIFIERS_IGNORE_CASE` account parameter causes a unit test bug in dbt

{% macro get_unit_test_sql(main_sql, expected_fixture_sql, expected_column_names) -%}
-- For accounts that have this param set to true, we need to make it false for the query.
-- https://github.com/dbt-labs/dbt-snowflake/issues/1160
alter session set QUOTED_IDENTIFIERS_IGNORE_CASE = false;

-- Build actual result given inputs
with dbt_internal_unit_test_actual as (
  select
    {% for expected_column_name in expected_column_names %}{{expected_column_name}}{% if not loop.last -%},{% endif %}{%- endfor -%}, {{ dbt.string_literal("actual") }} as {{ adapter.quote("actual_or_expected") }}
  from (
    {{ main_sql }}
  ) _dbt_internal_unit_test_actual
),
-- Build expected result
dbt_internal_unit_test_expected as (
  select
    {% for expected_column_name in expected_column_names %}{{expected_column_name}}{% if not loop.last -%}, {% endif %}{%- endfor -%}, {{ dbt.string_literal("expected") }} as {{ adapter.quote("actual_or_expected") }}
  from (
    {{ expected_fixture_sql }}
  ) _dbt_internal_unit_test_expected
)
-- Union actual and expected results
select * from dbt_internal_unit_test_actual
union all
select * from dbt_internal_unit_test_expected
{%- endmacro %}