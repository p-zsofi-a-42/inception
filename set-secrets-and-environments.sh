#!/bin/sh

set -eu

mkdir -p secrets

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

	if [ ! -s "$file" ]; then
		printf 'Enter %s: ' "$secret"
		IFS= read -r value
		printf '%s\n' "$value" > "$file"
	fi
done

if [ ! -e srcs/.env ]; then
	touch srcs/.env
fi

if [ ! -s srcs/.env ]; then
	printf 'Enter DB_PORT: '
	IFS= read -r db_port

	{
		printf 'DB_PORT=%s\n' "$db_port"
	} > srcs/.env
fi