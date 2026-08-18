#!/bin/bash

# This script is used to initialize the database. 

# run as amridb as the linux user || not let others connect bc this is just temp until we setup || run in backround
#mariadbd --user=mysql --skip-networking &
## store mariadb pid
#pid="$!"
##mysql -h"$MYSQL_HOST" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"
##keep waiting until command succeds
#until mariadb-admin ping --silent; do
#	sleep 1
#done


#: without "IF NOT EXIST" on possible multiple run of the script the command will fail (not omit the cmd or overwrite the og)
#: my db is stored as a volume so even if the container is deleted and freshly recreated the db exists
#: A MariaDB account is identified by both a username and a host. 
#:	@localhost =  when user and db are on the same machine
#:	% a wildcard =  may connect from any host (and any container) (but still restricted by who can reach the port)
#: FLUSH PRIVILEGES; tells MariaDB to reload the privilege tables so permission changes take effect. (to be safe, but modern does it automatically)
mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" <<EOF
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

# mariadb becomes pid 1 and stays alive || run Run MariaDB as the mysql Linux user; not as root || save logs to stdout/err
#kill "$pid"
#wait "$pid"
exec mariadbd --user=mysql --console