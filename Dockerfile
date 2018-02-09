FROM dmstr/phd5-app:5.1.0-rc7-debian

# Environment default settings for application image, Note: These settings can NOT be changed in local override files like `project/config/local.env`
ENV APP_CONFIG_FILE=/app/project/config/project.php

# Additional packages, see also `docker-compose.dev.yml` for host-volumes
COPY ./composer.* /app/
RUN composer install -v --prefer-dist --optimize-autoloader \
 && composer clear-cache

COPY ./project /app/project
