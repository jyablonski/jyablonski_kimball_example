{{ generate_scd2_model(
    source_relation=source('application_db', 'store_audit'),
    primary_key='id',
    entity_id='store_id',
    timestamp_field='modified_at',
    additional_columns=[
        'store_name',
        'manager_name',
        'region',
        'square_footage',
        'store_type',
        'monthly_rent',
        'opened_date'
    ],
    deleted_flag_column='audit_type',
    deleted_flag_value=3
) }}
