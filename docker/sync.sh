#!/bin/bash

rm -rf /var/www/site
cp -r /var/www/sync /var/www/site
chown -R www-data:www-data /var/www/site
