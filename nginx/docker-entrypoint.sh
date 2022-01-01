#!/bin/bash
if [ -f "/var/www/composer.json" ]
then
    cd /var/www/
    composer install
    echo "Dependencies updated"
elif [ "$(ls -A "/var/www/")" ]; 
then
    echo "Directory is not Empty, Please deleted hiden file and directory"
elif [ {DRUPAL_INSTALL} = false ];
then   
    cd /var/www
    mv /app/drupal-* /app/drupal
    ln -s /app/drupal/* /var/www/
    chown -R nginx:nginx /app/drupal/
    cp /app/drupal/sites/default/default.settings.php /app/drupal/sites/default/settings.php
    chmod -R 777 /app/drupal/sites/default/
fi
cp /app/default.conf /etc/nginx/conf.d/default.conf
nginx -s reload
rm -rf /var/preview
rm -rf /app/default.conf
exec "$@"