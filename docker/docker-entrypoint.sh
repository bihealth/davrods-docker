#!/bin/bash

if [[ "$1" == "davrods-start" ]]; then

    echo "Set up iRODS environment file.."
    j2 -o /etc/apache2/irods/irods_environment.json --undefined /irods_environment.json.j2
    chmod 0644 /etc/apache2/irods/irods_environment.json

    echo "Set up Davrods vhost config.."
    j2 -o /etc/apache2/sites-available/davrods-vhost.conf --undefined /davrods-vhost.conf.j2
    chmod 0644 /etc/apache2/sites-available/davrods-vhost.conf

    # Make log directory
    mkdir -p /var/log/apache2
    touch /var/log/apache2/apache.access.log
    touch /var/log/apache2/apache.error.log
    touch /var/log/apache2/davrods.access.log
    touch /var/log/apache2/davrods.error.log

    # Remove default webpage and enable davrods
    rm -f /etc/apache2/sites-enabled/*
    ln -s /etc/apache2/sites-available/davrods-vhost.conf /etc/apache2/sites-enabled/davrods-vhost.conf

    echo "Copy default theme templates if not yet in volume.."
    rsync -av --ignore-existing \
        /etc/apache2/irods/head.html \
        /etc/apache2/irods/header.html \
        /etc/apache2/irods/footer.html \
        /etc/apache2/irods/theme/

    echo "Start Apache daemon.."
    /etc/init.d/apache2 start

    # this script must end with a persistent foreground process
    tail -Fq -n0 /var/log/apache2/access.log /var/log/apache2/error.log \
        /var/log/apache2/davrods.access.log /var/log/apache2/davrods.error.log

fi
