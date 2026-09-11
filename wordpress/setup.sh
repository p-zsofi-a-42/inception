#!/bin/sh

# we don't do COPY on this because then substituted values (=secrets) would be baked into the image -> create upon container start
if [ ! -f /var/www/html/wp-config.php ]; then
	cat > /var/www/html/wp-config.php <<EOF
<?php
/** Telling wordpress how to connect to the db */

define('DB_NAME',		'${WORDPRESS_DB_NAME}');
define('DB_USER',		'${WORDPRESS_DB_USER}');
define('DB_PASSWORD',	'${WORDPRESS_DB_PASSWORD}');
/** MySQL hostname(:port if needed) */
define('DB_HOST',		'${WORDPRESS_DB_HOST}');
/** “The WordPress admin area and login must use HTTPS. (just a safeguard, in case in the future the port 80 will also be opened” */
define('FORCE_SSL_ADMIN', true);
/** Finding and loading wp-config.php. Load WordPress's main initialization/bootstrap*/
require_once ABSPATH . 'wp-settings.php';
?>
EOF

fi

#: Starting the php-fpm service | -F keeping in foreground
exec php-fpm8.2 -F 