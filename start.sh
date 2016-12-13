#!/bin/bash

docker exec app_valkyrja_1 service php7.1-fpm start
docker exec app_valkyrja_1 service nginx restart

docker exec app_valkyrja_1 ./var/www/sync.sh