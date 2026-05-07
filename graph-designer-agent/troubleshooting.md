# Troubleshooting Guide: Graph Designer AI (Kùzu Version)

## Common Issues & Solutions

### 1. Kùzu Database Lock Error
- **Error**: `RuntimeError: Database is already open or locked.`
- **Solution**: Kùzu allows only one write connection at a time. Ensure that no other processes (or an improperly closed previous agent session) are holding a lock on the `./kuzu_db` directory. Restarting the agent usually resolves this. If persistent, delete the `./kuzu_db` folder to start fresh.

### 2. DDL Syntax Error (Cypher)
- **Error**: `Parser exception: Unrecognized syntax...`
- **Solution**: Kùzu uses specific Cypher extensions for DDL:
  - Node: `CREATE NODE TABLE NodeName (id STRING, prop INT64, PRIMARY KEY (id))`
  - Rel: `CREATE REL TABLE RelName (FROM NodeNameA TO NodeNameB)`
  Make sure the LLM is not generating Spanner-specific SQL (like `CREATE PROPERTY GRAPH`).

### 3. ADK Tool Not Found
- **Error**: `Tool 'sub_agents.kuzu_deployer.tools.kuzu_client.deploy_kuzu_ddl' not found.`
- **Solution**: 
  - Ensure all directories have `__init__.py` files.
  - Check if the FQN in `root_agent.yaml` matches the actual file path and function name.
  - Run the agent from the project root directory.

## Debugging Tips
- Check the terminal output where `adk web` is running for detailed logs.
- You can manually inspect the Kùzu database by writing a simple python script importing `kuzu` and connecting to `./kuzu_db`.
