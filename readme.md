# Docker Compose for Transvision

This is a Docker Compose setup for [Transvision](https://github.com/mozfr/transvision), the primary resource for finding translation strings in Mozilla source code. These files will provide everything needed for setting up a portable, secure, and customizeable configuration for deploying the Transvision web application.

This setup can be used to develop the application locally as well as deploy in on production. Please read this guide to understand how to configure it for either environment.

## Host Machine Requirements

* docker ([Linux](https://docs.docker.com/engine/install/ubuntu/), [macOS](https://docs.docker.com/desktop/install/mac-install/), [Windows](https://docs.docker.com/desktop/install/windows-install/))
* (Optional but strongly recommended) httpd ([Linux](https://packages.ubuntu.com/search?keywords=apache2&searchon=names&suite=kinetic), macOS [built-in, or use [homebrew](https://formulae.brew.sh/formula/httpd)], [Windows](https://www.apachelounge.com/download/))

## Deployment Strategy

The manner in which this Docker setup should be deployed is strongly inspired by Docker's guide on [Using Compose in production](https://docs.docker.com/compose/production/). Please review that guide to get a good sense of how things are setup here. The main things to keep in mind are that docker-compose.*.yml files can be used to set config for specific environments, as well as the `.env` settings.

Also, Docker strongly recommends using bind-mounted volumes from your host machine in a development environment so the host machine can easily access the source code. However, Docker volumes that are inside the container should be used in production environments so that access to the production host machine is strongly regulated.

All Docker Compose `.env` settings are required unless otherwise noted:

* `COMPOSE_PROJECT_NAME` - A name for this composer project. This is one of the [pre-defined environment variables](https://docs.docker.com/compose/environment-variables/envvars/).
* `COMPOSE_FILE` - An optional string of the docker-compose.yml files to apply. Set to a string of such files, delimited by colons on Linux/macOS or semicolons on Windows.
* `IMAGE_NS` - The namespace to use for the images that will be made.
* `TRANSVISION_VOLUME` - In local development, set this to a relative or absolute path to the Transvision repo. Otherwise, set this to a string that will be used to name the Docker volume, which will be prefixed with the `COMPOSE_PROJECT_NAME`.
* `PHP_WORKDIR` - (**default**: */var/www/html*) The directory with the Transvision repo will be loaded, either bind-mounted from a dev host machine, or the deployment process will download the repo from git into a Docker volume
* `DATADIR` - (**default**: */moz-data*) The directory in the container where the Mozilla repos, cache files, etc. will be stored
* `HTTPD_WEB_PORT` - (**default**: *8022*) The host port to map to port 80 in the httpd container (https support coming soon)
* `PHP_WEB_PORT` - (**default**: *8020*) The host port to map to port 8020 in the php container to be used for the test PHP server is desired
* `PHP_PORT` - (**default**: *9000*) The host port to map to php-fpm
* `SERVER_NAME` - Set the main server name for httpd
* `SERVER_ADMIN` - Set the admin email for httpd
* `DEPLOY_USER` - The name of the user that is primarily used to do things in the container. It is strongly recommened that you mainly do actions as this user and only use root when necessary. Use `su - $DEPLOY_USER` to making changes in the system as this user.
* `DEPLOY_USER_HOME` - (**default**: */home/$DEPLOY_USER*) The deploy user's home
* `DEPLOY_USER_NAME` - (**default**: *Your Name*) The name for the git user in the container. Set this to your name in your dev environment, or a deploy user name in the production environment
* `DEPLOY_USER_EMAIL` - (**default**: *your@email.com*) The email for the git user in the container.
* `GIT_REMOTE` - The git URL to use for the web app. Set this to your fork, or the real thing as necessary. This only needs to be set when deploying for production.

## Deployment Steps

1. Copy `.env.example` to `.env`. Review the settings above and set them as appropriate in this file.
2. **Production only** - Copy a private SSH key into `php/ssh` to be used to download the Transvision repo.
3. Copy `php/config.ini-dist` to `php/config.ini`. The default settings should be appropriate for the environment, but you can change them as needed.
4. **Production only** - Copy `docker-compose.prod.yml.example` to `docker-compose.prod.yml` and confirm the appropriate settings.
5. Run `docker compose up -d`
6. Use Docker Desktop or watch the logs with `docker logs -f` to confirm that the containers are running and the Transvision setup files are doing their thing.
7. If everything went smoothly, then you should have a reliable and portable deployment!
