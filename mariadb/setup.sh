#!/bin/bash

# This script is used to initialize the database. 
echo "=== DB INIT SCRIPT VERSION 005 ==="

# Exit immediately this script if something fails
#set -e

# data directory initialization. Creating the initial system database files that MariaDB needs before the server can properly run.
if [ ! -d /var/lib/mysql/mysql ]; then
mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Making sure the runtime socket directory exists and MariaDB can write to it.
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Temporarily don't accept TCP/network connections. Only during initial setup so that the database server is only accessible locally while you're configuring its users/passwords. Run in background (&)
mariadbd --user=mysql --skip-networking &

# saving the pid to kill it later
TEMP_PID=$!
# waiting for mariadb to be up to be ready to accept connections
until mariadb-admin ping  --silent; do
	sleep 1
	echo "Waiting for DB..."
done

echo "DB is running..."

mariadb -u root <<EOF
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



# starting the server in the background
#mariadbd --user=mysql --console &
#
## waiting for mariadb to be up to be ready to accept connections
#until mariadb-admin ping -u root -p"${MYSQL_ROOT_PASSWORD}" --silent; do
#sleep 1
#echo "Still waiting..."
#done
#
##: without "IF NOT EXIST" on possible multiple run of the script the command will fail (not omit the cmd or overwrite the og)
##: my db is stored as a volume so even if the container is deleted and freshly recreated the db exists
##: A MariaDB account is identified by both a username and a host. 
##:	@localhost =  when user and db are on the same machine
##:	% a wildcard =  may connect from any host (and any container) (but still restricted by who can reach the port)
##: FLUSH PRIVILEGES; tells MariaDB to reload the privilege tables so permission changes take effect. (to be safe, but modern does #it automatically)
#
#echo "Trying to create database"
#
#mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
#	CREATE DATABASE IF NOT EXISTS
#		${MYSQL_DATABASE};
#
#	CREATE USER IF NOT EXISTS
#		'${MYSQL_USER}'@'%'
#		IDENTIFIED BY '${MYSQL_PASSWORD}';
#	
#	GRANT ALL PRIVILEGES 
#		ON ${MYSQL_DATABASE}.* 
#		TO '${MYSQL_USER}'@'%';
#	
#	FLUSH PRIVILEGES;
#EOF
#
#echo "Created database"

# stopping temp setup server
kill "$TEMP_PID"
wait "$TEMP_PID"
# mariadb becomes pid 1 and stays alive || run Run MariaDB as the mysql Linux user; not as root || save logs to stdout/err
exec mariadbd --user=mysql --console