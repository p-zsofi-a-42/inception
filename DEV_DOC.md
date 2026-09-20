# Developer documentation

This file explains how to set up and work on the project from a developer point of view.

## About the project services

- `nginx` serves the HTTPS site
- `wordpress` installs and runs WordPress
- `mariadb` stores the app data

The stack is started with Docker Compose and is designed to be managed through the Makefile.

## Project layout

The repository contains:

- `Makefile` for running the project
- `srcs/docker-compose.yml` for services and volumes
- `srcs/.env` for non-secret config
- `secrets/` for secret values
- `srcs/requirements/` with each service Dockerfile and setup script

## Prerequisites

You need:

- Docker Engine
- Docker Compose plugin
- `make`
- a Linux environment / VM

Check:

```sh
docker --version
docker compose version
make --version
```

## Setup from scratch

When you first run "make" it will create the files and promt you to fill in all the required credentials.

Constraints:

- `wp_admin_user` must not contain `admin` or `administrator`; the
  entrypoint exits with an error if it does.
- Avoid `'`, `\` and `$` in passwords: the values pass through both shell
  and SQL.
- Note: `secrets/*` and .env is already gitignored

### 4. Build and start

Useful targets in the Makefile:

- `make`		: set up credentials if needed, start all the services with Docker Compose
- `make stop`	: stop containers, pause serving the website
- `make down`	: stop/remove containers and network, keep data
- `make fclean`	: delete containers, images and volumes; destroys data
- `make re`		: delete containers, images and volumes; destroys data and rebuild the service

You can also do the same using docker compose commands, ran from the `/srcs` folder:
- `docker compose --env-file .env up --build -d` (you need to already have populated secret files for this) 
- `docker compose stop`
- `docker compose down`
- `docker compose down -v --rmi all`
- `docker compose down -v --rmi all && docker compose --env-file .env up --build -d` 

## Container and volume management

To inspect or stop the stack:

```sh
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps
docker compose -f srcs/docker-compose.yml --env-file srcs/.env logs
docker compose -f srcs/docker-compose.yml --env-file srcs/.env down
```

List containers:

```sh
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps
```

Show logs:

```sh
docker logs mariadb
docker logs wordpress
docker logs nginx
```

Open a shell in a container:

```sh
docker exec -it mariadb bash
docker exec -it wordpress bash
```

Check volume names:

```sh
docker volume ls
```

The project uses named volumes for persistent data:

- `srcs_wordpress` for WordPress files
- `srcs_mariadb` for the database

## Where data is stored

The project stores data outside the container filesystem so it persists across container rebuilds.

The app uses named volumes mapped to host directories, so the actual data remains on the host machine rather than being lost when containers are recreated.

You can inspect the current Docker volumes:

```sh
docker volume inspect srcs_wordpress
docker volume inspect srcs_mariadb
```