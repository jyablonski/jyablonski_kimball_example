# postgres

## Tables

| #  | Name                                                                                    | Columns | Comment | Type       |
| -- | --------------------------------------------------------------------------------------- | ------- | ------- | ---------- |
| 1  | [dbt_stg.alerts_anomaly_detection](dbt_stg.alerts_anomaly_detection.md)                 | 23      |         | VIEW       |
| 2  | [dbt_stg.alerts_dbt_models](dbt_stg.alerts_dbt_models.md)                               | 14      |         | VIEW       |
| 3  | [dbt_stg.alerts_dbt_source_freshness](dbt_stg.alerts_dbt_source_freshness.md)           | 23      |         | VIEW       |
| 4  | [dbt_stg.alerts_dbt_tests](dbt_stg.alerts_dbt_tests.md)                                 | 23      |         | VIEW       |
| 5  | [dbt_stg.alerts_schema_changes](dbt_stg.alerts_schema_changes.md)                       | 23      |         | VIEW       |
| 6  | [dbt_stg.anomaly_threshold_sensitivity](dbt_stg.anomaly_threshold_sensitivity.md)       | 14      |         | VIEW       |
| 7  | [dbt_stg.countries](dbt_stg.countries.md)                                               | 4       |         | BASE TABLE |
| 8  | [dbt_stg.country_codes](dbt_stg.country_codes.md)                                       | 2       |         | BASE TABLE |
| 9  | [dbt_stg.customer_changes_agg](dbt_stg.customer_changes_agg.md)                         | 3       |         | BASE TABLE |
| 10 | [dbt_stg.data_monitoring_metrics](dbt_stg.data_monitoring_metrics.md)                   | 15      |         | BASE TABLE |
| 11 | [dbt_stg.dbt_artifacts_hashes](dbt_stg.dbt_artifacts_hashes.md)                         | 2       |         | VIEW       |
| 12 | [dbt_stg.dbt_columns](dbt_stg.dbt_columns.md)                                           | 13      |         | BASE TABLE |
| 13 | [dbt_stg.dbt_exposures](dbt_stg.dbt_exposures.md)                                       | 20      |         | BASE TABLE |
| 14 | [dbt_stg.dbt_invocations](dbt_stg.dbt_invocations.md)                                   | 35      |         | BASE TABLE |
| 15 | [dbt_stg.dbt_metrics](dbt_stg.dbt_metrics.md)                                           | 20      |         | BASE TABLE |
| 16 | [dbt_stg.dbt_models](dbt_stg.dbt_models.md)                                             | 19      |         | BASE TABLE |
| 17 | [dbt_stg.dbt_run_results](dbt_stg.dbt_run_results.md)                                   | 22      |         | BASE TABLE |
| 18 | [dbt_stg.dbt_seeds](dbt_stg.dbt_seeds.md)                                               | 15      |         | BASE TABLE |
| 19 | [dbt_stg.dbt_snapshots](dbt_stg.dbt_snapshots.md)                                       | 19      |         | BASE TABLE |
| 20 | [dbt_stg.dbt_source_freshness_results](dbt_stg.dbt_source_freshness_results.md)         | 17      |         | BASE TABLE |
| 21 | [dbt_stg.dbt_sources](dbt_stg.dbt_sources.md)                                           | 22      |         | BASE TABLE |
| 22 | [dbt_stg.dbt_tests](dbt_stg.dbt_tests.md)                                               | 28      |         | BASE TABLE |
| 23 | [dbt_stg.elementary_test_results](dbt_stg.elementary_test_results.md)                   | 28      |         | BASE TABLE |
| 24 | [dbt_stg.failed_tests](dbt_stg.failed_tests.md)                                         | 5       |         | BASE TABLE |
| 25 | [dbt_stg.job_run_results](dbt_stg.job_run_results.md)                                   | 6       |         | VIEW       |
| 26 | [dbt_stg.metadata](dbt_stg.metadata.md)                                                 | 1       |         | BASE TABLE |
| 27 | [dbt_stg.metrics_anomaly_score](dbt_stg.metrics_anomaly_score.md)                       | 17      |         | VIEW       |
| 28 | [dbt_stg.model_run_results](dbt_stg.model_run_results.md)                               | 29      |         | VIEW       |
| 29 | [dbt_stg.monitors_runs](dbt_stg.monitors_runs.md)                                       | 6       |         | VIEW       |
| 30 | [dbt_stg.ohshit](dbt_stg.ohshit.md)                                                     | 4       |         | BASE TABLE |
| 31 | [dbt_stg.orders_snapshot](dbt_stg.orders_snapshot.md)                                   | 11      |         | BASE TABLE |
| 32 | [dbt_stg.schema_columns_snapshot](dbt_stg.schema_columns_snapshot.md)                   | 8       |         | BASE TABLE |
| 33 | [dbt_stg.seed_run_results](dbt_stg.seed_run_results.md)                                 | 26      |         | VIEW       |
| 34 | [dbt_stg.snapshot_run_results](dbt_stg.snapshot_run_results.md)                         | 26      |         | VIEW       |
| 35 | [dbt_stg.test_result_rows](dbt_stg.test_result_rows.md)                                 | 4       |         | BASE TABLE |
| 36 | [dim.dim_customers](dim.dim_customers.md)                                               | 16      |         | BASE TABLE |
| 37 | [dim.dim_financial_accounts](dim.dim_financial_accounts.md)                             | 7       |         | BASE TABLE |
| 38 | [dim.dim_integrations](dim.dim_integrations.md)                                         | 7       |         | BASE TABLE |
| 39 | [dim.dim_payment_types](dim.dim_payment_types.md)                                       | 6       |         | BASE TABLE |
| 40 | [dim.dim_products](dim.dim_products.md)                                                 | 5       |         | BASE TABLE |
| 41 | [dim.dim_stores](dim.dim_stores.md)                                                     | 9       |         | BASE TABLE |
| 42 | [fact.fact_emails](fact.fact_emails.md)                                                 | 6       |         | BASE TABLE |
| 43 | [fact.fact_orders_detailed](fact.fact_orders_detailed.md)                               | 11      |         | BASE TABLE |
| 44 | [fact.fact_orders_external_system](fact.fact_orders_external_system.md)                 | 8       |         | BASE TABLE |
| 45 | [fact.fact_orders_generalized](fact.fact_orders_generalized.md)                         | 9       |         | BASE TABLE |
| 46 | [fact.fact_payments](fact.fact_payments.md)                                             | 9       |         | BASE TABLE |
| 47 | [fact.fact_product_prices](fact.fact_product_prices.md)                                 | 8       |         | BASE TABLE |
| 48 | [marts.accounting_by_state_agg](marts.accounting_by_state_agg.md)                       | 4       |         | BASE TABLE |
| 49 | [marts.accounting_by_store_agg](marts.accounting_by_store_agg.md)                       | 4       |         | BASE TABLE |
| 50 | [marts.customer_integration_history_scd2](marts.customer_integration_history_scd2.md)   | 6       |         | BASE TABLE |
| 51 | [marts.customer_payments_by_invoice](marts.customer_payments_by_invoice.md)             | 11      |         | BASE TABLE |
| 52 | [marts.customers_to_email](marts.customers_to_email.md)                                 | 5       |         | BASE TABLE |
| 53 | [marts.emails_subject_cols](marts.emails_subject_cols.md)                               | 9       |         | BASE TABLE |
| 54 | [marts.emails_subject_concat](marts.emails_subject_concat.md)                           | 6       |         | BASE TABLE |
| 55 | [marts.incremental_pk_tester](marts.incremental_pk_tester.md)                           | 5       |         | BASE TABLE |
| 56 | [marts.incremental_pk_tester_merge_only](marts.incremental_pk_tester_merge_only.md)     | 5       |         | BASE TABLE |
| 57 | [marts.incremental_tester](marts.incremental_tester.md)                                 | 5       |         | BASE TABLE |
| 58 | [marts.most_popular_products_agg](marts.most_popular_products_agg.md)                   | 3       |         | BASE TABLE |
| 59 | [marts.most_popular_products_by_store_agg](marts.most_popular_products_by_store_agg.md) | 4       |         | BASE TABLE |
| 60 | [marts.outstanding_invoices](marts.outstanding_invoices.md)                             | 8       |         | BASE TABLE |
| 61 | [source.customer](source.customer.md)                                                   | 11      |         | BASE TABLE |
| 62 | [source.customer_audit](source.customer_audit.md)                                       | 13      |         | BASE TABLE |
| 63 | [source.emails](source.emails.md)                                                       | 5       |         | BASE TABLE |
| 64 | [source.financial_account](source.financial_account.md)                                 | 7       |         | BASE TABLE |
| 65 | [source.integration](source.integration.md)                                             | 6       |         | BASE TABLE |
| 66 | [source.invoice](source.invoice.md)                                                     | 7       |         | BASE TABLE |
| 67 | [source.order](source.order.md)                                                         | 5       |         | BASE TABLE |
| 68 | [source.order_detail](source.order_detail.md)                                           | 7       |         | BASE TABLE |
| 69 | [source.order_json](source.order_json.md)                                               | 4       |         | BASE TABLE |
| 70 | [source.payment](source.payment.md)                                                     | 7       |         | BASE TABLE |
| 71 | [source.payment_type](source.payment_type.md)                                           | 6       |         | BASE TABLE |
| 72 | [source.product](source.product.md)                                                     | 5       |         | BASE TABLE |
| 73 | [source.product_category](source.product_category.md)                                   | 4       |         | BASE TABLE |
| 74 | [source.product_price](source.product_price.md)                                         | 8       |         | BASE TABLE |
| 75 | [source.sales_data](source.sales_data.md)                                               | 11      |         | BASE TABLE |
| 76 | [source.store](source.store.md)                                                         | 9       |         | BASE TABLE |

## Enums

| Name | Values |
| ---- | ------- |
| source.financial_account_enum | Asset, Equity, Expense, Liability, Revenue |
| source.integration_enum | Hubspot, Mailchimp, Salesforce |
| source.payment_enum | Cash, Credit Card, Debit Card, Gift Card |

## Relations

```mermaid
erDiagram

"marts.customer_integration_history_scd2" }|--|| "source.customer" : "id -> customer_id"
"source.invoice" }o--o| "source.order" : "FOREIGN KEY (order_id) REFERENCES source."order"(id)"
"source.order" }o--o| "source.customer" : "FOREIGN KEY (customer_id) REFERENCES source.customer(id)"
"source.order" }o--o| "source.store" : "FOREIGN KEY (store_id) REFERENCES source.store(id)"
"source.order_detail" }o--|| "source.order" : "FOREIGN KEY (order_id) REFERENCES source."order"(id)"
"source.order_detail" }o--|| "source.product" : "FOREIGN KEY (product_id) REFERENCES source.product(id)"
"source.order_detail" }o--|| "source.product_price" : "FOREIGN KEY (product_price_id) REFERENCES source.product_price(id)"
"source.payment" }o--o| "source.payment_type" : "FOREIGN KEY (payment_type_id) REFERENCES source.payment_type(id)"
"source.payment" }o--o| "source.invoice" : "FOREIGN KEY (invoice_id) REFERENCES source.invoice(id)"
"source.product" }o--o| "source.product_category" : "FOREIGN KEY (product_category_id) REFERENCES source.product_category(id)"
"source.product_price" }o--o| "source.product" : "FOREIGN KEY (product_id) REFERENCES source.product(id)"

"dbt_stg.alerts_anomaly_detection" {
  text alert_description
  text alert_id
  text alert_results_query
  varchar_4096_ alert_type
  varchar_4096_ column_name
  varchar_4096_ data_issue_id
  varchar_4096_ database_name
  timestamp_without_time_zone detected_at
  text model_unique_id
  varchar_4096_ other
  varchar_4096_ owners
  text result_rows
  varchar_4096_ schema_name
  varchar_4096_ severity
  varchar_4096_ status
  varchar_4096_ sub_type
  varchar_4096_ table_name
  varchar_4096_ tags
  text test_execution_id
  text test_name
  text test_params
  varchar_4096_ test_short_name
  text test_unique_id
}
"dbt_stg.alerts_dbt_models" {
  text alert_id
  varchar_4096_ alias
  varchar_4096_ database_name
  timestamp_without_time_zone detected_at
  boolean full_refresh
  varchar_4096_ materialization
  text message
  text original_path
  varchar_4096_ owners
  varchar_4096_ path
  varchar_4096_ schema_name
  varchar_4096_ status
  text tags
  text unique_id
}
"dbt_stg.alerts_dbt_source_freshness" {
  varchar_4096_ alert_id
  varchar_4096_ database_name
  timestamp_without_time_zone detected_at
  varchar_4096_ error
  varchar_4096_ error_after
  text filter
  varchar_4096_ freshness_error_after
  text freshness_filter
  varchar_4096_ freshness_warn_after
  varchar_4096_ identifier
  varchar_4096_ max_loaded_at
  double_precision max_loaded_at_time_ago_in_s
  text meta
  varchar_4096_ owner
  varchar_4096_ package_name
  varchar_4096_ path
  varchar_4096_ schema_name
  varchar_4096_ snapshotted_at
  varchar_4096_ source_name
  varchar_4096_ status
  text tags
  varchar_4096_ unique_id
  varchar_4096_ warn_after
}
"dbt_stg.alerts_dbt_tests" {
  text alert_description
  text alert_id
  text alert_results_query
  varchar_4096_ alert_type
  varchar_4096_ column_name
  varchar_4096_ data_issue_id
  varchar_4096_ database_name
  timestamp_without_time_zone detected_at
  text model_unique_id
  varchar_4096_ other
  varchar_4096_ owners
  text result_rows
  varchar_4096_ schema_name
  varchar_4096_ severity
  varchar_4096_ status
  varchar_4096_ sub_type
  varchar_4096_ table_name
  varchar_4096_ tags
  text test_execution_id
  text test_name
  text test_params
  varchar_4096_ test_short_name
  text test_unique_id
}
"dbt_stg.alerts_schema_changes" {
  text alert_description
  text alert_id
  text alert_results_query
  varchar_4096_ alert_type
  varchar_4096_ column_name
  varchar_4096_ data_issue_id
  varchar_4096_ database_name
  timestamp_without_time_zone detected_at
  text model_unique_id
  varchar_4096_ other
  varchar_4096_ owners
  text result_rows
  varchar_4096_ schema_name
  varchar_4096_ severity
  varchar_4096_ status
  varchar_4096_ sub_type
  varchar_4096_ table_name
  varchar_4096_ tags
  text test_execution_id
  text test_name
  text test_params
  varchar_4096_ test_short_name
  text test_unique_id
}
"dbt_stg.anomaly_threshold_sensitivity" {
  double_precision anomaly_score
  varchar_4096_ column_name
  varchar_4096_ full_table_name
  boolean is_anomaly_1_5
  boolean is_anomaly_2
  boolean is_anomaly_2_5
  boolean is_anomaly_3
  boolean is_anomaly_3_5
  boolean is_anomaly_4
  boolean is_anomaly_4_5
  double_precision latest_metric_value
  double_precision metric_avg
  varchar_4096_ metric_name
  double_precision metric_stddev
}
"dbt_stg.countries" {
  text country_code
  text country_name
  integer country_rank
  integer test_fail
}
"dbt_stg.country_codes" {
  text country_code
  text country_name
}
"dbt_stg.customer_changes_agg" {
  integer customer_id
  timestamp_without_time_zone max_modified_at
  bigint num_records
}
"dbt_stg.data_monitoring_metrics" {
  integer bucket_duration_hours
  timestamp_without_time_zone bucket_end
  timestamp_without_time_zone bucket_start
  varchar_4096_ column_name
  timestamp_without_time_zone created_at
  varchar_4096_ dimension
  varchar_4096_ dimension_value
  varchar_4096_ full_table_name
  varchar_4096_ id
  varchar_4096_ metric_name
  varchar_4096_ metric_properties
  varchar_4096_ metric_type
  double_precision metric_value
  varchar_4096_ source_value
  timestamp_without_time_zone updated_at
}
"dbt_stg.dbt_artifacts_hashes" {
  text artifacts_model
  varchar_4096_ metadata_hash
}
"dbt_stg.dbt_columns" {
  varchar_4096_ data_type
  varchar_4096_ database_name
  text description
  varchar_4096_ generated_at
  text meta
  varchar_4096_ metadata_hash
  varchar_4096_ name
  varchar_4096_ parent_unique_id
  varchar_4096_ resource_type
  varchar_4096_ schema_name
  varchar_4096_ table_name
  text tags
  varchar_4096_ unique_id
}
"dbt_stg.dbt_exposures" {
  text depends_on_columns
  text depends_on_macros
  text depends_on_nodes
  text description
  varchar_4096_ generated_at
  varchar_4096_ label
  varchar_4096_ maturity
  text meta
  varchar_4096_ metadata_hash
  varchar_4096_ name
  text original_path
  varchar_4096_ owner_email
  varchar_4096_ owner_name
  varchar_4096_ package_name
  varchar_4096_ path
  text raw_queries
  text tags
  varchar_4096_ type
  varchar_4096_ unique_id
  text url
}
"dbt_stg.dbt_invocations" {
  varchar_4096_ account_id
  text cause
  varchar_4096_ cause_category
  varchar_4096_ command
  timestamp_without_time_zone created_at
  varchar_4096_ dbt_user
  varchar_4096_ dbt_version
  varchar_4096_ elementary_version
  varchar_4096_ env
  varchar_4096_ env_id
  boolean full_refresh
  varchar_4096_ generated_at
  varchar_4096_ git_sha
  text invocation_id
  text invocation_vars
  text job_id
  text job_name
  text job_run_id
  varchar_4096_ job_run_url
  varchar_4096_ job_url
  varchar_4096_ orchestrator
  varchar_4096_ project_id
  varchar_4096_ project_name
  varchar_4096_ pull_request_id
  varchar_4096_ run_completed_at
  varchar_4096_ run_started_at
  text selected
  text target_adapter_specific_fields
  varchar_4096_ target_database
  varchar_4096_ target_name
  varchar_4096_ target_profile_name
  varchar_4096_ target_schema
  integer threads
  text vars
  text yaml_selector
}
"dbt_stg.dbt_metrics" {
  text depends_on_macros
  text depends_on_nodes
  text description
  text dimensions
  text filters
  varchar_4096_ generated_at
  varchar_4096_ label
  text meta
  varchar_4096_ metadata_hash
  varchar_4096_ model
  varchar_4096_ name
  text original_path
  varchar_4096_ package_name
  varchar_4096_ path
  text sql
  text tags
  text time_grains
  varchar_4096_ timestamp
  varchar_4096_ type
  varchar_4096_ unique_id
}
"dbt_stg.dbt_models" {
  varchar_4096_ alias
  varchar_4096_ checksum
  varchar_4096_ database_name
  text depends_on_macros
  text depends_on_nodes
  text description
  varchar_4096_ generated_at
  varchar_4096_ materialization
  text meta
  varchar_4096_ metadata_hash
  varchar_4096_ name
  text original_path
  varchar_4096_ owner
  varchar_4096_ package_name
  varchar_4096_ patch_path
  varchar_4096_ path
  varchar_4096_ schema_name
  text tags
  varchar_4096_ unique_id
}
"dbt_stg.dbt_run_results" {
  varchar_4096_ adapter_response
  varchar_4096_ compile_completed_at
  varchar_4096_ compile_started_at
  text compiled_code
  timestamp_without_time_zone created_at
  varchar_4096_ execute_completed_at
  varchar_4096_ execute_started_at
  double_precision execution_time
  bigint failures
  boolean full_refresh
  varchar_4096_ generated_at
  varchar_4096_ invocation_id
  varchar_4096_ materialization
  text message
  text model_execution_id
  text name
  varchar_4096_ query_id
  varchar_4096_ resource_type
  bigint rows_affected
  varchar_4096_ status
  varchar_4096_ thread_id
  text unique_id
}
"dbt_stg.dbt_seeds" {
  varchar_4096_ alias
  varchar_4096_ checksum
  varchar_4096_ database_name
  text description
  varchar_4096_ generated_at
  text meta
  varchar_4096_ metadata_hash
  varchar_4096_ name
  text original_path
  varchar_4096_ owner
  varchar_4096_ package_name
  varchar_4096_ path
  varchar_4096_ schema_name
  text tags
  varchar_4096_ unique_id
}
"dbt_stg.dbt_snapshots" {
  varchar_4096_ alias
  varchar_4096_ checksum
  varchar_4096_ database_name
  text depends_on_macros
  text depends_on_nodes
  text description
  varchar_4096_ generated_at
  varchar_4096_ materialization
  text meta
  varchar_4096_ metadata_hash
  varchar_4096_ name
  text original_path
  varchar_4096_ owner
  varchar_4096_ package_name
  varchar_4096_ patch_path
  varchar_4096_ path
  varchar_4096_ schema_name
  text tags
  varchar_4096_ unique_id
}
"dbt_stg.dbt_source_freshness_results" {
  varchar_4096_ compile_completed_at
  varchar_4096_ compile_started_at
  timestamp_without_time_zone created_at
  varchar_4096_ error
  varchar_4096_ error_after
  varchar_4096_ execute_completed_at
  varchar_4096_ execute_started_at
  text filter
  varchar_4096_ generated_at
  varchar_4096_ invocation_id
  varchar_4096_ max_loaded_at
  double_precision max_loaded_at_time_ago_in_s
  varchar_4096_ snapshotted_at
  varchar_4096_ source_freshness_execution_id
  varchar_4096_ status
  varchar_4096_ unique_id
  varchar_4096_ warn_after
}
"dbt_stg.dbt_sources" {
  varchar_4096_ database_name
  text description
  text freshness_description
  varchar_4096_ freshness_error_after
  text freshness_filter
  varchar_4096_ freshness_warn_after
  varchar_4096_ generated_at
  varchar_4096_ identifier
  varchar_4096_ loaded_at_field
  text meta
  varchar_4096_ metadata_hash
  varchar_4096_ name
  text original_path
  varchar_4096_ owner
  varchar_4096_ package_name
  varchar_4096_ path
  varchar_4096_ relation_name
  varchar_4096_ schema_name
  text source_description
  varchar_4096_ source_name
  text tags
  varchar_4096_ unique_id
}
"dbt_stg.dbt_tests" {
  varchar_4096_ alias
  varchar_4096_ database_name
  text depends_on_macros
  text depends_on_nodes
  text description
  varchar_4096_ error_if
  varchar_4096_ generated_at
  text meta
  varchar_4096_ metadata_hash
  text model_owners
  text model_tags
  varchar_4096_ name
  text original_path
  varchar_4096_ package_name
  varchar_4096_ parent_model_unique_id
  varchar_4096_ path
  varchar_4096_ quality_dimension
  varchar_4096_ schema_name
  varchar_4096_ severity
  varchar_4096_ short_name
  text tags
  varchar_4096_ test_column_name
  varchar_4096_ test_namespace
  varchar_4096_ test_original_name
  text test_params
  varchar_4096_ type
  varchar_4096_ unique_id
  varchar_4096_ warn_if
}
"dbt_stg.elementary_test_results" {
  varchar_4096_ column_name
  timestamp_without_time_zone created_at
  varchar_4096_ data_issue_id
  varchar_4096_ database_name
  timestamp_without_time_zone detected_at
  bigint failed_row_count
  bigint failures
  text id
  varchar_4096_ invocation_id
  text model_unique_id
  varchar_4096_ other
  varchar_4096_ owners
  text result_rows
  varchar_4096_ schema_name
  varchar_4096_ severity
  varchar_4096_ status
  varchar_4096_ table_name
  varchar_4096_ tags
  varchar_4096_ test_alias
  text test_execution_id
  text test_name
  text test_params
  text test_results_description
  text test_results_query
  varchar_4096_ test_short_name
  varchar_4096_ test_sub_type
  varchar_4096_ test_type
  text test_unique_id
}
"dbt_stg.failed_tests" {
  timestamp_without_time_zone generated_at
  text id
  varchar_4096_ test_name
  varchar_4096_ test_status
  varchar_4096_ test_type
}
"dbt_stg.job_run_results" {
  text id
  text name
  timestamp_without_time_zone run_completed_at
  double_precision run_execution_time
  text run_id
  timestamp_without_time_zone run_started_at
}
"dbt_stg.metadata" {
  text dbt_pkg_version
}
"dbt_stg.metrics_anomaly_score" {
  double_precision anomaly_score
  timestamp_without_time_zone bucket_end
  timestamp_without_time_zone bucket_start
  varchar_4096_ column_name
  varchar_4096_ dimension
  varchar_4096_ dimension_value
  varchar_4096_ full_table_name
  varchar_4096_ id
  boolean is_anomaly
  double_precision latest_metric_value
  varchar_4096_ metric_name
  double_precision training_avg
  timestamp_without_time_zone training_end
  bigint training_set_size
  timestamp_without_time_zone training_start
  double_precision training_stddev
  timestamp_without_time_zone updated_at
}
"dbt_stg.model_run_results" {
  varchar_4096_ adapter_response
  varchar_4096_ alias
  varchar_4096_ compile_completed_at
  varchar_4096_ compile_started_at
  text compiled_code
  varchar_4096_ database_name
  varchar_4096_ execute_completed_at
  varchar_4096_ execute_started_at
  double_precision execution_time
  boolean full_refresh
  varchar_4096_ generated_at
  varchar_4096_ invocation_id
  boolean is_the_first_invocation_of_the_day
  boolean is_the_last_invocation_of_the_day
  varchar_4096_ materialization
  text message
  text model_execution_id
  bigint model_invocation_reverse_index
  text name
  text original_path
  varchar_4096_ owner
  varchar_4096_ package_name
  varchar_4096_ path
  varchar_4096_ query_id
  varchar_4096_ schema_name
  varchar_4096_ status
  text tags
  varchar_4096_ thread_id
  text unique_id
}
"dbt_stg.monitors_runs" {
  varchar_4096_ column_name
  timestamp_without_time_zone first_bucket_end
  varchar_4096_ full_table_name
  timestamp_without_time_zone last_bucket_end
  varchar_4096_ metric_name
  varchar_4096_ metric_properties
}
"dbt_stg.ohshit" {
  date end_date
  integer id
  timestamp_without_time_zone modified_at
  date start_date
}
"dbt_stg.orders_snapshot" {
  numeric_10_2_ amount
  timestamp_without_time_zone created_at
  text dbt_scd_id
  timestamp_without_time_zone dbt_updated_at
  timestamp_without_time_zone dbt_valid_from
  timestamp_without_time_zone dbt_valid_to
  integer id
  integer invoice_id
  timestamp_without_time_zone modified_at
  varchar_100_ payment_type_detail
  integer payment_type_id
}
"dbt_stg.schema_columns_snapshot" {
  varchar_4096_ column_name
  varchar_4096_ column_state_id
  timestamp_without_time_zone created_at
  varchar_4096_ data_type
  timestamp_without_time_zone detected_at
  varchar_4096_ full_column_name
  varchar_4096_ full_table_name
  boolean is_new
}
"dbt_stg.seed_run_results" {
  varchar_4096_ adapter_response
  varchar_4096_ alias
  varchar_4096_ compile_completed_at
  varchar_4096_ compile_started_at
  text compiled_code
  varchar_4096_ database_name
  varchar_4096_ execute_completed_at
  varchar_4096_ execute_started_at
  double_precision execution_time
  boolean full_refresh
  varchar_4096_ generated_at
  varchar_4096_ invocation_id
  varchar_4096_ materialization
  text message
  text model_execution_id
  text name
  text original_path
  varchar_4096_ owner
  varchar_4096_ package_name
  varchar_4096_ path
  varchar_4096_ query_id
  varchar_4096_ schema_name
  varchar_4096_ status
  text tags
  varchar_4096_ thread_id
  text unique_id
}
"dbt_stg.snapshot_run_results" {
  varchar_4096_ adapter_response
  varchar_4096_ alias
  varchar_4096_ compile_completed_at
  varchar_4096_ compile_started_at
  text compiled_code
  varchar_4096_ database_name
  varchar_4096_ execute_completed_at
  varchar_4096_ execute_started_at
  double_precision execution_time
  boolean full_refresh
  varchar_4096_ generated_at
  varchar_4096_ invocation_id
  varchar_4096_ materialization
  text message
  text model_execution_id
  text name
  text original_path
  varchar_4096_ owner
  varchar_4096_ package_name
  varchar_4096_ path
  varchar_4096_ query_id
  varchar_4096_ schema_name
  varchar_4096_ status
  text tags
  varchar_4096_ thread_id
  text unique_id
}
"dbt_stg.test_result_rows" {
  timestamp_without_time_zone created_at
  timestamp_without_time_zone detected_at
  text elementary_test_results_id
  text result_row
}
"dim.dim_customers" {
  varchar_100_ address
  varchar_100_ address_2
  integer audit_id
  varchar_50_ city
  varchar_50_ country
  varchar_100_ customer_email
  integer customer_id
  varchar_100_ customer_name
  timestamp_with_time_zone dbt_updated_at
  integer is_current_record
  integer is_deleted
  integer is_latest_record
  varchar_3_ state
  timestamp_without_time_zone valid_from
  timestamp_without_time_zone valid_to
  integer zip_code
}
"dim.dim_financial_accounts" {
  timestamp_without_time_zone created_at
  text financial_account_description
  integer financial_account_id
  varchar_100_ financial_account_name
  source_financial_account_enum financial_account_type
  boolean is_active
  timestamp_without_time_zone modified_at
}
"dim.dim_integrations" {
  timestamp_without_time_zone created_at
  varchar_100_ customer_email
  integer customer_id
  integer id
  source_integration_enum integration_type
  integer is_active
  timestamp_without_time_zone modified_at
}
"dim.dim_payment_types" {
  timestamp_without_time_zone created_at
  integer financial_account_id
  timestamp_without_time_zone modified_at
  source_payment_enum payment_type
  varchar_100_ payment_type_description
  integer payment_type_id
}
"dim.dim_products" {
  timestamp_without_time_zone created_at
  timestamp_without_time_zone modified_at
  varchar_100_ product_category_name
  integer product_id
  varchar_100_ product_name
}
"dim.dim_stores" {
  varchar_100_ city
  timestamp_without_time_zone created_at
  integer is_shipping_enabled_state
  timestamp_without_time_zone modified_at
  varchar_2_ state
  integer store_id
  varchar_100_ store_name
  varchar_100_ street
  integer zip_code
}
"fact.fact_emails" {
  timestamp_without_time_zone created_at
  timestamp_with_time_zone dbt_created_at
  integer email_id
  varchar_100_ email_name
  json messages
  timestamp_without_time_zone modified_at
}
"fact.fact_orders_detailed" {
  integer customer_id
  timestamp_without_time_zone order_detail_created_at
  integer order_detail_id
  timestamp_without_time_zone order_detail_modified_at
  integer order_id
  integer product_category_id
  integer product_id
  numeric_10_2_ product_price
  integer product_price_id
  integer quantity
  integer store_id
}
"fact.fact_orders_external_system" {
  timestamp_without_time_zone created_at
  integer order_id
  integer sale_id
  text source_address
  text source_state
  text source_store
  timestamp_without_time_zone source_timestamp
  integer source_zip_code
}
"fact.fact_orders_generalized" {
  integer customer_id
  timestamp_without_time_zone invoice_created_at
  integer invoice_id
  timestamp_without_time_zone invoice_modified_at
  numeric_10_2_ invoice_total_amount
  timestamp_without_time_zone order_created_at
  integer order_id
  timestamp_without_time_zone order_modified_at
  integer store_id
}
"fact.fact_payments" {
  integer customer_id
  integer financial_account_id
  integer invoice_id
  integer order_id
  numeric_10_2_ payment_amount
  timestamp_without_time_zone payment_created_at
  integer payment_id
  timestamp_without_time_zone payment_modified_at
  integer payment_type_id
}
"fact.fact_product_prices" {
  boolean is_active
  numeric_10_2_ price
  integer product_id
  timestamp_without_time_zone product_price_created_at
  integer product_price_id
  timestamp_without_time_zone product_price_modified_at
  timestamp_without_time_zone valid_from
  timestamp_without_time_zone valid_to
}
"marts.accounting_by_state_agg" {
  date as_of_date
  varchar_100_ financial_account_name
  varchar_2_ state
  numeric total_account_amount
}
"marts.accounting_by_store_agg" {
  date as_of_date
  varchar_100_ financial_account_name
  varchar_100_ store_name
  numeric total_account_amount
}
"marts.customer_integration_history_scd2" {
  integer customer_id
  text integration_type
  integer is_active
  integer is_current_integration_record
  timestamp_without_time_zone valid_from
  timestamp_without_time_zone valid_to
}
"marts.customer_payments_by_invoice" {
  integer customer_id
  timestamp_without_time_zone invoice_created_at
  integer invoice_id
  timestamp_without_time_zone invoice_modified_at
  numeric invoice_paid_amount
  numeric_10_2_ invoice_total_amount
  integer is_invoice_closed
  timestamp_without_time_zone order_created_at
  integer order_id
  timestamp_without_time_zone order_modified_at
  integer store_id
}
"marts.customers_to_email" {
  varchar_100_ customer_email
  varchar_100_ customer_name
  integer order_detail_id
  varchar_100_ product_category_name
  varchar_100_ product_name
}
"marts.emails_subject_cols" {
  timestamp_without_time_zone created_at
  timestamp_with_time_zone dbt_created_at
  integer email_id
  varchar_100_ email_name
  timestamp_without_time_zone modified_at
  text subject_1
  text subject_2
  text subject_3
  text subject_4
}
"marts.emails_subject_concat" {
  timestamp_without_time_zone created_at
  timestamp_without_time_zone dbt_created_at
  integer email_id
  varchar_100_ email_name
  timestamp_without_time_zone modified_at
  text subjects
}
"marts.incremental_pk_tester" {
  timestamp_with_time_zone added_at
  integer c_id
  timestamp_without_time_zone created_at
  integer id
  timestamp_without_time_zone modified_at
}
"marts.incremental_pk_tester_merge_only" {
  timestamp_without_time_zone created_at
  integer customer_id
  integer id
  timestamp_without_time_zone modified_at
  integer store_id
}
"marts.incremental_tester" {
  timestamp_without_time_zone created_at
  integer customer_id
  integer id
  timestamp_without_time_zone modified_at
  integer store_id
}
"marts.most_popular_products_agg" {
  varchar_100_ product_category_name
  varchar_100_ product_name
  bigint units_sold
}
"marts.most_popular_products_by_store_agg" {
  varchar_100_ product_category_name
  varchar_100_ product_name
  varchar_100_ store_name
  bigint units_sold
}
"marts.outstanding_invoices" {
  varchar customer_email
  varchar customer_name
  timestamp_without_time_zone invoice_created_at
  integer invoice_id
  numeric invoice_paid_amount
  numeric invoice_remaining_balance
  numeric invoice_total_amount
  timestamp_without_time_zone latest_payment_made
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
"source.customer_audit" {
  varchar_100_ address
  varchar_100_ address_2
  integer audit_type
  varchar_50_ city
  varchar_50_ country
  timestamp_without_time_zone created_at
  varchar_100_ customer_email
  integer customer_id
  varchar_100_ customer_name
  integer id
  timestamp_without_time_zone modified_at
  varchar_3_ state
  integer zip_code
}
"source.emails" {
  timestamp_without_time_zone created_at
  varchar_100_ email_name
  integer id
  json messages
  timestamp_without_time_zone modified_at
}
"source.financial_account" {
  timestamp_without_time_zone created_at
  text financial_account_description
  varchar_100_ financial_account_name
  source_financial_account_enum financial_account_type
  integer id
  boolean is_active
  timestamp_without_time_zone modified_at
}
"source.integration" {
  timestamp_without_time_zone created_at
  integer customer_id
  integer id
  source_integration_enum integration_type
  integer is_active
  timestamp_without_time_zone modified_at
}
"source.invoice" {
  timestamp_without_time_zone created_at
  varchar_3_ currency
  integer id
  boolean is_voided
  timestamp_without_time_zone modified_at
  integer order_id FK
  numeric_10_2_ total_amount
}
"source.order" {
  timestamp_without_time_zone created_at
  integer customer_id FK
  integer id
  timestamp_without_time_zone modified_at
  integer store_id FK
}
"source.order_detail" {
  timestamp_without_time_zone created_at
  integer id
  timestamp_without_time_zone modified_at
  integer order_id FK
  integer product_id FK
  integer product_price_id FK
  integer quantity
}
"source.order_json" {
  timestamp_without_time_zone created_at
  json external_data
  integer id
  timestamp_without_time_zone modified_at
}
"source.payment" {
  numeric_10_2_ amount
  timestamp_without_time_zone created_at
  integer id
  integer invoice_id FK
  timestamp_without_time_zone modified_at
  varchar_100_ payment_type_detail
  integer payment_type_id FK
}
"source.payment_type" {
  timestamp_without_time_zone created_at
  integer financial_account_id
  integer id
  timestamp_without_time_zone modified_at
  source_payment_enum payment_type
  varchar_100_ payment_type_description
}
"source.product" {
  timestamp_without_time_zone created_at
  integer id
  timestamp_without_time_zone modified_at
  integer product_category_id FK
  varchar_100_ product_name
}
"source.product_category" {
  timestamp_without_time_zone created_at
  integer id
  timestamp_without_time_zone modified_at
  varchar_100_ product_category_name
}
"source.product_price" {
  timestamp_without_time_zone created_at
  integer id
  boolean is_active
  timestamp_without_time_zone modified_at
  numeric_10_2_ price
  integer product_id FK
  timestamp_without_time_zone valid_from
  timestamp_without_time_zone valid_to
}
"source.sales_data" {
  varchar_100_ address
  varchar_100_ color
  timestamp_without_time_zone created_at
  varchar_100_ email
  date hire_date
  integer id
  varchar_100_ name
  numeric_10_2_ salary
  varchar_100_ status
  integer store_id
  varchar_100_ username
}
"source.store" {
  varchar_100_ city
  varchar_50_ country
  timestamp_without_time_zone created_at
  integer id
  timestamp_without_time_zone modified_at
  varchar_2_ state
  varchar_100_ store_name
  varchar_100_ street
  integer zip_code
}
```

---

> Generated by [tbls](https://github.com/k1LoW/tbls)
