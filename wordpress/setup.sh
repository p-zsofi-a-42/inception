#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then
	cat > /var/www/html/wp-config.php <<EOF
<?php

define('DB_NAME',		'${DB_NAME}');
define('DB_USER',		'${DB_USER}');
define('DB_PASSWORD',	'${DB_PASSWORD}');
/** MySQL hostname(:port if needed) */
define('DB_HOST',		'${DB_HOST}');
/** “The WordPress admin area and login must use HTTPS. (just a safeguard, in case in the future the port 80 will also be opened” */
define('FORCE_SSL_ADMIN', true);
?>
EOF

fi

#: Starting the php-fpm service
#service php8.2-fpm start
exec php-fpm -F