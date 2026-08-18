#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then

    # create wp-config.php
    # use DB_HOST, DB_NAME, DB_USER, DB_PASSWORD

fi

#: Starting the php-fpm service
service php8.2-fpm start
#??
#exec php-fpm -F