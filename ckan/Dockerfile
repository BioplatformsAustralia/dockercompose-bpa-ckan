FROM muccg/python-base:debian8-2.7
MAINTAINER https://github.com/muccg/bpa-ckan-docker

ENV PROJECT_NAME ckan
ENV PROJECT_SOURCE https://github.com/ckan/ckan.git
ENV CKAN_TAG=ckan-2.5.2
ENV CKAN_HOME $VIRTUAL_ENV
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
  git \
  build-essential \
  libpcre3-dev \
  libpq-dev \
  libssl-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone --branch=$CKAN_TAG --depth 1 https://github.com/ckan/ckan                       /project/ckan/
RUN git clone --branch=stable    --depth 1 https://github.com/ckan/datapusher/                /project/datapusher/
RUN git clone --branch=master    --depth 1 https://github.com/ckan/ckan-service-provider/     /project/ckan-service-provider/
RUN git clone --branch=master    --depth 1 https://github.com/ckan/ckanapi/                   /project/ckanapi/

RUN mkdir -p /project /var/www/storage && \
    chown -R www-data:www-data /var/www

RUN $CKAN_HOME/bin/pip install -e /project/ckan-service-provider
RUN $CKAN_HOME/bin/pip install -r /project/ckan/requirements.txt
RUN $CKAN_HOME/bin/pip install -e /project/ckan
RUN $CKAN_HOME/bin/pip install -e /project/ckanapi
RUN $CKAN_HOME/bin/pip install -r /project/datapusher/requirements.txt

ENTRYPOINT ["/bin/sh"]
