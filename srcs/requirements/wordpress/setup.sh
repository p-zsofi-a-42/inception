#!/bin/sh
# On first start it populates the named volume with WordPress core
# writes wp-config.php
# installs WordPress and creates two users ( administrator, regular )

# don't continue if there is an error
set -e

WP_PATH=/var/www/html
WP="wp --path=${WP_PATH} --allow-root"

# setting up db credentials
WORDPRESS_DB_NAME=$(cat /run/secrets/db-dbname)
WORDPRESS_DB_USER=$(cat /run/secrets/db-username)
WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db-password)

# setting up wp users and credentials
WP_ADMIN_USER=$(cat /run/secrets/wp_admin_user)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_ADMIN_EMAIL=$(cat /run/secrets/wp_admin_email)
WP_USER=$(cat /run/secrets/wp_user)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
WP_USER_EMAIL=$(cat /run/secrets/wp_user_email)

# credentials validation
case "$(echo "${WP_ADMIN_USER}" | tr '[:upper:]' '[:lower:]')" in
	admin)
		echo "[wordpress] ERROR: the administrator name '${WP_ADMIN_USER}' contains 'admin'."
		echo "[wordpress] Edit secrets/wp_admin_user.txt and pick another name."
		exit 1
		;;
esac

# we don't do COPY on this because then substituted values (=secrets) would be baked into the image -> create upon container start
# --skip-check: the database may exist but be empty
if [ ! -f "${WP_PATH}/wp-config.php" ]; then
	echo "[wordpress] generating wp-config.php..."
	${WP} config create \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}:${WORDPRESS_DB_PORT}" \
		--dbcharset="utf8mb4" \
		--skip-check
fi

if ! ${WP} core is-installed > /dev/null 2>&1; then
	echo "[wordpress] installing WordPress..."
	${WP} core install \
		--url="https://zpalotas.42.fr" \
		--title="Inception" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email

	echo "[wordpress] creating second user '${WP_USER}'..."
	${WP} user create "${WP_USER}" "${WP_USER_EMAIL}" \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}"

	echo "[wordpress] installation done."
else
	echo "[wordpress] existing installation found, skipping install."
fi

# Change this folder's ownership to wp so it can write it, for image uploads, plugins, themes, so on
chown -R www-data:www-data "${WP_PATH}"

#: Starting the php-fpm service | -F keeping in foreground | php-fpm becomes PID 1.
exec php-fpm8.2 -F 