#!/bin/bash

# Wait for database
until php -r "mysqli_connect('${DB_HOST}', '${DB_USER}', '${DB_PASSWORD}', '${DB_NAME}');" 2>/dev/null; do
    sleep 2
done

# Update WordPress URLs
php -r "\$conn = mysqli_connect('${DB_HOST}', '${DB_USER}', '${DB_PASSWORD}', '${DB_NAME}'); mysqli_query(\$conn, \"UPDATE wp_options SET option_value = 'http://ecs.enoch-stack.com' WHERE option_name IN ('siteurl', 'home')\"); mysqli_close(\$conn);"

# Start Apache
exec apache2-foreground
