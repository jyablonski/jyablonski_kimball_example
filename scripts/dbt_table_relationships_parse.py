import json
import os
import yaml


def extract_table_relationships(
    manifest_path: str = "target/manifest.json", output_path: str = "test.yaml"
) -> None:
    """
    Extracts table relationships from dbt's manifest.json and writes them to a YAML file.

    Args:
        manifest_path (str): Path to the manifest.json file.
        output_path (str): Path to the output YAML file.

    Returns:
        None, but writes results to output YAML File
    """
    cardinality_options = ("zero_or_more", "zero_or_one", "exactly_one", "one_or_more")

    # check if manifest.json exists
    if not os.path.exists(manifest_path):
        print(f"File not found: {manifest_path}")
        return

    with open(manifest_path, "r") as file:
        manifest = json.load(file)

    # extract model nodes
    models = manifest.get("nodes", {})
    relationships = []

    # loop through each model
    for model_name, model_data in models.items():
        table_name = model_data.get("alias", model_name)
        schema_name = model_data.get("schema")
        full_table_name = f"{schema_name}.{table_name}"

        columns = model_data.get("columns", {})

        # loop through every column in the model
        for column_name, column_data in columns.items():
            meta = column_data.get("meta", {})

            # check for table_relationships in col metadata
            table_relationships = meta.get("table_relationships", [])

            for relationship in table_relationships:
                to_table = relationship.get("to_table")
                to_field = relationship.get("to_field")
                cardinality = relationship.get("cardinality")
                parent_cardinality = relationship.get("parent_cardinality")

                # skip table if it doesnt have all of the table relationships mapped out
                if not (to_table and to_field and cardinality and parent_cardinality):
                    continue

                if (cardinality not in cardinality_options) or (
                    parent_cardinality not in cardinality_options
                ):
                    raise ValueError(
                        f"`cardinality` for {table_name}.{to_table} not set correctly, needs to be one of {cardinality_options}"
                    )

                # for each table listed, map out the elements we need
                # to include in the yaml file
                relationship_def = {
                    "table": full_table_name,
                    "columns": [column_name],
                    "cardinality": cardinality,
                    "parentTable": to_table,
                    "parentCardinality": parent_cardinality,
                    "parentColumns": [to_field],
                    "def": f"{to_field} -> {column_name}",
                }

                relationships.append(relationship_def)

    # write output to YAML file
    with open(output_path, "w") as yaml_file:
        yaml.dump(relationships, yaml_file, sort_keys=False)

    print(f"Table relationships have been saved to {output_path}")


if __name__ == "__main__":
    extract_table_relationships()
