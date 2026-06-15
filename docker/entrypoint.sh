#!/bin/bash
set -e

if [ ! -d /var/lib/postgresql/data/base ]; then
    mkdir -p /var/lib/postgresql/data
    chown postgres:postgres /var/lib/postgresql/data
    su postgres -c "initdb -D /var/lib/postgresql/data"
    su postgres -c "pg_ctl -D /var/lib/postgresql/data -l /tmp/pg.log start"
    su postgres -c "psql -c \"CREATE USER ${DB_USER:-postgres} WITH PASSWORD '${DB_PASSWORD:-postgres}' SUPERUSER;\""
    su postgres -c "createdb -O ${DB_USER:-postgres} ${DB_NAME:-nitr}"
    su postgres -c "pg_ctl -D /var/lib/postgresql/data stop"
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf