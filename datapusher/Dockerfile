FROM muccg/python-base:debian8-2.7
MAINTAINER https://github.com/muccg/bpa-ckan-docker

#At build time changing these args allow us to use a local devpi mirror
# Unchanged, these defaults allow pip to behave as noremal
ARG ARG_PIP_OPTS="--no-cache-dir"
ARG ARG_PIP_INDEX_URL="https://pypi.python.org/simple"
ARG ARG_PIP_TRUSTED_HOST="127.0.0.1"

ENV PROJECT_NAME datapusher
ENV DATAPUSHER_VERSION 0.0.8

RUN env | sort

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  libpq5 \
  libpq-dev \
  lib32z1-dev \
  libxml2-dev \
  libxslt1-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /etc/datapusher

COPY etc/datapusher /etc/datapusher/
COPY etc/uwsgi /etc/uwsgi/

# Recent deps are not in pypi, install from github
RUN NO_PROXY=${ARG_PIP_TRUSTED_HOST} pip ${ARG_PIP_OPTS} --trusted-host ${ARG_PIP_TRUSTED_HOST} install -i ${ARG_PIP_INDEX_URL} --upgrade -r /etc/datapusher/requirements.txt

RUN curl -o /etc/datapusher/datapusher-requirements.txt https://raw.githubusercontent.com/ckan/datapusher/${DATAPUSHER_VERSION}/requirements.txt \
  && NO_PROXY=${ARG_PIP_TRUSTED_HOST} pip ${ARG_PIP_OPTS} --trusted-host ${ARG_PIP_TRUSTED_HOST} install -i ${ARG_PIP_INDEX_URL} --upgrade -r /etc/datapusher/datapusher-requirements.txt

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 9100 9101

# entrypoint shell script that by default starts uwsgi
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["uwsgi"]
