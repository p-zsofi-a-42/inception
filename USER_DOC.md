# User documentation

This file explains how to run and use the project as a user or administrator.

## What the stack provides

This project runs three services together:

- `nginx`: receives HTTPS traffic on port 443 and serves the site
- `wordpress`: runs WordPress through PHP-FPM
- `mariadb`: stores the website database

## Before the first start

Your machine must resolve the domain name locally. Add this line to `/etc/hosts`:

```sh
127.0.0.1   zpalotas.42.fr www.zpalotas.42.fr
```

Then check if it works:

```sh
ping -c1 zpalotas.42.fr
```

## Start, stop, and restart

Run everything from the project root, this will promt you to create all the required credentials (if they dont exist already):

Useful commands:

- `make`		: build up the website with your own credentials
- `make stop`	: stop the website, it won't be accessible until you run "make" again
- `make re`		: run this if you need to change credentials. Attention! this will also delete all the data you had on your website

### Credentials

Credentials are stored as plain files in `secrets/`, one value per file.

The project uses these credentials for the database and the WordPress admin/user accounts.

If you need to change a password, (and you have permission to do that) update the matching file in `secrets/`. Make sure you keep the filename unchanged!

### Checking if the services run correctly

From the project root, run:

```sh
docker compose -f docker-compose.yml ps
```

You should see the nginx, mariadb, and wordpress containers in the Up state.
The MariaDB container should also show a healthy status.

To confirm the site is responding over HTTPS:

```sh
curl -k -I https://zpalotas.42.fr
```
If the command returns an HTTP response, the stack is running correctly.


## Access the website

The site is availabe at:

- https://zpalotas.42.fr

You can login here:

- https://zpalotas.42.fr/wp-login.php

If you are the administrator you can login here:
- https://zpalotas.42.fr/wp-admin

NOTE: The certificate is self-signed, so the browser will show a warning. This is expected. Accept the warning to continue.

## Important notes

- `http://` is not served; only HTTPS works.
- Use `make fclean` carefully. It deletes everything in the database and WordPress upload folder.
