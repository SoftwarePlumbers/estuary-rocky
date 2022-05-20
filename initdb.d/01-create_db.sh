#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER estuary WITH PASSWORD 'swallow99';
	CREATE DATABASE estuary;
	GRANT ALL PRIVILEGES ON DATABASE estuary TO estuary;
EOSQL