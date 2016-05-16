# CKAN environment operating under docker

Under active development, not yet for production use.


Status:

 - db init, bit clumsy atm, this will improve
 - fire up docker stack using docker-compose, then:
 - (from within a clone of the ckan source, top level dir)
 - export CKAN_SITE_URL=https://localhost:8443/app/
 - export CKAN_SQLALCHEMY_URL=postgres://ckan:ckan@localhost:32768/ckan
 - export CKAN_SOLR_URL=http://localhost:8983/solr/ckan
 - ln -s ckan/config/deployment.ini_tmpl development.ini
 - paster db init
 - (note the db port above is dynamic, so that will not work as is)
 - SCRIPT_NAME not being respected, configured prefix middleware instead
 - how to add readonly user to datastore postgresql
   - postgres=# create user readonly with password 'readonly';
 - paster sysadmin add admin
