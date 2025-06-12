#!/usr/bin/env bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER readonly WITH PASSWORD 'readonly';
	GRANT ALL PRIVILEGES ON DATABASE datastore TO readonly;
EOSQL
