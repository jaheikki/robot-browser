*** Settings ***
Library    DatabaseLibrary

*** Variables ***
${DBNAME}        postgres
${DBUSER}        postgres
#in project this is secret that must come from ENV variable:
${DBPASSWORD}    mysecretpassword 
${DBHOST}        localhost
#for running test in Docker container and the Postgres DB is running in host machine:
# ${DBHOST}        host.docker.internal 
${DBPORT}        5432

*** Test Cases ***
Connect To Database
    [Documentation]    Test connecting to the PostgreSQL database
    Connect To Database Using Custom Params    psycopg2    ${DBNAME}    ${DBUSER}    ${DBPASSWORD}    ${DBHOST}    ${DBPORT}
    @{tables}=    Query    SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname = 'public';
    Log Many    @{tables}
    Disconnect From Database

Create And Insert Data
    [Documentation]    Create a table and insert data
    Connect To Database Using Custom Params    psycopg2    ${DBNAME}    ${DBUSER}    ${DBPASSWORD}    ${DBHOST}    ${DBPORT}
    
    # Create table if not exists
    Execute Sql String    CREATE TABLE IF NOT EXISTS employees (id SERIAL PRIMARY KEY, name VARCHAR(100), role VARCHAR(50));
    
    # Insert data
    Execute Sql String    INSERT INTO employees (name, role) VALUES ('John Doe', 'Engineer');
    Execute Sql String    INSERT INTO employees (name, role) VALUES ('Jane Smith', 'Manager');
    
    # Query the data
    @{employees}=    Query    SELECT * FROM employees;
    Log Many    @{employees}
    
    Disconnect From Database

*** Keywords ***
Connect To Database Using Custom Params
    [Arguments]    ${db_module}    ${db_name}    ${db_user}    ${db_password}    ${db_host}    ${db_port}
    Connect To Database    ${db_module}    ${db_name}    ${db_user}    ${db_password}    ${db_host}    ${db_port}