FROM dmstr/phd5-app:5.2.0-rc4-debian
ARG BUILD_NO_INSTALL

# Environment default settings for application image, Note: These settings can NOT be changed in local override files like `project/config/local.env`
ENV APP_CONFIG_FILE=/app/project/config/project.php

# Additional packages, see also `docker-compose.dev.yml` for host-volumes
COPY ./composer.* /app/
# Composer installation (skipped on first build in dist-upgrade)
RUN if [ -z "$BUILD_NO_INSTALL" ]; then \
        composer install --no-dev --prefer-dist --optimize-autoloader && \
        composer clear-cache; \
    fi

COPY ./project /app/project
