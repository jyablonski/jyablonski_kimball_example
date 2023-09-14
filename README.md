# jyablonski Kimball Example
Example Repo for Kimball Modeling Practice

```
jyablonski_kimball_example:
  outputs:

    dev:
      type: postgres
      threads: 1
      host: localhost
      port: 5432
      user: postgres
      pass: postgres
      dbname: postgres
      schema: dbt_stg

    prod:
      type: postgres
      threads: 1
      host: localhost
      port: 5432
      user: postgres
      pass: postgres
      dbname: postgres
      schema: dbt_prod

  target: dev
```