#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then
	cat > /var/www/html/wp-config.php <<EOF
<?php
/** Telling wordpress how to connect to the db */

define('WORDPRESS_DB_NAME',		'${DB_NAME}');
define('WORDPRESS_DB_USER',		'${DB_USER}');
define('WORDPRESS_DB_PASSWORD',	'${DB_PASSWORD}');
/** MySQL hostname(:port if needed) */
define('WORDPRESS_DB_HOST',		'${DB_HOST}');
/** “The WordPress admin area and login must use HTTPS. (just a safeguard, in case in the future the port 80 will also be opened” */
define('FORCE_SSL_ADMIN', true);
?>
EOF

fi

#: Starting the php-fpm service | -F keeping in foreground
exec php-fpm8.2 -F