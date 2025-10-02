{{ generate_scd2_model(
    source_relation=source('application_db', 'user_geolocation_audit'),
    primary_key='id',
    entity_id='user_id',
    timestamp_field='modified_at',
    additional_columns=[
        'zip_code',
        'city',
        'state',
        'country',
        'device_type',
        'device_os',
        'browser',
        'ip_address',
        'is_vpn'
    ]
) }}
