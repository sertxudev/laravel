### BASE: things required for all - dev, ci, prod.
# Use the serversideup/php:8.4-fpm-nginx image as the base image.
FROM serversideup/php:8.4-fpm-nginx as base

USER root
RUN install-php-extensions intl bcmath

### BUILD: things required for dev & ci.
FROM base AS build

RUN apk add --no-cache --virtual .build-deps g++ make \
    && apk add --no-cache nodejs npm python3 \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && apk del .build-deps

### CI: specific to ci (if any)
FROM build AS ci


USER www-data

### DEV: specific to local (if any)
FROM build AS dev

USER www-data

### PROD - for deployment
FROM base AS prod

# SQLite does not support isolation
ENV SSL_MODE="off" \
    PHP_OPCACHE_ENABLE="1" \
    AUTORUN_ENABLED="true" \
    AUTORUN_LARAVEL_MIGRATION_ISOLATION="false"

USER www-data
