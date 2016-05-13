# CKAN environment operating under docker

Under active development, not yet for production use.


Status:

 - db init, bit clumsy atm, this will improve
 - fire up docker stack using docker-compose, then:
   (from within a clone of the ckan source, top level dir)
   export CKAN_SITE_URL=https://localhost:8443/app/
   export CKAN_SQLALCHEMY_URL=postgres://ckanapp:ckanapp@localhost:32768/ckan
   export CKAN_SOLR_URL=http://localhost:8983/solr/ckan
   ln -s ckan/config/deployment.ini_tmpl development.ini
   paster db init

   (note the db port above is dynamic, so that will not work as is)
