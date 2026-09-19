# Defining base image
FROM debian:bookworm

RUN apt update
RUN apt install mariadb-server -y

COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh

# used a numbered file name to ensure it will not be overriden by other config files
COPY ./99-custom.cnf /etc/mysql/mariadb.conf.d/99-custom.cnf
# making sure its not writable by everyone otherwise gets ignored
RUN chmod 644 /etc/mysql/mariadb.conf.d/99-custom.cnf

# Documentation: listening port 
EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
#CMD ["/setup.sh"]