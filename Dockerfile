FROM phusion/baseimage:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get -y install software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update

RUN apt-get -y --reinstall --allow-unauthenticated install nginx

RUN apt-get -y --reinstall --allow-unauthenticated install php7.1

# Install php7.1-fpm with needed extensions
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-fpm
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-cli
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-common
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-json
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-opcache
#RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-mysql
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-phpdbg
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-mbstring
#RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-imap
#RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-ldap
#RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-pgsql
#RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-pspell
#RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-recode
#RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-tidy
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-dev
#RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-intl
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-gd
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-curl
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-zip
RUN apt-get -y --reinstall --allow-unauthenticated install php7.1-xml

# Install redis
#RUN apt-get update && apt-get -y install redis-server && service redis-server stop

# PHP INI
#COPY docker/php.ini /usr/local/etc/php/php.ini

# Install git
RUN apt-get -y install --allow-unauthenticated git

# Install composer for PHP dependencies
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y build-essential nodejs
RUN npm install -g bower gulp-cli

# Xdebug
RUN pecl install xdebug-2.4.0
COPY docker/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Update apt-get and download inotify tools
RUN apt-get update
RUN apt-get -y install inotify-tools

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update the default nginx config
COPY docker/conf/site.conf /etc/nginx/sites-enabled/default

# Copy this repo into place.
ADD ./valkyrja /var/www/site

# Add an sh file for sync
COPY ./docker/sync.sh /var/www/sync.sh
COPY ./docker/sync-site.sh /var/www/sync-site.sh
RUN chmod 755 /var/www/sync.sh
RUN chmod 755 /var/www/sync-site.sh

# 777 the storage directory for twig cache
RUN chmod -R 777 /var/www/site/storage

#RUN ln -sf /dev/stdout /var/log/nginx/access.log
#RUN ln -sf /dev/stderr /var/log/nginx/error.log
#RUN ln -sf /dev/stdout /var/log/php7.1-fpm.log