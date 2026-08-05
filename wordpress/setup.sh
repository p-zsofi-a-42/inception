#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then

    # create wp-config.php
    # use DB_HOST, DB_NAME, DB_USER, DB_PASSWORD

fi

#??
exec php-fpm -F