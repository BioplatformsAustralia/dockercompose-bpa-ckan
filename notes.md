# Quick notest on ckan and the current CCG workflow

This repo contains the docker stack used for dev and prod.

Make sure the BPA CKAN secrets (available from lastpass) are in the environment:
```source bpa-ckan-aws-secrets```

Fire up docker stack using docker-compose, wait, until ckan is up and running, and then:

```
$ docker exec -it bpackandocker_ckan_1 /bin/bash
# /etc/ckan/deployment/deployment.sh
```

The muccg/docker-bpa-ckan repo contains our ckan container setup:
```
.
├── develop.sh
├── docker-compose.yml
├── docker-entrypoint.sh
├── Dockerfile
├── etc
│   ├── ckan
│   │   ├── default
│   │   │   └── ckan.ini.in
│   │   ├── deployment
│   │   │   ├── deployment.sh
│   │   │   ├── development.ini
│   │   │   └── perms.py
│   │   └── requirements.txt
│   └── uwsgi
│       ├── uwsgi.ini
│       └── vassals
│           └── socket-9100.ini
├── Jenkinsfile
├── lib.sh
├── LICENSE
└── README.md

```

Register new ckan plugins/extentions in /etc/requirements, and rebuild the
container using develop.sh

This site list ckan extentions http://extensions.ckan.org/

The current list of ckan related repos CCG has forked are listed below.
Repos are forked either because of needed bugfixes or enhancements or to version lock
plugins that do not have a release regime (everything just lives in master).
Its generally better to use a pypi artifact it one exist for a plugin, some do.

https://github.com/muccg/docker-bpa-ckan
https://github.com/muccg/ckanext-bpatheme
https://github.com/muccg/ckan
https://github.com/muccg/ckanext-s3filestore
https://github.com/muccg/dockercompose-bpa-ckan
https://github.com/muccg/ckanapi
https://github.com/muccg/ckanext-spatial
https://github.com/muccg/ckanext-hierarchy
https://github.com/muccg/ckanext-pages
https://github.com/muccg/ckan-galleries
https://github.com/muccg/ckanext-scheming
https://github.com/muccg/ckan-docker

# Cool sites using ckan
https://data.gov.au/dataset
http://data.nhm.ac.uk/

