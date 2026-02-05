#!/bin/bash

# Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

PROJECT_ID=${GCP_PROJECT_ID}
INSTANCE_ID=${SPANNER_INSTANCE_ID}
DATABASE_ID=${SPANNER_DATABASE_ID}
REGION=${GCP_REGION:-us-central1}

echo "Creating Spanner Instance: ${INSTANCE_ID} in ${PROJECT_ID} (${REGION})"

# Create Spanner Instance (Enterprise edition is required for Graph)
gcloud spanner instances create ${INSTANCE_ID} \
    --project=${PROJECT_ID} \
    --config=regional-${REGION} \
    --description="Graph Designer Instance" \
    --processing-units=100 \
    --edition=ENTERPRISE

echo "Creating Spanner Database: ${DATABASE_ID}"

# Create Spanner Database
gcloud spanner databases create ${DATABASE_ID} \
    --project=${PROJECT_ID} \
    --instance=${INSTANCE_ID}

echo "Setup Complete!"
