import os
from typing import Any

import json


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


models_with_meta = parse_dbt_meta(manifest_file="target/smanifest.json")

model_num = 1
for model_name, meta in models_with_meta.items():
    print(f"Model {model_num}: {model_name}")
    print("Meta Options:")
    for option, value in meta.items():
        print(f"  {option}: {value}")
    print("-" * 50)
    model_num += 1
