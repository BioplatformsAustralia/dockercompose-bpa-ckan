#!/bin/bash


# wait for a given host:port to become available
#
# $1 host
# $2 port
function dockerwait {
    while ! exec 6<>/dev/tcp/$1/$2; do
        echo "$(date) - waiting to connect $1 $2"
        sleep 5
    done
    echo "$(date) - connected to $1 $2"

    exec 6>&-
    exec 6<&-
}


# wait for services to become available
# this prevents race conditions using fig
function wait_for_services {
    if [[ "$WAIT_FOR_DB" ]] ; then
        dockerwait $DBSERVER $DBPORT
    fi
    if [[ "$WAIT_FOR_HOST_PORT" ]]; then
        dockerwait $DOCKER_ROUTE $WAIT_FOR_HOST_PORT
    fi
}


function defaults {
    : ${DATAPUSHER_DEBUG:="True"}
    : ${DATAPUSHER_SECRET_KEY:="secret_key"}
    : ${DATAPUSHER_USERNAME:="datapusher"}
    : ${DATAPUSHER_PASSWORD:=${DATAPUSHER_USERNAME}}
    : ${DBSERVER:="db"}
    : ${DBPORT:="5432"}
    : ${DBUSER:="webapp"}
    : ${DBNAME:="${DBUSER}"}
    : ${DBPASS:="${DBUSER}"}
    : ${DATAPUSHER_SQLALCHEMY_DATABASE_URI:="postgres://${DBUSER}:${DBPASS}@${DBSERVER}/${DBNAME}"}
    : ${DATAPUSHER_HOST:="0.0.0.0"}
    : ${DATAPUSHER_PORT:="8800"}
    : ${DATAPUSHER_FROM_EMAIL:="server-error@example.com"}
    : ${DATAPUSHER_ADMINS:="yourname@example.com"}
    : ${DATAPUSHER_LOG_FILE:="/tmp/ckan_service.log"}

    : ${DOCKER_ROUTE:=$(/sbin/ip route|awk '/default/ { print $3 }')}

    export DBSERVER DBPORT DBUSER DBNAME DBPASS DOCKER_ROUTE
    export DATAPUSHER_DEBUG DATAPUSHER_SECRET_KEY DATAPUSHER_USERNAME DATAPUSHER_PASSWORD DATAPUSHER_SQLALCHEMY_DATABASE_URI DATAPUSHER_HOST DATAPUSHER_PORT DATAPUSHER_FROM_EMAIL DATAPUSHER_ADMINS DATAPUSHER_LOG_FILE
}


trap exit SIGHUP SIGINT SIGTERM
defaults
env | grep -iv PASS | sort
wait_for_services

# uwsgi entrypoint
if [ "$1" = 'uwsgi' ]; then
    echo "[Run] Starting uwsgi"

    : ${UWSGI_OPTS="/etc/uwsgi/uwsgi.ini"}
    echo "UWSGI_OPTS is ${UWSGI_OPTS}"

    exec uwsgi --die-on-term --ini ${UWSGI_OPTS}
fi

echo "[RUN]: Builtin command not provided [uwsgi]"
echo "[RUN]: $@"

exec "$@"
