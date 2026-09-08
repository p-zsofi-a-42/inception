# Defining base image
FROM debian:bookworm

RUN apt update

# - php-fpm 		# PHP FastCGI Process Manager (PHP-FPM), which runs the PHP code
# - php-mysql 		# php connection to db
# - php-curl 		# http requests to other servers
# - php-gd			# image manipulation
# - php-mbstring 	# UTF-8 and multibyte chars
# - php-xml 		# xml parsing
# - php-intl 		# Internationalization (locales, formatting)
# - php-zip			# handle zip archives
RUN apt install -y \
    php-fpm \
    php-mysql \
	php-curl \
	php-gd \
	php-mbstring \
	php-xml \
	php-intl \
	php-zip \
	wget

# Download latest wordpress version
RUN wget https://wordpress.org/latest.tar.gz
# Extract 
RUN tar -xzvf latest.tar.gz

#: Populating the volume
RUN mkdir -p /var/www/html
RUN mv wordpress/* /var/www/html/

COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh

# Documentation: listening port 
EXPOSE 9000

# Run the application
ENTRYPOINT ["/setup.sh"]
#CMD ["./php-fpm"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]