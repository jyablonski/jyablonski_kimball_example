{{ generate_scd2_model(
    source_relation=source('application_db', 'customer_audit'),
    primary_key='id',
    entity_id='customer_id',
    timestamp_field='modified_at',
    additional_columns=[
        'customer_name',
        'customer_email',
        'address',
        'address_2',
        'city',
        'zip_code',
        'state',
        'country'
    ],
    deleted_flag_column='audit_type',
    deleted_flag_value=2
) }}
