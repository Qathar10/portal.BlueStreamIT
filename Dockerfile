FROM php:8.2-apache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory inside container
WORKDIR /var/www/html

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip \
    && docker-php-ext-install zip pdo pdo_mysql

# ✅ Copy Laravel app from correct subfolder
COPY teams.molah.sulvin.com/ /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set correct permissions
RUN mkdir -p storage bootstrap/cache && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 775 storage bootstrap/cache

EXPOSE 80

# Start Laravel server on container start
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
