FROM alpine:latest
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

LABEL caddy_version="0.8.1" architecture="amd64"

RUN apk add --update openssh-client git tar php-fpm ssmtp

# essential php libs
RUN apk add php-curl php-gd php-zip php-iconv php-sqlite3 php-mysql php-mysqli php-json

# allow environment variable access.
RUN echo "clear_env = no" >> /etc/php/php-fpm.conf

RUN mkdir /caddysrc \
&& curl -sL -o /caddysrc/caddy_linux_amd64.tar.gz "http://caddyserver.com/download/build?os=linux&arch=amd64&features=git" \
&& tar -xf /caddysrc/caddy_linux_amd64.tar.gz -C /caddysrc \
&& mv /caddysrc/caddy /usr/bin/caddy \
&& chmod 755 /usr/bin/caddy \
&& rm -rf /caddysrc

ADD Caddyfile /etc/Caddyfile

RUN mkdir /srv \
&& printf "<?php phpinfo(); ?>" > /srv/index.php

EXPOSE 2015
EXPOSE 443
EXPOSE 80

WORKDIR /srv

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
