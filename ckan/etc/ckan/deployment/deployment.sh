#!/bin/bash

. /docker-entrypoint.sh
set +e
. /env/bin/activate
cd /etc/ckan/deployment/ || exit 1
echo "** fixing up database permissions **"
python /etc/ckan/deployment/perms.py
echo "** db init"
paster --plugin=ckan db init
echo "** datastore permissions"
paster --plugin=ckan datastore set-permissions
echo "** create sysadmin"
paster --plugin=ckan sysadmin add admin
