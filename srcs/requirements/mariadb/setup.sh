#!/bin/bash

# This script is used to initialize the database.

# Exit immediately this script if something fails
set -e

# Getting the value from compose secrets
MYSQL_USER=$(cat /run/secrets/db-username)
MYSQL_PASSWORD=$(cat /run/secrets/db-password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db-rootpassword)
MYSQL_DATABASE=$(cat /run/secrets/db-dbname)

# Only needed when the volume is genuinely empty (nothing was copied into it)
if [ ! -d /var/lib/mysql/mysql ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Making sure the runtime socket directory exists and MariaDB can write to it.
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Setting up a custom init flag that lives persistently on the volume
# to signal to ourselves if the db has been already initialized
INIT_FLAG=/var/lib/mysql/.inception-initialized

if [ ! -f "$INIT_FLAG" ]; then

	# Temporarily don't accept TCP/network connections. 
	# Only during initial setup so that the database server is only accessible locally 
	# while you're configuring its users/passwords. Run in background (&)
	mariadbd --user=mysql --skip-networking &

	# Saving the pid to kill it later
	TEMP_PID=$!

	# Waiting for mariadb to be up to be ready to accept connections, but not forever
	for _ in $(seq 1 30); do
		if mariadb-admin ping --silent 2>/dev/null; then
			break
		fi
		sleep 1
		echo "Waiting for DB..."
	done
	# Fails the script (set -e) if the server never came up
	mariadb-admin ping --silent

	echo "DB is running..."

	#: without "IF NOT EXIST" on possible multiple run of the script the command will fail (not omit the cmd or overwrite the og)
	#: A MariaDB account is identified by both a username and a host.
	#:	@localhost =  when user and db are on the same machine
	#:	% a wildcard =  may connect from any host (and any container) (but still restricted by who can reach the port)
	#: FLUSH PRIVILEGES; tells MariaDB to reload the privilege tables so permission changes take effect.
	mariadb -u root <<EOF
	CREATE USER IF NOT EXISTS
		'root'@'localhost'
		IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

	ALTER USER
		'root'@'localhost'
		IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

	CREATE DATABASE IF NOT EXISTS
		${MYSQL_DATABASE};

	CREATE USER IF NOT EXISTS
		'${MYSQL_USER}'@'%'
		IDENTIFIED BY '${MYSQL_PASSWORD}';

	GRANT ALL PRIVILEGES
		ON ${MYSQL_DATABASE}.*
		TO '${MYSQL_USER}'@'%';
	FLUSH PRIVILEGES;
EOF

	# Stopping the temporary setup server cleanly. root has a password now, so we use it.
	mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
	# The server exits on its own, don't let a non-zero status abort the script
	wait "$TEMP_PID" || true

	touch "$INIT_FLAG"
	echo "Database initialized."
fi

# Mariadb becomes pid 1 and stays alive 
# - run Run MariaDB as the mysql Linux user; not as root
# - save logs to stdout/err
exec mariadbd --user=mysql --console
