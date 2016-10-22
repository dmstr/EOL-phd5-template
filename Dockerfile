FROM dmstr/phd5-app:5.0.0-beta5

# Additional packages, see also `docker-compose.dev.yml` for host-volumes
#COPY ./composer.* /app/
#RUN composer install --prefer-dist

# Application environment & PHP configuration
#ENV APP_CONFIG_FILE=/app/src/modules/config.php \
#    APP_NAME=planck-myapp \
#    APP_TITLE="MyPlanck" \
#    APP_LANGUAGES=de,ru,en

COPY ./src /app/src