#
FROM nginx:1.23.3-alpine-slim
MAINTAINER https://github.com/BioplatformsAustralia

RUN rm -rf /etc/nginx
COPY . /etc/nginx
RUN mkdir -p /data && chown nginx:nginx /data

VOLUME /data

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
