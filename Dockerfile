#FROM muccg/bpa-ckan:next_release
FROM muccg/bpa-ckan:ckan-upgrade-2.8.2
MAINTAINER https://github.com/muccg/bpa-ckan-docker

# quick dev dockerfile for CKAN

USER root
ENV HOME /data
WORKDIR /data
