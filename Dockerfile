FROM dmstr/phd5-app:5.0.0-beta38

# Additional packages, see also `docker-compose.dev.yml` for host-volumes
COPY ./composer.* /app/
RUN composer install -v --prefer-dist \
 && composer clear-cache

COPY ./src /app/src