FROM dmstr/phd5-app:5.5.0-beta3
ARG BUILD_NO_INSTALL

# Project packages
ENV COMPOSER=/app/project/composer.json

# Environment default settings for application image, Note: These settings can NOT be changed in local override files like `project/config/local.env`
ENV APP_CONFIG_FILE=/app/project/config/main.php

WORKDIR /app/project

# Additional packages
COPY ./project/composer.* /app/project/
# Composer installation (skipped on first build in dist-upgrade)
RUN if [ -z "$BUILD_NO_INSTALL" ]; then \
        composer install --no-dev --prefer-dist --optimize-autoloader && \
        composer clear-cache; \
    fi

COPY ./project /app/project
