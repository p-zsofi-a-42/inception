# Defining base image
FROM debian:bookworm

RUN apt update

# - php-fpm 		# PHP FastCGI Process Manager (PHP-FPM), which runs the PHP code
# - php-cli			# command line interface
# - php-mysql 		# php connection to db
# - php-curl 		# http requests to other servers
# - php-gd			# image manipulation
# - php-mbstring 	# UTF-8 and multibyte chars
# - php-xml 		# xml parsing
# - php-intl 		# Internationalization (locales, formatting)
# - php-zip			# handle zip archives
RUN apt install -y \
    php-fpm \
	php-cli \
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

# fetch wp cmd
RUN wget -O /usr/local/bin/wp \
      https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x /usr/local/bin/wp

#: Populating the volume
RUN mkdir -p /var/www/html
RUN cp -a wordpress/* /var/www/html/

COPY ./setup.sh /setup.sh
RUN chmod +x /setup.sh

# Documentation: listening port 
EXPOSE 9000

# Changing the php-fpm configuration to listen on the port 9000
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

# Run the application
ENTRYPOINT ["/setup.sh"]