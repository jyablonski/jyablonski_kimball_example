# jyablonski Kimball Example
Example Repo for Kimball Modeling Practice w/ dbt

## Local Dev
Run `make start-postgres` to boot up a Postgres Database w/ some sample data set up.

When finished run `make stop-postgres` to spin the resources down.

## Testing
Run `make test` to build every resource in the project.  Resources are automatically spun back down.