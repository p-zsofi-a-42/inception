#!/bin/bash

# This script is used to initialize the database. 

# run as amridb as the linux user || not let others connect bc this is just temp until we setup || run in backround
mariadbd --user=mysql --skip-networking &
# store mariadb pid
pid="$!"
#mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"
#keep waiting until command succeds
until mariadb-admin ping --silent; do
	sleep 1
done

mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
	IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* 
	TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# CREATE USER 'appuser'@'localhost' IDENTIFIED BY 'strong_password_here';
# GRANT ALL PRIVILEGES ON your_database.* TO 'appuser'@'localhost';
# FLUSH PRIVILEGES;

# mariadb becomes pid 1 and stays alive || run Run MariaDB as the mysql Linux user; not as root || save logs to stdout/err
kill "$pid"
wait "$pid"
exec mariadbd --user=mysql --console