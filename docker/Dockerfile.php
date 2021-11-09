FROM debian:buster-slim
LABEL author="Carl Mai"

EXPOSE 9000

RUN apt-get update &&\
        apt-get install -y --no-install-recommends\
        php7.3-fpm \
        php7.3-bcmath php7.3-curl php7.3-gd \
        php7.3-json php7.3-mbstring php7.3-mysql \
        php7.3-opcache php7.3-phpdbg php7.3-readline php7.3-xml php7.3-zip && \
        rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^listen.*/listen = 9000/' /etc/php/7.3/fpm/pool.d/www.conf && \
        mkdir -p /run/php

WORKDIR /var/www/

CMD [ "php-fpm7.3", "-F" ]
