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
    echo " Copying file...."
    # ln -sf /app/drupal/* /var/www/
    rsync -aP -f'+ /*' -f'+ *' /app/drupal/* /var/www/
    # ln -sf /app/drupal/* /var/www/
    chown -R nginx:nginx /var/www/
    cp /var/www/sites/default/default.settings.php /var/www/sites/default/settings.php
    chmod -R 777 /var/www/sites/default/
fi
cp /app/default.conf /etc/nginx/conf.d/default.conf
nginx -s reload
rm -rf /var/preview
rm -rf /app/default.conf
exec "$@"