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
