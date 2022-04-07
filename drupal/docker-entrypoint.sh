#!/bin/bash

set +x
if [ -f "/var/www/composer.json" ]
then
    cd /var/www/
    composer install
    echo "Dependencies updated"
else  
    cd /var/www
    mv /app/drupal-* /app/drupal
    # ln -s /app/drupal/* /var/www/
    #rsync -aP -f'+ /*' -f'+ *' /app/drupal/* /var/www/
    echo >&2 "Drupal not found in $(pwd) - Create apps please patience..."
    tar cf - --one-file-system -C /app/drupal/ . | tar xf -
    # cp /var/www/sites/default/default.settings.php /var/www/sites/default/settings.php
    # chmod -R 777 /var/www/sites/default/
    # composer create-project drupal/recommended-project .
    cp /app/settings.php /var/www/sites/default/settings.php
    chmod -R 755 /var/www/
fi
if [[ {BACK_END} = nginx ]] ;
then
    cp /app/default.conf /etc/nginx/conf.d/default.conf
else
    cp /app/httpd.conf /etc/apache2/httpd.conf
fi
rm -rf /var/preview
if [[ {BACK_END} = nginx ]]  ; 
then
    nginx -s reload
else
    httpd -k graceful
fi
if [[ {BACK_END} = nginx  ]] ;
then
    chown -R nobody:nobody /var/www
else
    chown -R nobody:nobody /var/www
fi

rm -rf /var/preview
rm -rf /app/default.conf
exec "$@"