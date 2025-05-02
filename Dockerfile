# Use the serversideup/php:8.4-fpm-nginx image as the base image.
FROM serversideup/php:8.4-fpm-nginx

ENV SSL_MODE="off"
ENV PHP_OPCACHE_ENABLE=1
ENV AUTORUN_ENABLED=1

# Set the working directory to /var/www.
# WORKDIR /var/www/html

# Copy the application files to the container.
COPY --chown=www-data:www-data . /var/www/html

RUN cp .env.example .env

# Install PHP dependencies using Composer.
# Use --no-scripts to prevent Composer from running scripts during the install process.
# This is often safer in Dockerfiles, as it prevents potential issues with missing
# dependencies or environment configurations.  We'll run the necessary artisan
# commands (key:generate, migrate) explicitly later.
RUN composer install --no-scripts --no-interaction --prefer-dist

# Generate the application key.  We do this *before* optimizing the autoloader.
# If you have environment variables that affect key generation, set them
# with ENV before this line.
RUN php artisan key:generate --no-interaction

# Run database migrations.  This assumes your database is set up and
# accessible.  You might need to adjust the DB_* environment variables here
# or in your docker-compose.yml file.
RUN php artisan migrate --force --no-interaction

# Optimize the autoloader.  This can significantly improve performance in production.
# RUN php artisan optimize:clear
# RUN php artisan optimize

# Expose port 80 for the Nginx server.
# EXPOSE 8080

# The base image already configures Nginx and PHP-FPM, so we don't need to do that here.
# CMD ["php-fpm", "-F"] # Not needed, the base image handles this.

# Optional:  If you need to run any other commands, such as seeding the database,
# you can add them here.  For example:
# RUN php artisan db:seed --force
