#!/bin/bash

# - php-fpm 		# PHP FastCGI Process Manager (PHP-FPM), which runs the PHP code
# - php-mysql 		# php connection to db
# - php-curl 		# http requests to other servers
# - php-gd			# image manipulation
# - php-mbstring 	# UTF-8 and multibyte chars
# - php-xml 		# xml parsing
# - php-intl 		# Internationalization (locales, formatting)
# - php-zip			# handle zip archives
apt install -y \
	php-fpm \
	php-mysql \
	php-curl \
	php-gd \
	php-mbstring \
	php-xml \
	php-intl \
	php-zip

# Download latest wordpress version
wget https://wordpress.org/latest.tar.gz

# Extract 
tar -xzvf latest.tar.gz