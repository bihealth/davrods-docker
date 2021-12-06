FROM centos:7 as main

LABEL org.opencontainers.image.authors="mikko.nieminen@bih-charite.de"
LABEL org.opencontainers.image.source https://github.com/bihealth/davrods-docker

# Environment variables for container runtime
ENV IRODS_PKG_VERSION=4.2.8-1 \
    IRODS_HOST_NAME=localhost \
    IRODS_ZONE_PORT=1247 \
    IRODS_ZONE_NAME=sodarZone \
    IRODS_SSL_VERIFY_SERVER=none \
    IRODS_SSL_CA_CERT_PATH=/etc/httpd/irods/irods_server.crt \
    IRODS_AUTHENTICATION_SCHEME=native \
    IRODS_CLIENT_SERVER_NEGOTIATION=off \
    IRODS_CLIENT_SERVER_POLICY=CS_NEG_REFUSE \
    DAVRODS_PKG_VERSION=4.2.8_1.5.0 \
    DAVRODS_ENABLE_TICKETS=0 \
    DAVRODS_AUTH_NAME="Please log in."

# Install repositories and install latest updates
RUN yum install -y epel-release && \
    rpm --import https://packages.irods.org/irods-signing-key.asc && \
    curl https://packages.irods.org/renci-irods.yum.repo \
        > /etc/yum.repos.d/renci-irods.yum.repo && \
    yum clean all && \
    yum upgrade -y

# Install required packages
RUN yum -y install wget git zlib httpd

# Install j2cli for templating
RUN yum -y install python-pip python-jinja2 python-yaml
RUN pip install j2cli

# Install iRODS runtime and icommands
RUN yum install -y \
    irods-runtime-${IRODS_PKG_VERSION} \
    irods-icommands-${IRODS_PKG_VERSION}

# Install Davrods
RUN wget https://github.com/UtrechtUniversity/davrods/releases/download/${DAVRODS_PKG_VERSION}/davrods-${DAVRODS_PKG_VERSION}-1.rpm
RUN rpm -ivh davrods-${DAVRODS_PKG_VERSION}-1.rpm
RUN mv /etc/httpd/conf.d/davrods-vhost.conf /etc/httpd/conf.d/davrods-vhost.conf.org

# Cleanup RPMs
RUN yum clean all && rm -rf *.rpm

# Copy entrypoint and template files
COPY docker-entrypoint.sh \
     templates/davrods-vhost.conf.j2 \
     templates/irods_environment.json.j2 /
RUN chmod +x /docker-entrypoint.sh

RUN sed -ri \
        -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
        -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
        "/etc/httpd/conf/httpd.conf"

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["davrods-start"]
