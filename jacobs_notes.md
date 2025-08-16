# Why Kimball Modeling
Goal is to make consuming & analyzing data easier.  Source Data in Application Databases may be setup to be efficient for Applications + adhere to traditional OLTP principles, but it's probably not optimized for Reporting.
- Improves the structure, quality, and ease-of-use of the data to optimize it for downstream uses like BI & Reporting.
- Introduces a common, standardized way of modeling data.  New people can come in and be familiar with what Fact, Dim, and SCD2 tables all do.
- Helps organize the data landscape when you have tons of different data sources flowing in.

Kimball is not 100% necessary; at the end of the day as long as you can efficiently provide business value with data to business users and other stakeholders then it doesn't matter what the underlying methodology being used is.
## Facts
Facts represent quantitative & measurable pieces of data about business events or processes.
- Facts can be linked to dimensions through Foreign Keys to create relationships between the two.
- Typically Fact Tables have lots of rows with few columns
- Examples include Sales or Order data

## Dimensions
Dimensions are business descriptive attributes related to the contents in the Fact Tables.
- Describes the who, what, where, when, and why.
- Typically don't change very often
- Typically Dimensions Tables have more columns and fewer rows than Fact Tables
- Examples include Product, Customer, Geography based attributes

Cons
- More up-front work needed to get set everything up

## Local Dev
`asdf local python 3.11.5`
`poetry install`
`dbt init` type in your project name and then cut out all of the files it creates and paste them in root directory


https://www.getdbt.com/blog/track-data-changes-with-dbt-snapshots
https://github.com/dbt-labs/dbt-core/issues/3878

use scd2 when you need to reflect historical truth at point in time.

## Elementary
[Quickstart](https://docs.elementary-data.com/quickstart)
[Docs](https://docs.elementary-data.com/quickstart-cli)
`dbt run-operation elementary.generate_elementary_cli_profile`
- Copy & Paste this to Profiles.yml


`edr report`
`edr send-report --slack-token <SLACK_TOKEN> --slack-channel-name <CHANNEL_NAME>`


`dbt build --target dev --profiles-dir profiles/ --profile dbt_ci --select state:modified --state ./target/`
`dbt build --target dev --profiles-dir profiles/ --profile dbt_ci --select state:modified --state ./target/`
`dbt build --target dev --profiles-dir profiles/ --profile dbt_ci --select +state:modified+ --state ./`
`dbt build --select incremental_pk_tester --target dev --profiles-dir profiles/`
`dbt build --select incremental_pk_tester_merge_only --target dev --profiles-dir profiles/`


dbt state modified vs state deferred

State Deferred is for building dbt Resources in one environment while telling it to use parent models from another environment
- The purpose of this is to save time and computational resources.
- `dbt run --select my_model+ --defer --state my_stg_state_file`
- [More Complex Documentation](https://docs.getdbt.com/reference/node-selection/defer)

State modified is for building only changed dbt Resources based on the last known dbt Manifest file.

[Link](https://paulfry999.medium.com/v0-4-pre-chatgpt-how-to-create-ci-cd-pipelines-for-dbt-core-88e68ab506dd)

`dbt ls --select state:modified+ --defer --state=prod-run-artifacts`  # list the modified dbt models
        
`dbt run --select state:modified+ --defer --state=prod-run-artifacts` # run modified dbt models only

``` sh
# list the modified dbt models
dbt ls --select state:modified+ --defer --state=prod-run-artifacts

# run modified dbt models only
dbt run --select state:modified+ --defer --state=prod-run-artifacts

dbt run --select state:modified+ --target prod --defer --state=./

dbt run --select state:modified+ --target prod --state=./

dbt ls --select state:modified+ --state=./
```


`SELECT slot_name, plugin, slot_type, database, active, restart_lsn, confirmed_flush_lsn FROM pg_replication_slots;`

## SCD2

Example in `/models/dim/dim_customers.sql`


## General

`sudo ss --all sport = 8080 -K`

- This command will kill any leftover resources used on port 8000 when running dbt docs serve

## dbt Coverage

[Example Repo](https://github.com/pgoslatara/dbt-beyond-the-basics)

``` sh
c
```

``` sh
$ cd jaffle_shop
$ dbt run  # Materialize models
$ dbt docs generate  # Generate catalog.json and manifest.json
$ dbt-coverage compute doc --cov-report coverage-doc.json  # Compute doc coverage, print it and write it to coverage-doc.json file
$ dbt-coverage compute test --cov-report coverage-doc.json

dbt-coverage compute test --cov-report coverage-doc.json --model-path-filter models/marts/

Coverage report
=====================================================================
jaffle_shop.customers                                  6/7      85.7%
jaffle_shop.orders                                     9/9     100.0%
jaffle_shop.raw_customers                              0/3       0.0%
jaffle_shop.raw_orders                                 0/4       0.0%
jaffle_shop.raw_payments                               0/4       0.0%
jaffle_shop.stg_customers                              0/3       0.0%
jaffle_shop.stg_orders                                 0/4       0.0%
jaffle_shop.stg_payments                               0/4       0.0%
=====================================================================
Total                                                 15/38     39.5%

$ dbt-coverage compute test --cov-report coverage-test.json  # Compute test coverage, print it and write it to coverage-test.json file

Coverage report
=====================================================================
jaffle_shop.customers                                  1/7      14.3%
jaffle_shop.orders                                     8/9      88.9%
jaffle_shop.raw_customers                              0/3       0.0%
jaffle_shop.raw_orders                                 0/4       0.0%
jaffle_shop.raw_payments                               0/4       0.0%
jaffle_shop.stg_customers                              1/3      33.3%
jaffle_shop.stg_orders                                 2/4      50.0%
jaffle_shop.stg_payments                               2/4      50.0%
=====================================================================
Total                                                 14/38     36.8%

```

Comparison

``` sh
$ dbt-coverage compare coverage-after.json coverage-before.json

# Coverage delta summary
              before     after            +/-
=============================================
Coverage      39.47%    38.46%         -1.01%
=============================================
Tables             8         8          +0/+0
Columns           38        39          +1/+0
=============================================
Hits              15        15          +0/+0
Misses            23        24          +1/+0
=============================================

# New misses
=========================================================================
Catalog                         15/38   (39.47%)  ->    15/39   (38.46%)
=========================================================================
- jaffle_shop.customers          6/7    (85.71%)  ->     6/8    (75.00%)
-- new_col                       -/-       (-)    ->     0/1     (0.00%)
=========================================================================

dbt-coverage compare coverage-doc.json coverage-prod.json
```


[Profiles YAML example](https://github.com/RealSelf/dbt-source/blob/development/sample.profiles.yml)


[dbt Unit Tests Snowflake Fail Thread](https://github.com/dbt-labs/dbt-snowflake/issues/1160)


``` sql
-- by default, every mdoel uses an x small
{% if is_incremental() %}
{{ swap_warehouse('DBT_L_WH') }} -- incremental
{% else %}
{{ swap_warehouse('DBT_4XL_WH') }} -- full refresh
{% endif %}

```

# Troubleshooting

``` sh
dbt build --debug
dbt run-operation send_alert_on_failure --debug

# by default, unit tests run during dbt build
# so in slim ci just run dbt build and let it do its thing
# in prod run this with the exclude unit test flag
dbt build --exclude-resource-type unit_test

dbt docs serve --port 8000 --host 0.0.0.0

```

## dbterd

- Works, but requires

``` sh
dbterd run

dbterd run -t mermaid
dbterd run -t mermaid -s schema:dim

echo \`\`\`mermaid > ./erd/erd_output.md
echo --- >> ./erd/erd_output.md
echo title: Sample ERD >> ./erd/erd_output.md
echo --- >> ./erd/erd_output.md
cat ./target/output.md >> ./erd/erd_output.md
echo \`\`\` >> ./erd/erd_output.md

# it has problems with custom enums in the source schema,
# and the numeric(10,2) data type in postgres. have to remove

sed -i -E 's/source\.//g; s/numeric\([0-9]+,[0-9]+\)/numeric/g' ./erd/erd_output.md

# dbml route which is used in combination w/ a site called dbdocs
dbterd run -t dbml
dbdocs build "target/output.dbml"

npm install -g dbdocs
dbdocs login
dbdocs build "target/output.dbml"

```

## tbls

``` sh

tbls doc postgres://postgres:postgres@localhost:5432/postgres?sslmode=disable

tbls doc --force

rm -f tbls/schema.json
```


``` go
const (
	ZeroOrOne          Cardinality = "zero_or_one"
	ExactlyOne         Cardinality = "exactly_one"
	ZeroOrMore         Cardinality = "zero_or_more"
	OneOrMore          Cardinality = "one_or_more"
	UnknownCardinality Cardinality = ""
)

```


## Large Data Model Backfills


This `is_incremental()` block loads data 1 month at a time. The filters work as follows:

- It only grabs rows w/ a timestamp greater than what's already in the table
- And it will only grab rows that are 1 month greater than the max timestamp that's already in the table
- This lets you process it 1 month at a time until you're all caught up
- Once you're all caught up, that 1 month filter is still fine. 
	- If it's August 15 and we run it, we'll only have data from August 15th so even though our query will try to grab everything between August 15 and September 15, we only have 1 day of data to load
- Downside is for initial runs, we have to run this repeatedly dozens of times until we're caught up

``` sql
{{ config(
    materialized='incremental'
) }}

with source_data as (

    select *
    from {{ ref('raw_events') }}

    {% if is_incremental() %}
    -- Incremental run: load 1-month block after max date in table
    where 
		date >= (select max(date) from {{ this }} )
      	and date < dateadd('month', 1, (select max(date) from {{ this }} ))
    {% else %}
    -- Full-refresh / first run: only load January 2021
    where 
		date >= '2021-01-01' and date < '2021-02-01'
    {% endif %}

)

select *
from source_data
```

- Can use `swap_warehouse` macro on large dbt models to use a bigger warehouse for the initial full refresh

``` sql
-- only swap on full refreshess
{% if not is_incremental() %}
    {{ swap_warehouse('dbt_warehouse_2xl_prod') }} -- only swap on full refresh
{% endif %}

-- or do this 
-- on a bigger model, swap to a large warehouse for incremental runs, or 2xl for full refreshes
{% if is_incremental() %}
{{ swap_warehouse('dbt_warehouse_large_prod') }} -- incremental
{% else %}
{{ swap_warehouse('dbt_warehouse_2xl_prod') }} --full refresh
{% endif %}
```

```sql
# override the Snowflake virtual warehouse for just this model
{{
  config(
    materialized='table',
    snowflake_warehouse='dbt_warehouse_large_prod'
  )
}}

```
- You can do this too, but you'll be using the same warehouse on full refreshes as well as incremental runs


``` sql
-- BEFORE
config(
 ...
 unique_key = 'my_surrogate_key'
)

-- AFTER
config(
 ..
 unique_key = ['my_surrogate_key', 'my_timestamp']
)
```

- Performance improvement on `merge` by specifying another column in the unique key (such as one you used as part of the surrogate key). It allows Snowflake to automatically do some pruning on the existing table before attempting the join

## Vars


- `dbt build --full-refresh --vars '{"my_var": "value"}'`
- `var` has to be defined in `dbt_project.yml`
- `env_var` does not have to be defined as long as you provide an inline default value for it
- Setting dynamic env vars with Airflow is possible but could be a bit tricky

``` sql
    '{{ var("my_var") }}' as dbt_var,         -- HAS to be defined in dbt_project.yml which is where the default comes from
    '{{ env_var("MY_ENV_VAR", "yikesv2") }}' as env_var, -- doesn't have to be defined in dbt_project.yml

```

## Microbatch

Microbatch basically automatically applies timestamp filters for backfilling large tables. You specify metadata related to the model

- For the source or ref table you query from in the microbatch dbt model, that parent model must have a `config` `event_time` block set for the timestamp to use in order for microbatch to work as expected
- The actual microbatch model has no `incremental_block`, it's handled for you

``` sql
{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='session_end',
    begin='2020-01-01',
    batch_size='month',
    unique_key="session_id"
) }}
```

``` yml
      - name: user_sessions
        config:
          event_time: session_end
```

``` sql
-- the page_sessions_microbatch_2020-01-01.sql run which covers jan 1 2020 between jan 31 2020
with user_sessions_detailed as (
    select
        session_id,
        user_id,
        session_start,
        session_end,
        device,
        country,

        -- duration in minutes (interval -> seconds -> minutes)
        (extract(epoch from (session_end - session_start)) / 60.0) as session_duration_min,

        -- FIXED CASE: compare numbers, not an interval
        case
            when (extract(epoch from (session_end - session_start)) / 60.0) <= 5 then 'Short'
            else 'Long'
        end as session_length_type,

        date_trunc('day',   session_start) as session_date,
        date_trunc('month', session_start) as session_month,
        to_char(session_start, 'DY')        as session_dow,
        (extract(dow from session_start) in (0,6)) as is_weekend,  -- 0=Sun,6=Sat in PG
        NOW() as __created_at
    from (select * from "postgres"."source"."user_sessions" where session_end >= '2020-01-01 00:00:00+00:00' and session_end < '2020-02-01 00:00:00+00:00') _dbt_et_filter_subq_user_sessions
)

select *
from user_sessions_detailed
```

Data Tests on Microbatch models only run after the current set of batches are all completed

- So if you rebuild like 50 batches, you dont run the tests 50 times. They only run at the end.

Problems with microbatch:

- Hidden complexity with dbt-build macro, timestamp shenangians, late arriving data. You control less of the process
- Scheduling gets weird - if you schedule your dbt DAGs to run daily and you set these microbatch models to anything other than daily, then you'll be reprocessing a ton of data on every dbt build
- The backfill / retry functionality on "failed" batches isn't really needed in the vast majority of cases unless you somehow think you'll come across bad data that needs to be caught w/ this feature

## Incremental

Append

- Use when you truly have append-only incremental tables w/ logs or events
- Much more performant than `merge` because you don't have to go update and rewrite entire parititons of data

Merge

- Most flexible to handle duplicates, great on small tables
- Not so performant on large tables
- Large table scans and many small writes - not great
- `incremental_predicates` allow the merge to basically have a filter condition incase you expect to only have to update data with a certain condition (like last 7 days etc)
- `incremental_predicates: ["DBT_INTERNAL_DEST.session_start > dateadd(day, -7, current_date)"]` 

Insert Overwrite

- Instead of updating existing partitioned tables, this strategy involves actually deleting the partitions for the existing records found within the incremental query, and then rebuilding them
- If we partition by day and our most recent run has data for 2022-01-01 and 2022-01-02, then we delete both of those partitions and rebuild them
- High complexity, can generate duplicates if you're not setting things up right.
- But, can be much more performant at large scale
- It's ideal for tables partitioned by date or another key and useful for refreshing recent or corrected data without full table rebuilds.


Delete + Insert

- Deletes existing records and inserts both new and existing records that were in the incremental query
- This effectively gets around the duplicate problem without having to use `merge` statement
- Built for legacy purposes before `merge` was available in databases like Postgres etc, or when you might occassionally get dupes on `unique_key` and want to avoid a merge strategy

## Incremental Across multiple Tables

[Post](https://medium.com/@wuppschlandermuller/dbt-incremental-models-advanced-examples-part-1-6e8dac724153)

``` sql
with table_b as (
  select *
  from {{ ref('table_b') }}
),

{% if is_incremental() %}
table_b_updates as (
  select key_1
  from table_b
  where updated_at > (select max(updated_at) from {{ this }})
),
{% endif %}

table_a as (
  select *
  from {{ ref('table_a') }}
  {% if is_incremental() %}
  where
    updated_at > (select max(updated_at) from {{ this }})
    or key_1 in (select key_1 from table_b_updates)
  {% endif %}
),

final as (
  select
    table_a.key_1,
    table_a.value_a,
    table_b.value_b,
    current_timestamp() as updated_at
  from
    table_a
    left join table_b using (key_1)
)

select * from final
```

- The idea is you have a 1:1 mapping between 2 tables, but perhaps only 1 of the tables has a new key coming in.
- So you always grab new IDs in `table_b`, and then the `table_a` CTE always pulls either new records in its source table, or any existing records w/ IDs that are new in that `table_b` CTE