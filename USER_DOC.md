# User documentation

This file explains how to run and use the project without changing its code.

## What the stack provides

This project runs three services together:

- `nginx`: receives HTTPS traffic on port 443 and serves the site
- `wordpress`: runs WordPress through PHP-FPM
- `mariadb`: stores the website database

The site is available at:

- https://zpalotas.42.fr
- admin panel: https://zpalotas.42.fr/wp-admin

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

Run everything from the project root, this will promt you to create all the required credentials:

Useful commands:

```sh
make
make stop
make re
```

What they do:

- `make`: build up the website with your own credentials
- `make stop`: stop the website, it won't be accessible until you run "make" again
- `make re`: run this if you need to change credentials. Attention! this will also delete all the data you had on your website

## Access the website

Open:

- https://zpalotas.42.fr
- https://zpalotas.42.fr/wp-admin

The certificate is self-signed, so the browser will show a warning. This is expected. Accept the warning to continue.

## Credentials

Credentials are stored as plain files in `secrets/`, one value per file.

The project uses these credentials for the database and the WordPress admin/user accounts.

If you need to change a password, update the matching file in `secrets/`. Make sure you keep the filename unchanged

## Important notes

- `http://` is not served; only HTTPS works.
- Use `make fclean` carefully. It deletes everything in the database and WordPress upload folder.
