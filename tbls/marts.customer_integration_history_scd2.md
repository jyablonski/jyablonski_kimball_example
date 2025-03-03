# marts.customer_integration_history_scd2

## Description

## Columns

| # | Name                          | Type                        | Default | Nullable | Children | Parents                               | Comment |
| - | ----------------------------- | --------------------------- | ------- | -------- | -------- | ------------------------------------- | ------- |
| 1 | customer_id                   | integer                     |         | true     |          | [source.customer](source.customer.md) |         |
| 2 | integration_type              | text                        |         | true     |          |                                       |         |
| 3 | is_active                     | integer                     |         | true     |          |                                       |         |
| 4 | is_current_integration_record | integer                     |         | true     |          |                                       |         |
| 5 | valid_from                    | timestamp without time zone |         | true     |          |                                       |         |
| 6 | valid_to                      | timestamp without time zone |         | true     |          |                                       |         |

## Relations

```mermaid
erDiagram

"marts.customer_integration_history_scd2" }|--|| "source.customer" : "id -> customer_id"

"marts.customer_integration_history_scd2" {
  integer customer_id
  text integration_type
  integer is_active
  integer is_current_integration_record
  timestamp_without_time_zone valid_from
  timestamp_without_time_zone valid_to
}
"source.customer" {
  varchar_100_ address
  varchar_100_ address_2
  varchar_50_ city
  varchar_50_ country
  timestamp_without_time_zone created_at
  varchar_100_ customer_email
  varchar_100_ customer_name
  integer id
  timestamp_without_time_zone modified_at
  varchar_3_ state
  integer zip_code
}
```

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
