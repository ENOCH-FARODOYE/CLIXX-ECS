#!/bin/bash

# Wait for database
echo "Waiting for database connection..."
until php -r "mysqli_connect('${DB_HOST}', '${DB_USER}', '${DB_PASSWORD}', '${DB_NAME}');" 2>/dev/null; do
    echo "Database not ready, waiting..."
    sleep 2
done
echo "Database connected!"

# Add HTTPS header trust to wp-config.php if not already present
if ! grep -q "HTTP_X_FORWARDED_PROTO" /var/www/html/wp-config.php; then
    echo "Adding HTTPS header trust to wp-config.php..."
    sed -i '2i\\n// Trust ALB headers for HTTPS\nif (isset($_SERVER["HTTP_X_FORWARDED_PROTO"]) && $_SERVER["HTTP_X_FORWARDED_PROTO"] === "https") {\n    $_SERVER["HTTPS"] = "on";\n}' /var/www/html/wp-config.php
fi

# Update WordPress URLs to HTTPS
echo "Updating WordPress URLs to HTTPS..."
php -r "\$conn = mysqli_connect('${DB_HOST}', '${DB_USER}', '${DB_PASSWORD}', '${DB_NAME}'); mysqli_query(\$conn, \"UPDATE wp_options SET option_value = 'https://ecs.enoch-stack.com' WHERE option_name IN ('siteurl', 'home')\"); mysqli_close(\$conn);"

echo "Starting Apache..."
exec apache2-foreground
