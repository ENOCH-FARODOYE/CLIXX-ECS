FROM php:7.4-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql \
    && a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Clone CLIXX application
RUN git clone https://github.com/stackitgit/CliXX_Retail_Repository.git . \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Copy custom wp-config.php that uses environment variables
COPY wp-config.php /var/www/html/wp-config.php
RUN chown www-data:www-data /var/www/html/wp-config.php

# Apache configuration
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Create startup script that updates WordPress URLs then starts Apache
RUN printf '#!/bin/bash\n\
set -e\n\
echo "Waiting for database..."\n\
until php -r "mysqli_connect(getenv(\"DB_HOST\"), getenv(\"DB_USER\"), getenv(\"DB_PASSWORD\"), getenv(\"DB_NAME\"));" 2>/dev/null; do sleep 3; done\n\
echo "Updating WordPress URLs..."\n\
php -r "$c=mysqli_connect(getenv(\"DB_HOST\"),getenv(\"DB_USER\"),getenv(\"DB_PASSWORD\"),getenv(\"DB_NAME\"));mysqli_query($c,\"UPDATE wp_options SET option_value=getenv(\"WORDPRESS_URL\") WHERE option_name IN ('"'siteurl'"','"'home'"')\");mysqli_close($c);"\n\
echo "Starting Apache..."\n\
exec apache2-foreground\n' > /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/start.sh

EXPOSE 80

CMD ["/usr/local/bin/start.sh"]
