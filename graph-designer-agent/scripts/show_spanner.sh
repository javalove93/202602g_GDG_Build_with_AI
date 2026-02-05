#!/bin/bash

# Load environment variables from .env
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

echo "--------------------------------------------------"
echo "Spanner Environment Information"
echo "--------------------------------------------------"
echo "GCP Project ID:    ${GCP_PROJECT_ID}"
echo "GCP Region:        ${GCP_REGION}"
echo "Spanner Instance:  ${SPANNER_INSTANCE_ID}"
echo "Spanner Database:  ${SPANNER_DATABASE_ID}"
echo "Gemini Model:      ${GEMINI_MODEL}"
echo "--------------------------------------------------"
