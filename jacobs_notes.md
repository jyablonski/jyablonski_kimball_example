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