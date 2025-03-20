import duckdb

# Connect to a DuckDB database (can be in-memory or a file-based database)
conn = duckdb.connect()

# Open and read the SQL script file
# 'QueryData.sql' should contain SQL commands to be executed
with open('QueryData.sql', 'r') as f:
    sql_script = f.read()

# Split the SQL script into individual commands using the semicolon delimiter
# This allows executing multi-command SQL scripts step-by-step
sql_commands = sql_script.split(';')

# Loop through each SQL command and execute them one by one
for command in sql_commands:
    command = command.strip()  # Clean up the command by removing extra spaces or newlines
    if command:  # Only proceed if the command is not empty
        try:
            # Check if the command is a schema inspection query (e.g., reading Parquet metadata)
            if "SELECT * FROM read_parquet" in command:  
                print("\n[INFO] Running Schema Inspection Query...")
                # Execute the schema inspection query and fetch its result
                result = conn.execute(command).fetchall()
                print("[INFO] Schema Inspection Result:")
                # Print the results of the schema inspection query, if any
                if result:
                    for row in result:
                        print(row)
                else:
                    print("[INFO] No data found in the schema inspection query.")
            else:
                # Execute non-schema inspection SQL commands (e.g., DDL or DML commands)
                conn.execute(command)
                print(f"[INFO] Successfully executed: {command[:50]}...")  # Log success for the command
        except Exception as e:
            # Catch and log errors encountered while executing a command
            print(f"[ERROR] Error executing command: {command[:50]}...")  # Log the first 50 characters of the command
            print(f"[ERROR] {e}")  # Provide detailed error information
