# Defining base image
FROM debian:bookworm

RUN apt update
RUN apt install mariadb-server -y

COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh

# Documentation: listening port 
EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
#CMD ["/setup.sh"]