# Stage 1: Install Composer
FROM composer:2 as composer

# Stage 2: Laravel app with Apache
FROM php:8.2-apache

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev zip \
    && docker-php-ext-install zip pdo pdo_mysql

# Copy Composer from stage 1
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Copy Laravel app files
COPY . /var/www/html

# Make sure these folders exist before setting permissions
RUN mkdir -p storage bootstrap/cache

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 storage bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Laravel
CMD ["apache2-foreground"]
