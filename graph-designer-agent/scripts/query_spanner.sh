#!/bin/bash

# Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

QUERY=$1

if [ -z "$QUERY" ]; then
    echo "Usage: ./scripts/query_spanner.sh \"SELECT * FROM MyTable\""
    exit 1
fi

gcloud spanner databases execute-sql ${SPANNER_DATABASE_ID} \
    --instance=${SPANNER_INSTANCE_ID} \
    --project=${GCP_PROJECT_ID} \
    --sql="${QUERY}"
