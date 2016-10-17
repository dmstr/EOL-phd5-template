FROM dmstr/phd5-app

# Additional packages
#COPY ./composer.* /app/
#RUN composer install --prefer-dist

# Application environment configuration
#RUN cp src/app.env-dist src/app.env

# PHP configuration
ENV APP_CONFIG_FILE=/app/src/modules/config.php

COPY ./src /app/src