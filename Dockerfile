FROM bioplatformsaustralia/bpa-ckan:next_release
MAINTAINER https://github.com/bioplatformsaustralia/bpa-ckan-docker

# quick dev dockerfile for CKAN

USER root
ENV HOME /data
WORKDIR /data
