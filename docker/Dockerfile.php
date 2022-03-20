FROM php:7.4-fpm-buster
LABEL author="Carl Mai"

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        ca-certificates \
        msmtp mailutils \
    && docker-php-ext-configure gd --with-freetype --with-jpeg
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libonig-dev
RUN docker-php-ext-install -j$(nproc) gd bcmath curl
RUN docker-php-ext-install -j$(nproc) mbstring
RUN apt-get install -y libzip-dev
RUN docker-php-ext-install -j$(nproc) zip
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install -j$(nproc) xml
RUN docker-php-ext-install -j$(nproc) json
RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql

COPY php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY ./msmtprc /etc/msmtprc
RUN echo "sendmail_path=/usr/bin/msmtp -t" >> $PHP_INI_DIR/php.ini

CMD [ "php-fpm", "-F" ]
