{%- set run_date = modules.datetime.date.fromisoformat(var("run_date")) -%}
{%- set cutoff_date = modules.datetime.date(2024, 3, 1) -%}

-- dbt build --select ohshit --vars 'run_date: "2020-01-01"'
with my_cte as (
    select
        id,
        {{ dbt.string_literal(var("run_date")) }}::date as start_date,
        {{ dbt.string_literal(var("run_date")) }}::date + 1 as end_date,
        created_at,
        modified_at
    from {{ source("application_db", "order") }}
)

select
    id,
    start_date,
    end_date,
    {%- if run_date >= cutoff_date %} modified_at
{%- else %} created_at
    {%- endif %}
from my_cte
