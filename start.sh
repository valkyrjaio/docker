#!/bin/bash

docker exec app_valkyrja_1 service php7.0-fpm start
docker exec app_valkyrja_1 service nginx restart
