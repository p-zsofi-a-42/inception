# Defining base image
FROM alpine:3.23

#
RUN apk update

COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh

# Documentation: listening port 
EXPOSE 9000

# Run the application
ENTRYPOINT ["/setup.sh"]