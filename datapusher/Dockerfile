FROM muccg/python-base:debian8-2.7
MAINTAINER https://github.com/muccg/bpa-ckan-docker

ENV PROJECT_NAME ckan
ENV PROJECT_SOURCE https://github.com/ckan/ckan.git
ENV DEPLOYMENT prod
ENV PRODUCTION 1
ENV DEBUG 0
ENV STATIC_ROOT /data/static
ENV WRITABLE_DIRECTORY /data/scratch
ENV MEDIA_ROOT /data/static/media
ENV LOG_DIRECTORY /data/log

RUN env | sort

RUN apt-get update && apt-get install -y --no-install-recommends \
  libpcre3 \
  libgeos-c1 \
  libpq5 \
  libxml2 \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/bin/sh"]
