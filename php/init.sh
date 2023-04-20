#/bin/env bash

cat >> $DEPLOY_USER_HOME/.profile <<EOS
export DEPLOY_USER=$DEPLOY_USER
export DEPLOY_USER_HOME=$DEPLOY_USER_HOME
export DATADIR=$DATADIR

# Files created by this user will allow the group to write
umask 002
cd $WORKDIR
EOS

if [ $DEV_MODE ]; then
    # Xdebug for general debugging
    if ! php -v | grep Xdebug; then
        install-xdebug.sh
    fi
fi