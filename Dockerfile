FROM phusion/baseimage:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update

RUN apt-get -y install software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get -y --reinstall install nginx

RUN apt-get -y --reinstall install php7.0

# Install php7.0-fpm with needed extensions
RUN apt-get -y --reinstall install php7.0-fpm
RUN apt-get -y --reinstall install php7.0-cli
RUN apt-get -y --reinstall install php7.0-common
RUN apt-get -y --reinstall install php7.0-json
RUN apt-get -y --reinstall install php7.0-opcache
#RUN apt-get -y --reinstall install php7.0-mysql
RUN apt-get -y --reinstall install php7.0-phpdbg
RUN apt-get -y --reinstall install php7.0-mbstring
#RUN apt-get -y --reinstall install php7.0-gd
#RUN apt-get -y --reinstall install php7.0-imap
#RUN apt-get -y --reinstall install php7.0-ldap
#RUN apt-get -y --reinstall install php7.0-pgsql
#RUN apt-get -y --reinstall install php7.0-pspell
#RUN apt-get -y --reinstall install php7.0-recode
#RUN apt-get -y --reinstall install php7.0-tidy
RUN apt-get -y --reinstall install php7.0-dev
#RUN apt-get -y --reinstall install php7.0-intl
#RUN apt-get -y --reinstall install php7.0-gd
RUN apt-get -y --reinstall install php7.0-curl
#RUN apt-get -y --reinstall install php7.0-zip
RUN apt-get -y --reinstall install php7.0-xml

# Install redis
#RUN apt-get update && apt-get -y --force-yes install redis-server && service redis-server stop

# PHP INI
#COPY docker/php.ini /usr/local/etc/php/php.ini

# Install git
RUN apt-get -y --force-yes install git

# Install composer for PHP dependencies
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y --force-yes build-essential nodejs
RUN npm install -g bower gulp-cli

# Xdebug
RUN pecl install xdebug-2.4.0
COPY docker/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Copy this repo into place.
ADD ./valkyrja /var/www/site

# Add an sh file to sync
COPY ./docker/sync.sh /var/www/sync.sh
RUN chmod 755 /var/www/sync.sh

RUN rm -Rf /var/www/html
RUN chown -R www-data:www-data /var/www/site

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Update the default nginx config
COPY docker/conf/site.conf /etc/nginx/sites-enabled/default

RUN service php7.0-fpm start

RUN service nginx restart
