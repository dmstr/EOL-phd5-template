FROM dmstr/phd5-app:5.1.0-rc2

# Environment settings for application image, Note: These settings can NOT be changed in local override files like `src/modules/local.env`
ENV APP_NAME=dev-planck \
    APP_TITLE=PlanckDEV \
    APP_LANGUAGES=en,de,ru \
    APP_CONFIG_FILE=/app/src/modules/config.php

# Additional packages, see also `docker-compose.dev.yml` for host-volumes
COPY ./composer.* /app/
RUN composer install -v --prefer-dist --optimize-autoloader \
 && composer clear-cache

COPY ./src /app/src
