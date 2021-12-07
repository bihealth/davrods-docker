#!/bin/bash

if [[ "$1" == "davrods-start" ]]; then
    # Remote possible incorrectly shut down server on restart
    rm -rf /run/httpd/* /tmp/httpd*

    echo "Set up iRODS environment file.."
    j2 -o /etc/httpd/irods/irods_environment.json --undefined /irods_environment.json.j2
    chmod 0644 /etc/httpd/irods/irods_environment.json

    echo "Set up Davrods vhost config.."
    j2 -o /etc/httpd/conf.d/davrods-vhost.conf --undefined /davrods-vhost.conf.j2
    chmod 0644 /etc/httpd/conf.d/davrods-vhost.conf
    cat /etc/httpd/conf.d/davrods-vhost.conf # DEBUG

    echo "Copy default theme templates if not yet in volume.."
    rsync -av --ignore-existing \
        /etc/httpd/irods/head.html \
        /etc/httpd/irods/header.html \
        /etc/httpd/irods/footer.html \
        /etc/httpd/irods/theme/

    echo "Start Apache daemon.."
    exec /usr/sbin/apachectl -DFOREGROUND

    # this script must end with a persistent foreground process
    tail -F /var/log/httpd/access.log /var/log/httpd/error.log |awk '/^==> / {a=substr($0, 5, length-8); next} {print a":"$0}'

fi
