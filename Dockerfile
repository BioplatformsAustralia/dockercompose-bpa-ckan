FROM muccg/bpa-ckan:next_release
MAINTAINER https://github.com/muccg/bpa-ckan-docker

# quick dev dockerfile for CKAN

USER root
ENV HOME /data
WORKDIR /data
