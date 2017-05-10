FROM dmstr/phd5-app:5.0.0-beta38

# set path to custom module(s) config
ENV APP_CONFIG_FILE=/app/src/modules/config.php

# Additional packages, see also `docker-compose.dev.yml` for host-volumes
COPY ./composer.* /app/
RUN composer install -v --prefer-dist \
 && composer clear-cache

COPY ./src /app/src
