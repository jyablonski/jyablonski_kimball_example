{{ config(
    severity = 'warn',
    enabled = true,
    tags = ["quality"]) 
}}

/*
`dbt build --select tag:dim --exclude tag:quality` - this is an option to build the model and not run quality tests
`dbt test --select tag:quality` to actually run the quality tests

another option is to use `selectors.yml` to build out build commands

`dbt build --selector build_dim_models`
`dbt test --selector run_quality_tests`

*/

select *
from {{ ref('dim_stores') }}
where is_shipping_enabled_state != 1
