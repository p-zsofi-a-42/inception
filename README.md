_This project was created as part of the 42 curriculum by zpalotas._

# Inception

## Description

This project deploys a small WordPress website with Docker Compose. Its goal is to run three cooperating services:

- **Nginx**: the only public entry point; terminates HTTPS and forwards PHP requests.
- **WordPress**: runs PHP-FPM and serves the WordPress application.
- **MariaDB**: stores WordPress posts, users, settings, and other application data.

The services are built from the Debian Bookworm image. The source for each service is under [`srcs/requirements/`](srcs/requirements/), while [`srcs/docker-compose.yml`](srcs/docker-compose.yml) defines the services, network, secrets, healthcheck, and persistent storage.

Nginx publishes port `443`. WordPress and MariaDB are reachable only through the internal Docker bridge network. A self-signed certificate is generated for local HTTPS use, so browsers display a certificate warning.

### Main design choices

- **Docker Compose** defines a reproducible multi-container application.
- **Separate services** keep the web server, PHP runtime, and database independently configurable.
- **Docker secrets** provide credentials at runtime instead of placing passwords in the image or Compose environment.
- **A healthcheck** makes WordPress wait until MariaDB is ready.
- **Persistent storage** keeps WordPress files and MariaDB data across container recreation.
- **Nginx as the public boundary** avoids publishing database and PHP-FPM ports to the host.

## Project description

| Choice | Used here | Alternative and trade-off |
| --- | --- | --- |
| Virtual machine vs Docker | Docker shares the host kernel, starts quickly, and isolates each service in a lightweight container. | A virtual machine includes a complete guest OS and usually provides stronger isolation, but needs more memory and starts more slowly. |
| Secrets vs environment variables | Passwords are mounted as files under `/run/secrets`; non-sensitive settings such as `DB_PORT` remain in `srcs/.env`. | Environment variables are convenient, but can be exposed through inspection, logs, or process tooling. They are appropriate here for non-secret configuration. |
| Docker network vs host network | Services use a private bridge network and communicate by service name, such as `wordpress:9000` and `mariadb`. | Host networking removes network isolation and exposes services directly on the host network. |
| Docker volumes vs bind mounts | Compose declares named volumes backed by `/home/zpalotas/data/wordpress` and `/home/zpalotas/data/mariadb`. | A pure Docker-managed volume hides the host path; a direct bind mount gives explicit host control but couples the stack to that path. |

## Instructions

DEV_DOC.md and USER_DOC.md provide detailed instructions on how to run the project.

To inspect or stop the stack:

```sh
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps
docker compose -f srcs/docker-compose.yml --env-file srcs/.env logs
docker compose -f srcs/docker-compose.yml --env-file srcs/.env down
```

The website is available at [https://zpalotas.42.fr](https://zpalotas.42.fr). The self-signed certificate warning is expected. Database and WordPress data are stored under `/home/zpalotas/data/`.

## Resources

A non-extensive list of useful links which helped in understanding the project's components

### Docker and Debian

- [Debian releases](https://www.debian.org/releases/) — base distribution information.
- [Docker build overview](https://docs.docker.com/build/concepts/overview/) — images and build layers.
- [Compose secrets](https://docs.docker.com/reference/compose-file/build/#secrets) — runtime secret handling.
- [Docker volumes](https://docs.docker.com/engine/storage/volumes/) — persistent container storage.
- [Docker build cache](https://medium.com/@rajesh.sgr/understanding-docker-no-cache-eb4f35b90a9d?sk=44b164046510b6d1b20f55f5b03a113) — why `--no-cache` can help diagnose stale layers.

### Nginx and HTTPS

- [Nginx official site](https://nginx.org/en/) — project documentation.
- [Nginx beginner's guide](https://nginx.org/en/docs/beginners_guide.html) — static files and request handling.
- [Nginx web server configuration](https://docs.nginx.com/nginx/admin-guide/web-server/web-server/) — server configuration concepts.
- [Nginx configuration cheatsheet](https://github.com/SimulatedGREG/nginx-cheatsheet) — quick configuration reference.
- [Nginx on Debian](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-debian-11) — installation background.
- [HTTPS with Let's Encrypt](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04) — certificate deployment background.
- [SSL/TLS explained](https://www.cloudflare.com/learning/ssl/what-is-an-ssl-certificate/) — encryption and authentication.
- [Self-signed certificates](https://www.sectigo.com/blog/what-is-a-self-signed-certificate) — local-development certificates.
- [IP and domain routing](https://ikarthiks.medium.com/ip-redirection-and-domain-configuration-53e0beb4ed81) — host and domain routing concepts.

### WordPress and PHP

- [WordPress prerequisites](https://developer.wordpress.org/advanced-administration/before-install/) — installation requirements.
- [WordPress installation](https://developer.wordpress.org/advanced-administration/before-install/howto-install/) — installation procedure.
- [WordPress installation tutorial](https://portforwarded.com/install-wordpress-on-ubuntu-22-04-lts-lamp-stack/) — example deployment walkthrough.
- [`wp-config.php` API](https://developer.wordpress.org/apis/wp-config-php/) — configuration reference.
- [WordPress configuration settings](https://developer.wordpress.org/advanced-administration/wordpress/wp-config/) — available settings.
- [WordPress SSL background](https://www.codeable.io/blog/wordpress-ssl-certificate/) — HTTPS considerations for WordPress.

### MariaDB

- [MariaDB documentation](https://mariadb.com/docs) — database reference.
- [MariaDB installation on Debian](https://utho.com/docs/database/mariadb/install-mariadb-on-debian-10) — setup background.
- [MariaDB Docker healthcheck](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/using-healthcheck-sh) — readiness checks.
- [MariaDB option files](https://mariadb.com/docs/server/server-management/install-and-upgrade-mariadb/configuring-mariadb/configuring-mariadb-with-option-files) — server configuration.

### Use of AI

AI assistance was used for editing documentation and code review tasks. plus explaining concepts.
