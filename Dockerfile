# Stage 1: Composer
FROM composer:2 AS composer

# Stage 2: Laravel app with Apache
FROM php:8.2-apache

RUN a2enmod rewrite

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Copy Composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copy only Laravel app folder
COPY teams.molah.sulvin.com/ /var/www/html

# Ensure storage & cache folders exist
RUN mkdir -p storage bootstrap/cache

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 storage bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]
