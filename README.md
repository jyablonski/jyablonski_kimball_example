# jyablonski Kimball Example
Example Repo for Kimball Modeling Practice w/ dbt

## Local Dev
Run `make up` to boot up a Postgres Database w/ some bootstrapped dummy E-commerce data.

When finished run `make down` to spin the resources down.

## Testing
Run `make test` to build every resource in the project.  Resources are automatically spun back down.