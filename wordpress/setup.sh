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
define('DB_HOST',		'${WORDPRESS_DB_HOST}:${WORDPRESS_DB_PORT}');

\$table_prefix = 'wp_'; // Only numbers, letters, and underscores please!

/** Finding and loading wp-config.php. Load WordPress's main initialization/bootstrap*/
require_once ABSPATH . 'wp-settings.php';
EOF

fi

#NOTE: [php -l /var/www/html/wp-config.php] can check whether the PHP file is syntactically valid

# Change this folder's ownership to wp so it can write it, for image uploads, plugins, themes, so on
chown -R www-data:www-data /var/www/html

#: Starting the php-fpm service | -F keeping in foreground
exec php-fpm8.2 -F 