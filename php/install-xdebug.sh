#!/bin/bash

pecl install xdebug

# On Docker for Mac, you may need to set xdebug.client_host to the host machine's private IP.
# The default port for Xdebug 3 is 9003. It can be set with xdbeug.client_port
# See https://xdebug.org/docs/all_settings
echo "zend_extension=$(ls /usr/local/lib/php/extensions/no-debug-non-zts-*/xdebug.so)" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.mode=develop,debug" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.discover_client_host=on" >> /usr/local/etc/php/conf.d/xdebug.ini
echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini

echo "Xdebug installed. Please restart the container"
