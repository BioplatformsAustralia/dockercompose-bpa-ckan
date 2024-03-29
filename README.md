# BPA CKAN environment operating under docker

This repo contains the docker stack used for dev, which is a simulated environment
using the same containers as in the production CKAN.

You'll need AWS credentials, and make yourself a temporary AWS bucket for development.
Use CCG credentials, not BPA credentials.

Make sure that `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_BUCKET_NAME` and
`AWS_STORAGE_PATH` are exported. The storage path is just a key prefix CKAN will
use when storing data, if you're sharing a bucket with other devs just use your
username.

Fire up docker stack using docker-compose, wait until ckan is up and running and then
complete the CKAN installation process (initial database migrations and SOLR setup):

```
$ docker exec -it bpackandocker_ckan_1 /bin/bash
# /etc/ckan/deployment/deployment.sh
```

The deployment script will ask you to create an admin user and set a password.

You're now up and running. Go to https://localhost:8443 and you should see the
CKAN front page. Log in, using the password you set, and click on "admin" at
the top right corner. In the sidebar you'll see your API key, note this as you
will need it to use the `bpa-ingest` script.

# Ingesting metadata & data 

We ingest metadata and data into CKAN using the `bpa-ingest` script. Grab it
from https://github.com/bioplatformsaustralia/bpa-ingest/ and install into a virtualenv (TODO - 
containerise this.)

```
$ virtualenv ./venv/
$ source ./venv/bin/activate
$ pip install -U -r requirements.txt
$ pip install -e .
```

Once the software is up, get it to set up a BioPlatforms Australia organisation
in your local installation:

```
$ bpa-ingest -u http://localhost:8080/ -k edf504a5-e96f-4903-bc0a-75c0057aa856 bootstrap 
2016-08-25 11:31:21,457 [DEBUG]  organization/cc5a6adb-1b6f-448b-8d4c-488d140da265: difference on k `description', we have `Bioplatforms Australia enables innovation and collaboration through investments in world class infrastructure and expertise.' vs ckan `'
2016-08-25 11:31:21,457 [DEBUG]  organization/cc5a6adb-1b6f-448b-8d4c-488d140da265: difference on k `display_name', we have `BioPlatforms Australia' vs ckan `bioplatforms-australia'
2016-08-25 11:31:21,457 [DEBUG]  organization/cc5a6adb-1b6f-448b-8d4c-488d140da265: difference on k `image_display_url', we have `http://www.bioplatforms.com/wp-content/uploads/BioplatformsAustralia.png' vs ckan `'
2016-08-25 11:31:21,458 [DEBUG]  organization/cc5a6adb-1b6f-448b-8d4c-488d140da265: difference on k `title', we have `BioPlatforms Australia' vs ckan `'
2016-08-25 11:31:21,458 [DEBUG]  organization/cc5a6adb-1b6f-448b-8d4c-488d140da265: difference on k `image_url', we have `http://www.bioplatforms.com/wp-content/uploads/BioplatformsAustralia.png' vs ckan `'
2016-08-25 11:31:21,704 [INFO ]  patched organization `bioplatforms-australia'
```

# Ingesting a project

Ingestion loads the metadata and data for a project into CKAN. Objects (CKAN packages and
resources) are created via the API. Data is sent via (very large) POST requests to CKAN's
API, which in turn streams that data into AWS S3 storage.

For local development, you won't want to ingest any of the large projects (it'll take far
too long.) Also note that the nginx container used in local dev is not tuned for large
streaming uploads, so you'll encounter timeouts if you try to upload large files.

All of that said, here's how you'd load GBR Amplicons into CKAN:

```
bpa-ingest -u http://localhost:8080/ -k edf504a5-e96f-4903-bc0a-75c0057aa856 gbr-amplicon /tmp/gbr
```

# Developing against ckan in local docker-compose environment

* Be aware that:
- usually you'll develop against 'next_release' git branch in sub-modules, but this overall local container can be committed against master.
- updates to any sub-modules, e.g., ckan, will require you to rebuild before developing against the updates
```
docker-compose build ckan
```

* You'll need a copy of an environment file (from one of the developers). Source this and then bring up the environment.
```
source </path/to/your/bpa.env>
docker-compose up
```

* You'll need a copy of data (from one of the developers) to ingest before running deployment.sh
```
docker-compose stop
docker cp </path/to/dumpfilename.dump> dockercompose-bpa-ckan_db_1:/var/lib/postgresql/data/
docker-compose up db
docker-compose exec db bash
# inside the postgres container
pg_restore -Fc -U ckan -d ckan < /var/lib/postgresql/data/dumpfilename.dump
exit
# outside the postgis container
docker-compose stop
docker-compose up
docker-compose exec ckan bash
# inside the CKAN container: fix permissions and so on
/etc/ckan/deployment/deployment.sh
# re-index SOLR database
/docker-entrypoint.sh paster --plugin=ckan search-index rebuild -c /etc/ckan/default/ckan.ini
```
NB: The reindex will take some time (so ensure it can run uninterrupted)

* Now go to https://localhost:8443 (and you should see the BPA page with the 'DATA PORTAL' text )

## Troubleshooting:
#### Running docker-compose up (after initalisation previously done), docker stack fails - no admin user.
- Upon bringing up stack again, you may find that the admin user no longer exists, which causes stack to fail.
So, after sourcing the env file and bringing up the container, you may have to run through the initial permissions step again:
```
docker-compose exec ckan bash
# inside the CKAN container: fix permissions and so on
/etc/ckan/deployment/deployment.sh 
```


# Migrating projects to CKAN

If you look at the `bpa-ingest` code, you'll see a Python module per project. The
code in `cli.py` calls into each submodule to get:

 - a group definition for the project
 - a list of Python dictionaries, describing each 'package'
 - a list of tuples, of a legacy archive URL and a python dictionary, describing
   each resource ('file')

To migrate a project, the process is fairly simple:

1. Port the metadata reading code from the `bpa-metadata` project into a submodule of
   `bpa-ingest`. Follow the pattern of the projects already ported across.
2. Add a new JSON data definition to our CKAN theme. Add this in the `ckanext-bpatheme`
   module, tag it and push.
3. Update the `docker-bpa-ckan` container, adding the JSON data definition to 
   `/etc/ckan/default/ckan.ini.in`, and rebuild.
4. Run up a stack with the new `docker-bpa-ckan` container, and give the ingest script
   a whirl.

The JSON definition is used by [ckanext-scheming](https://github.com/ckan/ckanext-scheming),
see the docs for scheming for more info.

CKAN will only store metadata which has a valid definition in a JSON file. If you run
the ingest script several times, and see it continually trying to set certain JSON
keys, those almost certainly are missing from the data definition.

# Notes on our CKAN environment

We've forked a number of upstream CKAN modules. Most changes have been upstreamed, or
a PR has been put in.

A large number of the forks were made because upstream had no tags (other than 'master'),
and were made so that we could reproduce our environment.

- https://github.com/bioplatformsaustralia/ckanapi - changed to use requests_toolbelt to stream large POST
  requests, rather than building the whole request in-memory. needs to be tidied up and
  sent to upstream as a PR.
- https://github.com/bioplatformsaustralia/ckan - local change to preserve case on filenames, forked from the
  2.5.2 tag. not sure if this can be accepted upstream
- https://github.com/bioplatformsaustralia/ckanext-bpatheme - our theme. this isn't of much interest to anyone
  else. forked from the WA state government theme.
- https://github.com/bioplatformsaustralia/ckanext-bpaschema - our schemas. this isn't of much interest to anyone
  else.
- https://github.com/bioplatformsaustralia/ckanext-s3filestore - changed to use boto3, and stream large file
  uploads. PR is in and awaiting upstream feedback
- https://github.com/bioplatformsaustralia/ckanext-ytp-request - heavily forked to add membership request
  management to the site

Simply tagged for tracking of changes

- https://github.com/bioplatformsaustralia/ckanext-spatial
- https://github.com/bioplatformsaustralia/ckanext-hierarchy
- https://github.com/bioplatformsaustralia/ckanext-pages
- https://github.com/bioplatformsaustralia/ckan-galleries
- https://github.com/bioplatformsaustralia/ckanext-scheming

# Upgrading SOLR from v5 to v8

If you were previously using this development environment with the older BPA 
SOLR container with spatial support, you'll need to remove the older named
volume used for storing the SOLR cache

`docker volume ls`

The output should include the old volume, with something similar to:

        DRIVER    VOLUME NAME
        ...
        local     dockercompose-bpa-ckan_solr28
        ...

Run the following command to remove

`docker volume rm dockercompose-bpa-ckan_solr28`

Run the following command to rebuild the SOLR indexes once you've brought
the docker-compose up

`docker exec -it dockercompose-bpa-ckan_ckan /bin/bash`

then

`/docker-entrypoint.sh ckan -c /etc/ckan/default/ckan.ini search-index rebuild -r`

# Other organisations using CKAN

Pretty much every major government, and almost every Australian state government.

- https://data.gov.au/
- http://catalogue.beta.data.wa.gov.au/
- http://data.nhm.ac.uk/
- https://data.gov/
- http://open.canada.ca/en
