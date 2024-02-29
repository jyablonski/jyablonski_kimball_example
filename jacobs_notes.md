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
