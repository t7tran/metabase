SELECT 'CREATE DATABASE metabase' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'metabase')\gexec

DO
$do$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE  rolname = 'metabase') THEN
        CREATE ROLE metabase LOGIN PASSWORD 'metabase';
    END IF;
END
$do$;

REVOKE CONNECT, CREATE ON DATABASE metabase FROM PUBLIC;
GRANT CONNECT, CREATE ON DATABASE metabase TO metabase;

\c metabase
GRANT CREATE ON SCHEMA public TO metabase;
