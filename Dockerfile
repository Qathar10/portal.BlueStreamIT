# ... (previous lines unchanged)

# Copy Laravel app code
COPY . /var/www/html

# Ensure storage and cache directories exist before setting permissions
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
