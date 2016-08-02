# BPA CKAN environment operating under docker

Under active development, not yet for production use.

Status:
 - Make sure the BPA CKAN secrets (available from lastpass) are in the environment.
 - fire up docker stack using docker-compose, wait, until ckan is up and running, and then:

    docker run -it bpackandocker_ckan_1 /bin/bash
    /etc/ckan/deployment/deployment.sh

