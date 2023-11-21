{% snapshot orders_snapshot %}
-- this will create a new dbt model with dbt_scd_id, dbt_updated_at,
-- dbt_valid_from, and dbt_valid_to fields.

-- if dbt_valid_to is null then that record is the most recent / up-to-date record
-- have to add `invalidate_hard_deletes=True,` if you actually want to track when a record was deleted
{{
    config(
      target_database='postgres',
      target_schema='dbt_stg',
      unique_key='payment_id',

      strategy='timestamp',
      updated_at='modified_at',
      invalidate_hard_deletes=True,
    )
}}

    select * from {{ source('application_db', 'payments') }}

{% endsnapshot %}
