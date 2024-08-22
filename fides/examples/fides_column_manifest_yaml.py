{
    "database": "postgres",
    "schema": "dim",
    "name": "dim_payment_types",
    "resource_type": "model",
    "package_name": "jyablonski_kimball_example",
    "path": "dim/dim_payment_types.sql",
    "original_file_path": "models/dim/dim_payment_types.sql",
    "unique_id": "model.jyablonski_kimball_example.dim_payment_types",
    "fqn": ["jyablonski_kimball_example", "dim", "dim_payment_types"],
    "alias": "dim_payment_types",
    "checksum": {
        "name": "sha256",
        "checksum": "4b221f730f1dd1ae193e9a0aad90f22980cc72d7ab3e047e71d2af6f7856bab0",
    },
    "config": {
        "enabled": True,
        "alias": None,
        "schema": "dim",
        "database": None,
        "tags": [],
        "meta": {
            "owner": "@jacob",
            "model_maturity": "in de",
            "pii": True,
            "fides": {"skip_processing": True},
            "fides_meta2": None,
        },
        "group": None,
        "materialized": "table",
        "incremental_strategy": None,
        "persist_docs": {},
        "post-hook": [],
        "pre-hook": [],
        "quoting": {},
        "column_types": {},
        "full_refresh": None,
        "unique_key": None,
        "on_schema_change": "ignore",
        "on_configuration_change": "apply",
        "grants": {},
        "packages": [],
        "docs": {"show": True, "node_color": None},
        "contract": {"enforced": False, "alias_types": True},
        "access": "protected",
    },
    "tags": [],
    "description": "",
    "columns": {
        "product_id": {
            "name": "product_id",
            "description": "",
            "meta": {
                "contains_pii": True,
                "fides": {
                    "data_categories": ["user.contact.email"],
                    "fides_meta": {
                        "references": None,
                        "identity": "email",
                        "primary_key": None,
                        "data_type": "string",
                        "length": None,
                        "return_all_elements": None,
                        "read_only": None,
                    },
                },
            },
            "data_type": None,
            "constraints": [],
            "quote": None,
            "tags": [],
        }
    },
    "meta": {
        "owner": "@jacob",
        "model_maturity": "in de",
        "pii": True,
        "fides": {"skip_processing": True},
        "fides_meta2": None,
    },
    "group": None,
    "docs": {"show": True, "node_color": None},
    "patch_path": "jyablonski_kimball_example://models/dim/dim_payment_types.yml",
    "build_path": None,
    "unrendered_config": {
        "materialized": "table",
        "schema": "dim",
        "meta": {
            "owner": "@jacob",
            "model_maturity": "in de",
            "pii": True,
            "fides": {"skip_processing": True},
            "fides_meta2": None,
        },
    },
    "created_at": 1724346931.2604759,
    "relation_name": '"postgres"."dim"."dim_payment_types"',
    "raw_code": "select\n    id as payment_type_id,\n    financial_account_id,\n    payment_type,\n    payment_type_description,\n    created_at,\n    modified_at\nfrom {{ source('application_db', 'payment_type') }}",
    "language": "sql",
    "refs": [],
    "sources": [["application_db", "payment_type"]],
    "metrics": [],
    "depends_on": {
        "macros": [],
        "nodes": ["source.jyablonski_kimball_example.application_db.payment_type"],
    },
    "compiled_path": "target/compiled/jyablonski_kimball_example/models/dim/dim_payment_types.sql",
    "compiled": True,
    "compiled_code": 'select\n    id as payment_type_id,\n    financial_account_id,\n    payment_type,\n    payment_type_description,\n    created_at,\n    modified_at\nfrom "postgres"."source"."payment_type"',
    "extra_ctes_injected": True,
    "extra_ctes": [],
    "contract": {"enforced": False, "alias_types": True, "checksum": None},
    "access": "protected",
    "constraints": [],
    "version": None,
    "latest_version": None,
    "deprecation_date": None,
}
