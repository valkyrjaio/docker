#!/bin/bash

docker exec valkyrja_docker service php7.1-fpm start
docker exec valkyrja_docker service nginx restart

#docker exec valkyrja_docker ./var/www/sync-site.sh
#docker exec valkyrja_docker ./var/www/sync.sh
