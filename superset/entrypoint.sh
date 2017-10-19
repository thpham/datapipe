#!/bin/bash
set -e

function start () {
  # if this is the first run, or we ask for a re-init
  if [ "$1" = "init" ] || [ ! -f "_initialized" ] ; then
    sleep 5

    # Create an admin user
    fabmanager create-admin --app superset \
    --username admin --firstname admin --lastname user \
    --email admin@domain.tld --password 1234

    # Initialize the database
    superset db upgrade

    # Create default roles and permissions
    superset init

    touch _initialized
    if [ "$1" = "init" ]; then
      exit 0
    fi
  fi
  superset runserver
}



case "$1" in
    "start")
        echo "Initialize Superset"
        start
        ;;
    *)
        echo "Start Superset"
        exec dockerize -wait tcp://${REDIS_HOST:-'redis'}:${REDIS_PORT:-6379} \
               -wait tcp://${POSTGRES_HOST:-'postgres'}:${POSTGRES_PORT:-5432} -timeout 100s \
             entrypoint.sh start
        ;;
esac