FROM dmstr/phd5-app

# Additional packages
#COPY ./composer.* /app/
#RUN composer install --prefer-dist

ENV APP_CONFIG_FILE=/app/src/modules/config.php

COPY ./src /app/src