# Defining base image
FROM debian:bookworm

RUN apt update
RUN apt install nginx -y

# configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /etc/nginx/ssl
COPY ssl_certificate_gen.sh /etc/nginx/ssl/ssl_certificate_gen.sh

# install openssl inside
RUN apt install -y openssl
# set working directory so key anr crt get created in correct directory
WORKDIR /etc/nginx/ssl
RUN chmod +x ssl_certificate_gen.sh
RUN ./ssl_certificate_gen.sh

# Documentation: listening port 
EXPOSE 443

# Run the application
# - no need to do "-g", "daemon off;" because nginx config already has deamon off
ENTRYPOINT ["nginx"]
