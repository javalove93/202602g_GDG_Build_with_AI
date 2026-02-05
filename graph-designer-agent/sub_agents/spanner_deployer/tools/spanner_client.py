import os
from google.cloud import spanner
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

PROJECT_ID = os.getenv("GCP_PROJECT_ID")
INSTANCE_ID = os.getenv("SPANNER_INSTANCE_ID")
DATABASE_ID = os.getenv("SPANNER_DATABASE_ID")

def deploy_spanner_ddl(ddl: str) -> str:
    """
    Deploys DDL statements to Google Cloud Spanner.
    
    Args:
        ddl: The DDL statements to execute. Can be multiple statements separated by semicolons.
        
    Returns:
        Success message or error message.
    """
    if not PROJECT_ID or not INSTANCE_ID or not DATABASE_ID:
        return "Error: Spanner environment variables (PROJECT_ID, INSTANCE_ID, DATABASE_ID) are not set."

    try:
        spanner_client = spanner.Client(project=PROJECT_ID)
        instance = spanner_client.instance(INSTANCE_ID)
        database = instance.database(DATABASE_ID)
        
        # Split DDL into individual statements and filter out empty ones
        ddl_statements = [s.strip() for s in ddl.split(';') if s.strip()]
        
        if not ddl_statements:
            return "Error: No valid DDL statements found."
            
        operation = database.update_ddl(ddl_statements)
        
        print("Waiting for DDL update to complete...")
        operation.result(timeout=600)
        
        return "DDL statements deployed successfully."
    except Exception as e:
        return f"Error deploying DDL: {str(e)}"

def execute_spanner_query(query: str) -> str:
    """
    Executes a SQL or GQL query on Google Cloud Spanner and returns the results.
    
    Args:
        query: The SQL or GQL query to execute.
        
    Returns:
        Query results formatted as a string or error message.
    """
    if not PROJECT_ID or not INSTANCE_ID or not DATABASE_ID:
        return "Error: Spanner environment variables (PROJECT_ID, INSTANCE_ID, DATABASE_ID) are not set."

    try:
        spanner_client = spanner.Client(project=PROJECT_ID)
        instance = spanner_client.instance(INSTANCE_ID)
        database = instance.database(DATABASE_ID)
        
        results_str = []
        with database.snapshot() as snapshot:
            results = snapshot.execute_sql(query)
            
            # Get column names
            if results.metadata and results.metadata.row_type:
                columns = [field.name for field in results.metadata.row_type.fields]
                results_str.append(" | ".join(columns))
                results_str.append("-" * (len(results_str[0]) + 2))
            
            for row in results:
                results_str.append(" | ".join(map(str, row)))
                
        if not results_str:
            return "Query executed successfully, but returned no rows."
            
        return "\n".join(results_str)
    except Exception as e:
        return f"Error executing query: {str(e)}"

if __name__ == "__main__":
    # Test (Dry run equivalent or safe query if environment is set)
    if PROJECT_ID and INSTANCE_ID and DATABASE_ID:
        print(f"Testing connectivity to {PROJECT_ID}/{INSTANCE_ID}/{DATABASE_ID}")
        # print(execute_spanner_query("SELECT 1"))
    else:
        print("Environment variables not set for testing.")
