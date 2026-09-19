#!/bin/sh

set -eu

mkdir -p secrets

for secret in username password rootpassword dbname; do
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

if [ ! -e .env ]; then
	touch .env
fi

if [ ! -s .env ]; then
	printf 'Enter DB_PORT: '
	IFS= read -r db_port

	{
		printf 'DB_PORT=%s\n' "$db_port"
	} > .env
fi