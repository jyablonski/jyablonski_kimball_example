import os
from typing import Any

import json
import yaml


def parse_dbt_meta(
    manifest_file: str = "target/manifest.json",
    meta_options: list[str] = ["owner", "model_maturity", "pii"],
) -> dict[str, dict[str, Any]]:
    """
    Function that parses the dbt Manifest JSON File to find & return
    and Models that have specific meta config parameters

    Args:
        manifest_file (str): Location for the Manifest JSON File

        meta_options (list[str]): List of Strings for the names of the
            Config Parameters you've saved in dbt model *.yaml files

    Returns:
        Dictionary of each model & the relevant config parameters we're
        looking for.

    Raises:
        `FileNotFoundError` if you pass in the wrong File Location

    """
    if not os.path.isfile(manifest_file):
        print(f"Error: '{manifest_file}' not found.")
        raise FileNotFoundError(
            f"Error: '{manifest_file}' not found. Please check the 'target/'"
            "directory. If the file does not exist, run 'dbt docs generate' to generate it."
        )
    meta_options = ["owner", "model_maturity", "pii"]

    with open(manifest_file, "r") as file:
        manifest = json.load(file)

    models_with_meta = {}

    for model_name, model_data in manifest["nodes"].items():

        # only parse models
        if model_data["resource_type"] == "model":
            relevant_meta = {}
            for option in meta_options:

                # if the model has an option we're looking for, save it to relevant_meta
                if option in model_data.get("meta", {}):
                    relevant_meta[option] = model_data["meta"][option]

            # if we saved any relevant info for a specific model, save it to models_with_meta
            if relevant_meta:
                models_with_meta[model_name] = relevant_meta

    return models_with_meta


models_with_meta = parse_dbt_meta(manifest_file="target/manifest.json")

model_num = 1
for model_name, meta in models_with_meta.items():
    print(f"Model {model_num}: {model_name}")
    print("Meta Options:")
    for option, value in meta.items():
        print(f"  {option}: {value}")
    print("-" * 50)
    model_num += 1


with open("target/manifest.json", "r") as file:
    manifest = json.load(file)

fides_dicts = {}

for model_name, model_data in manifest["nodes"].items():
    if model_data["resource_type"] == "model":
        meta_dict = model_data.get("meta", {})
        fides_data = meta_dict.get("fides")

        if fides_data:
            print(model_data)
            fides_model = model_name.split(".")[-1]
            fides_data["schema"] = model_data["schema"]
            fides_dicts[fides_model] = fides_data

return_dict = {
    "dim_products": {
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
        "schema": "dim",
    }
}

schema = return_dict["dim_products"]["schema"]
# Write to a YAML file
with open(f"fides/{schema}.yaml", "w") as file:
    return_dict["dim_products"].pop("schema")
    yaml.dump(return_dict, file, default_flow_style=False, sort_keys=False)

# example of what it looks like
d = {
    "database": "postgres",
    "schema": "dim",
    "name": "dim_products",
    "resource_type": "model",
    "package_name": "jyablonski_kimball_example",
    "path": "dim/dim_products.sql",
    "original_file_path": "models/dim/dim_products.sql",
    "unique_id": "model.jyablonski_kimball_example.dim_products",
    "fqn": ["jyablonski_kimball_example", "dim", "dim_products"],
    "alias": "dim_products",
    "checksum": {
        "name": "sha256",
        "checksum": "0aaf1ff0f21f525273551e9443d804bcd7eea14162b757f03b230a0402612841",
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
            "col1": {"try1": "val1", "try2": "val2", "try3": "val3"},
            "col2": "test2",
            "col3": "test3",
            "col4": "test4",
            "col5": "test5",
            "col6": "test6",
            "col7": "test7",
            "col8": "test8",
            "col9": "test9",
            "col10": "test10",
            "col11": "test11",
            "is_valid": None,
            "date_started": "2024-06-11",
            "profit": 43.43,
            "col15": "test15",
            "col16": "test16",
            "col17": "test17",
            "col18": "test18",
            "col19": "test19",
            "col20": "test20",
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
            "meta": {},
            "data_type": None,
            "constraints": [],
            "quote": None,
            "tags": [],
        },
        "product_name": {
            "name": "product_name",
            "description": "",
            "meta": {},
            "data_type": None,
            "constraints": [],
            "quote": None,
            "tags": [],
        },
    },
    "meta": {
        "owner": "@jacob",
        "model_maturity": "in de",
        "pii": True,
        "col1": {"try1": "val1", "try2": "val2", "try3": "val3"},
        "col2": "test2",
        "col3": "test3",
        "col4": "test4",
        "col5": "test5",
        "col6": "test6",
        "col7": "test7",
        "col8": "test8",
        "col9": "test9",
        "col10": "test10",
        "col11": "test11",
        "is_valid": None,
        "date_started": "2024-06-11",
        "profit": 43.43,
        "col15": "test15",
        "col16": "test16",
        "col17": "test17",
        "col18": "test18",
        "col19": "test19",
        "col20": "test20",
    },
    "group": None,
    "docs": {"show": True, "node_color": None},
    "patch_path": "jyablonski_kimball_example://models/dim/dim_products.yml",
    "build_path": None,
    "unrendered_config": {
        "materialized": "table",
        "schema": "dim",
        "meta": {
            "owner": "@jacob",
            "model_maturity": "in de",
            "pii": True,
            "col1": {"try1": "val1", "try2": "val2", "try3": "val3"},
            "col2": "test2",
            "col3": "test3",
            "col4": "test4",
            "col5": "test5",
            "col6": "test6",
            "col7": "test7",
            "col8": "test8",
            "col9": "test9",
            "col10": "test10",
            "col11": "test11",
            "is_valid": None,
            "date_started": "2024-06-11",
            "profit": 43.43,
            "col15": "test15",
            "col16": "test16",
            "col17": "test17",
            "col18": "test18",
            "col19": "test19",
            "col20": "test20",
        },
    },
    "created_at": 1724259355.3663225,
    "relation_name": '"postgres"."dim"."dim_products"',
    "raw_code": "select\n    product.id as product_id,\n    product.product_name,\n    product_category.product_category_name,\n    product.created_at,\n    product.modified_at\nfrom {{ source('application_db', 'product') }}\n    inner join {{ source('application_db', 'product_category') }} on product.product_category_id = product_category.id",
    "language": "sql",
    "refs": [],
    "sources": [["application_db", "product"], ["application_db", "product_category"]],
    "metrics": [],
    "depends_on": {
        "macros": [],
        "nodes": [
            "source.jyablonski_kimball_example.application_db.product",
            "source.jyablonski_kimball_example.application_db.product_category",
        ],
    },
    "compiled_path": "target/compiled/jyablonski_kimball_example/models/dim/dim_products.sql",
    "compiled": True,
    "compiled_code": 'select\n    product.id as product_id,\n    product.product_name,\n    product_category.product_category_name,\n    product.created_at,\n    product.modified_at\nfrom "postgres"."source"."product"\n    inner join "postgres"."source"."product_category" on product.product_category_id = product_category.id',
    "extra_ctes_injected": True,
    "extra_ctes": [],
    "contract": {"enforced": False, "alias_types": True, "checksum": None},
    "access": "protected",
    "constraints": [],
    "version": None,
    "latest_version": None,
    "deprecation_date": None,
}


input_file = "fides/dim.yaml"
output_file = "fides/dim.yaml"

# Open input file for reading and output file for writing
with open(input_file, "r") as infile, open(output_file, "w") as outfile:
    # Create a YAML loader and dumper
    yaml_loader = yaml.safe_load_all(infile)
    yaml_dumper = yaml.safe_dump

    for doc in yaml_loader:  # Stream each document in the YAML file
        if "table" not in doc:
            doc["table"] = {}

        for key in list(
            doc
        ):  # Use list() to create a copy of keys to avoid runtime changes
            if key.startswith("model."):
                # Move the model key-value pairs under the 'table' key
                doc["table"][key] = doc.pop(key)

        # Write the modified document back to the output file
        yaml_dumper(doc, outfile, default_flow_style=False, sort_keys=False)
