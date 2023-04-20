FROM php:8.2-fpm

ARG DEPLOY_USER
ARG DEPLOY_USER_HOME
ARG DEPLOY_USER_NAME
ARG DEPLOY_USER_EMAIL
ARG DATADIR
ARG DEV_MODE

ENV DEPLOY_USER=${DEPLOY_USER:-moz}
ENV DEPLOY_USER_HOME=${DEPLOY_USER_HOME:-/home/$DEPLOY_USER} \
    DEPLOY_USER_NAME=${DEPLOY_USER_NAME:-"User Person"} \
    DEPLOY_USER_EMAIL=${DEPLOY_USER_EMAIL:-"user@person.org"} \
    DATADIR=${DATADIR:-/moz-data} \
    WORKDIR=${WORKDIR:-/var/www/html} \
    PROJECTDIR=${PROJECTDIR:-${DEPLOY_USER_HOME}/Downloads} \
    SSHDIR=${DEPLOY_USER_HOME}/.ssh \
    GIT_DOMAIN=${GIT_DOMAIN:-github.com} \
    DEV_MODE=${DEV_MODE:-}

COPY install-composer.sh install-xdebug.sh init.sh start.sh /usr/local/bin/

RUN apt update && apt --yes install git mercurial vim mlocate inetutils-ping \
	net-tools telnet ca-certificates \
	zlib1g-dev unzip libzip-dev python pip virtualenv wget\
	&& update-ca-certificates \
	&& docker-php-ext-install mysqli pdo_mysql zip \
    && useradd --create-home --home-dir $DEPLOY_USER_HOME --shell /bin/bash $DEPLOY_USER \
    && chmod +x /usr/local/bin/*.sh \
    && init.sh && install-composer.sh

USER $DEPLOY_USER

RUN git config --global user.name "$DEPLOY_USER_NAME" \
    && git config --global user.email $DEPLOY_USER_EMAIL

COPY --chown=$DEPLOY_USER: --chmod=600 ssh/* "$SSHDIR"/
COPY --chown=$DEPLOY_USER:www-data --chmod='u=rw,g=r' config.ini "$PROJECTDIR"/

USER root

# RUN chown -R $DEPLOY_USER: "$SSHDIR" && chmod -R u+w "$SSHDIR"

# Apply this if there is not already a volume for them
VOLUME "$WORKDIR"
VOLUME "$DATADIR"

ENTRYPOINT [ "start.sh" ]