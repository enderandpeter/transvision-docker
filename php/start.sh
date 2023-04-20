#! /usr/bin/env bash

# Deploy the web app if the git remote was given
if [ $GIT_REMOTE ]; then
  if [ -e $SSHDIR/id_rsa ]; then
    if ! [ -e $DEPLOY_USER_HOME/.ssh/id_rsa ]; then
        echo "Copying SSH key files..."
        cp $SSHDIR/id_rsa* $DEPLOY_USER_HOME/.ssh
        chmod 600 $DEPLOY_USER_HOME/.ssh/*
        chown -R $DEPLOY_USER: $DEPLOY_USER_HOME/.ssh
    else
      echo "Found $DEPLOY_USER_HOME/.ssh/id_rsa"
    fi

    if [ -e "$SSHDIR"/.gitignore ]; then
      rm "$SSHDIR"/.gitignore;
    fi

  else
    echo "SSH key files not found"
    exit 1
  fi

  # Configure git
  echo "git config pull.rebase false" | su - $DEPLOY_USER --shell=/bin/bash

  if [ -z "$(ls "$WORKDIR")" ]; then
   echo "Deploying web app at $GIT_REMOTE to $WORKDIR"

   if [ -z $DEV_MODE ]; then
       COMPOSER_DEV_FLAG="--no-dev"
   fi

   echo "ssh-keyscan $GIT_DOMAIN >> ~/.ssh/known_hosts \
     && git clone $GIT_REMOTE $WORKDIR \
     && cd $WORKDIR \
     && composer install $COMPOSER_DEV_FLAG \
     && git config --global user.name \"$DEPLOY_USER_NAME\" \
     && git config --global user.email $DEPLOY_USER_EMAIL" | su - $DEPLOY_USER --shell=/bin/bash \
     && CODE_DEPLOYED=1

     if ! [ $CODE_DEPLOYED ]; then
       echo "Could NOT deploy code."
       exit 1
     fi
 else
   echo "$WORKDIR contains files"
 fi
fi

if [ -e "$PROJECTDIR"/config.ini ]; then
  cp "$PROJECTDIR"/config.ini "$WORKDIR"/app/config/config.ini
fi

echo "Setting permissions for working directory and moz data directory..."

# g+ws sets both writing and the sticky bit on the group so that
# files created under the folders will still be owned by the group
chown -R $DEPLOY_USER:www-data "$WORKDIR" \
  && chown -R $DEPLOY_USER:www-data "$DATADIR" \
  && chmod -R g+ws "$DATADIR" \
  && chmod -R g+ws "$WORKDIR"/cache \
  && PERMISSIONS_SET=1

if ! [ $PERMISSIONS_SET ]; then
  echo "Could not set permissions for $WORKDIR"
  exit 1
fi

"$WORKDIR"/app/scripts/setup.sh
"$WORKDIR"/app/scripts/glossaire.sh

chmod -R g+ws "$WORKDIR"/cache \
  && PERMISSIONS_SET=1

if ! [ $PERMISSIONS_SET ]; then
  echo "Could not set permissions for $WORKDIR"
  exit 1
fi

php-fpm