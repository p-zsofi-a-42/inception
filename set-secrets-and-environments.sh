#!/bin/sh

# This scripts helps you to create all the required credentials for the secrets forlder and env. file
# It also makes sure that the folder required for the volumes is created
 
set -eu

mkdir -p secrets

# Rejects input that would only blow up later inside the containers:
# empty values, malformed emails, an administrator name containing "admin".
validate() {
	name=$1
	value=$2

	if [ -z "$value" ]; then
		echo "  -> value cannot be empty"
		return 1
	fi

	case "$name" in
		*email*)
			case "$value" in
				?*@?*.?*) ;;
				*) echo "  -> not a valid email address"; return 1 ;;
			esac
			;;
		wp_admin_user)
			case "$(echo "$value" | tr '[:upper:]' '[:lower:]')" in
				*admin*) echo "  -> the administrator name must not contain 'admin'"; return 1 ;;
			esac
			;;
	esac

	return 0
}

for secret in \
	username \
	password \
	rootpassword \
	dbname \
	wp_admin_user \
	wp_admin_password \
	wp_admin_email \
	wp_user \
	wp_user_password \
	wp_user_email
 do
	file="secrets/secret-$secret.txt"

	if [ ! -e "$file" ]; then
		touch "$file"
	fi

	while [ ! -s "$file" ]; do
		printf 'Enter %s: ' "$secret"
		IFS= read -r value
		if validate "$secret" "$value"; then
			printf '%s\n' "$value" > "$file"
		fi
	done
done

# WordPress needs two distinct users, the administrator and a regular one
if [ "$(cat secrets/secret-wp_admin_user.txt)" = "$(cat secrets/secret-wp_user.txt)" ]; then
	echo "ERROR: the administrator and the second WordPress user must be different."
	echo "Edit secrets/secret-wp_user.txt and run make again."
	exit 1
fi

# The compose file is read with --env-file srcs/.env, so it has to exist before
# anything is started. It holds no credentials, only non-secret settings.
if [ ! -s srcs/.env ]; then
	echo "Creating srcs/.env with default values..."
	cat > srcs/.env <<'ENV'
# MariaDB connection settings used by WordPress.
# DB_HOST must match the name of the database service in docker-compose.yml.
# Credentials are NOT here: they live in Docker secrets (see ../secrets).
DB_HOST=mariadb
DB_PORT=3306
ENV
fi

# The named volumes are bound to this directory, so it has to exist beforehand.
DATA_PATH=/home/zpalotas/data
if ! mkdir -p "$DATA_PATH/wordpress" "$DATA_PATH/mariadb" 2>/dev/null; then
	echo "ERROR: cannot create $DATA_PATH."
	exit 1
fi
echo "Volume data directory ready: $DATA_PATH"
