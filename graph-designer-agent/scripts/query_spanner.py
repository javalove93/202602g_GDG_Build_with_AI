import os
import sys
from google.cloud import spanner
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

PROJECT_ID = os.getenv("GCP_PROJECT_ID")
INSTANCE_ID = os.getenv("SPANNER_INSTANCE_ID")
DATABASE_ID = os.getenv("SPANNER_DATABASE_ID")

def run_query(query):
    if not PROJECT_ID or not INSTANCE_ID or not DATABASE_ID:
        print("Error: Environment variables not set.")
        return

    spanner_client = spanner.Client(project=PROJECT_ID)
    instance = spanner_client.instance(INSTANCE_ID)
    database = instance.database(DATABASE_ID)

    with database.snapshot() as snapshot:
        results = snapshot.execute_sql(query)
        
        # Print column names
        if results.metadata and results.metadata.row_type:
            columns = [field.name for field in results.metadata.row_type.fields]
            print(" | ".join(columns))
            print("-" * 50)

        for row in results:
            print(" | ".join(map(str, row)))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python scripts/query_spanner.py \"SELECT * FROM MyTable\"")
        sys.exit(1)
    
    query_text = sys.argv[1]
    run_query(query_text)
