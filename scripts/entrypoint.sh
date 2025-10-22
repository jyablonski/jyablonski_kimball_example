#!/bin/bash
set -e

DBT_STATE_BUCKET="my-dbt-artifacts"
DBT_SOURCES_KEY="dbt/state/sources.json"
DBT_MANIFEST_KEY="dbt/state/manifest.json"
STATE_DIR="/dbt/target"

download_sources_state() {
    echo "Downloading sources.json from S3..."
    mkdir -p $STATE_DIR
    aws s3 cp s3://${DBT_STATE_BUCKET}/${DBT_SOURCES_KEY} ${STATE_DIR}/sources.json || {
        echo "No previous sources.json found"
        return 0
    }
}

upload_sources_state() {
    echo "Uploading sources.json to S3..."
    [ -f "${STATE_DIR}/sources.json" ] && \
        aws s3 cp ${STATE_DIR}/sources.json s3://${DBT_STATE_BUCKET}/${DBT_SOURCES_KEY}
}

download_manifest_state() {
    echo "Downloading manifest.json from S3..."
    mkdir -p $STATE_DIR
    aws s3 cp s3://${DBT_STATE_BUCKET}/${DBT_MANIFEST_KEY} ${STATE_DIR}/manifest.json || {
        echo "No previous manifest.json found"
        return 0
    }
}

upload_manifest_state() {
    echo "Uploading manifest.json to S3..."
    [ -f "${STATE_DIR}/manifest.json" ] && \
        aws s3 cp ${STATE_DIR}/manifest.json s3://${DBT_STATE_BUCKET}/${DBT_MANIFEST_KEY}
}

COMMAND=$1

case $COMMAND in
    "source-freshness")
        echo "Running dbt source freshness and saving state..."
        dbt source freshness --profiles-dir /dbt --project-dir /dbt
        upload_sources_state
        ;;
        
    "build-fresh")
        echo "Building models with fresh sources..."
        download_sources_state
        dbt source freshness --profiles-dir /dbt --project-dir /dbt
        shift
        dbt build --select "source_status:fresher+" --state ${STATE_DIR} "$@" --profiles-dir /dbt --project-dir /dbt
        ;;
        
    "build-changed-models")
        echo "Building new or modified models..."
        download_manifest_state
        shift
        dbt build --select "state:modified+" --state ${STATE_DIR} "$@" --profiles-dir /dbt --project-dir /dbt
        upload_manifest_state
        ;;
        
    "build-changed-models-ci")
        echo "Building new or modified models (CI - no state upload)..."
        download_manifest_state
        shift
        dbt build --select "state:modified+" --state ${STATE_DIR} --target ci "$@" --profiles-dir /dbt --project-dir /dbt
        # Intentionally NOT uploading manifest state - this is CI/test only
        ;;
        
    "build")
        echo "Running standard dbt build..."
        shift
        dbt build "$@" --profiles-dir /dbt --project-dir /dbt
        ;;
        
    *)
        echo "Running custom command: $@"
        exec "$@"
        ;;
esac