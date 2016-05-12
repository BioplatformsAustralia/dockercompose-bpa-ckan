FROM muccg/python-base:debian8-2.7
MAINTAINER https://github.com/muccg/bpa-ckan-docker

#At build time changing these args allow us to use a local devpi mirror
# Unchanged, these defaults allow pip to behave as noremal
ARG ARG_PIP_OPTS="--no-cache-dir"
ARG ARG_PIP_INDEX_URL="https://pypi.python.org/simple"
ARG ARG_PIP_TRUSTED_HOST="127.0.0.1"

ENV PROJECT_NAME ckan
ENV CKAN_HOME $VIRTUAL_ENV
ENV DATAPUSHER_VERSION 0.0.8
ENV DEPLOYMENT prod
ENV PRODUCTION 1
ENV DEBUG 0
ENV STATIC_ROOT /data/static
ENV WRITABLE_DIRECTORY /data/scratch
ENV MEDIA_ROOT /data/static/media
ENV LOG_DIRECTORY /data/log

RUN env | sort

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  libpcre3 \
  libgeos-c1 \
  libpq5 \
  libxml2 \
  libpcre3-dev \
  libpq-dev \
  libssl-dev \
  libyaml-dev \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /etc/ckan /var/www/storage && \
    chown -R www-data:www-data /var/www

RUN NO_PROXY=${ARG_PIP_TRUSTED_HOST} pip ${ARG_PIP_OPTS} --trusted-host ${ARG_PIP_TRUSTED_HOST} install -i ${ARG_PIP_INDEX_URL} --upgrade pip==8.1.2

# http://docs.ckan.org/en/latest/maintaining/installing/install-from-source.html
COPY requirements.txt /etc/ckan/requirements.txt
RUN NO_PROXY=${ARG_PIP_TRUSTED_HOST} pip ${ARG_PIP_OPTS} --trusted-host ${ARG_PIP_TRUSTED_HOST} install -i ${ARG_PIP_INDEX_URL} --upgrade -r /etc/ckan/requirements.txt

RUN curl -o /etc/ckan/ckan-requirements.txt https://raw.githubusercontent.com/ckan/ckan/ckan-2.5.2/requirements.txt \
  && NO_PROXY=${ARG_PIP_TRUSTED_HOST} pip ${ARG_PIP_OPTS} --trusted-host ${ARG_PIP_TRUSTED_HOST} install -i ${ARG_PIP_INDEX_URL} --upgrade -r /etc/ckan/ckan-requirements.txt

COPY etc/ckan /etc/ckan/
COPY etc/uwsgi /etc/uwsgi/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN curl -o /etc/ckan/default/who.ini https://raw.githubusercontent.com/ckan/ckan/ckan-2.5.2/ckan/config/who.ini

EXPOSE 9100 9101
VOLUME ["/var/www/storage"]

# entrypoint shell script that by default starts uwsgi
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["uwsgi"]
