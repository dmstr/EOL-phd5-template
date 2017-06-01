FROM dmstr/phd5-app:5.0.0-beta38

ENV APP_NAME=dev-planck \
    APP_TITLE=PlanckDEV \
    APP_LANGUAGES=en,de,ru

# Additional packages, see also `docker-compose.dev.yml` for host-volumes
COPY ./composer.* /app/
RUN composer install -v --prefer-dist --optimize-autoloader \
 && composer clear-cache

COPY ./src /app/src