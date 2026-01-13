FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip unzip git curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql \
    && a2enmod rewrite

WORKDIR /var/www/html

RUN git clone https://github.com/stackitgit/CliXX_Retail_Repository.git . \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

COPY wp-config.php /var/www/html/wp-config.php
COPY entrypoint.sh /usr/local/bin/
RUN chown www-data:www-data /var/www/html/wp-config.php \
    && chmod +x /usr/local/bin/entrypoint.sh

RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
