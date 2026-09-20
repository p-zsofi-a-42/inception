# Defining base image
FROM debian:bookworm

RUN apt update
RUN apt install mariadb-server -y

# Copying the setup script into the conainer
COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh

# Useing 99 in the filename to ensure it will not be overriden by existing config files in the same folder
COPY ./99-custom.cnf /etc/mysql/mariadb.conf.d/99-custom.cnf
# Making sure its not writable by everyone otherwise it gets ignored
RUN chmod 644 /etc/mysql/mariadb.conf.d/99-custom.cnf

# Documentation: listening port 
EXPOSE 3306

ENTRYPOINT ["/setup.sh"]