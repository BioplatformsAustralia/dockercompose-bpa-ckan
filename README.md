# CKAN environment operating under docker

Under active development, not yet for production use.


Status:

 - db init, bit clumsy atm, this will improve
 - fire up docker stack using docker-compose, then:
 - (from within a clone of the ckan source, top level dir)
 - set up your environment:

     dstore_port=$(docker port bpackandocker_datastore_1 5432 | sed s/'.*:'//)
     db_port=$(docker port bpackandocker_db_1 5432 | sed s/'.*:'//)
     export CKAN_SITE_URL=https://localhost:8443/app/
     export CKAN_SQLALCHEMY_URL=postgres://ckan:ckan@localhost:"$db_port"/ckan
     export CKAN_SOLR_URL=http://localhost:8983/solr/ckan
     export CKAN_DATASTORE_WRITE_URL=postgres://datastore:datastore@localhost:"$dstore_port"/datastore
     export CKAN_DATASTORE_READ_URL=postgres://readonly:readonly@localhost:"$dstore_port"/datastore

 - checkout the correct CKAN tag, eg. git checkout ckan-2.5.2
 - ln -s ckan/config/deployment.ini_tmpl development.ini
 - paster db init
 - SCRIPT_NAME not being respected, configured prefix middleware instead
 - how to add readonly user to datastore postgresql
   - postgres=# create user readonly with password 'readonly';
 - paster datastore set-permissions
 - paster sysadmin add admin
 - set up spatial extension: http://docs.ckan.org/projects/ckanext-spatial/en/latest/install.html
