FROM serversideup/php:8.4-fpm-nginx-alpine

ENV SSL_MODE="off"
ENV PHP_OPCACHE_ENABLE=1

COPY . /var/www/html --chown=www-data:www-data

RUN cp /var/www/html/.env.example /var/www/html/.env

RUN touch /var/www/html/storage/logs/laravel.log && \
    composer update --no-progress --prefer-dist

RUN php artisan key:generate
