#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER druid;
    CREATE DATABASE druid;
    GRANT ALL PRIVILEGES ON DATABASE druid TO druid;
    ALTER USER druid WITH PASSWORD 'druid';

    CREATE USER superset;
    CREATE DATABASE superset;
    GRANT ALL PRIVILEGES ON DATABASE superset TO superset;
    ALTER USER superset WITH PASSWORD 'superset';
EOSQL