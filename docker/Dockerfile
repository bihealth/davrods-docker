# check=skip=SecretsUsedInArgOrEnv

# Build Stage -----------------------------------------------------------------

# NOTE: Adapted from https://github.com/MaastrichtUniversity/rit-davrods
FROM ubuntu:22.04 AS build

ARG DEBIAN_FRONTEND=noninteractive
ARG IRODS_PKG_VERSION="4.3.3"
ARG DAVRODS_IRODS_VERSION="4.2.12"

RUN apt-get update
RUN apt-get install -y apache2-dev git wget cmake

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ jammy main" | tee /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y \
    irods-runtime=${IRODS_PKG_VERSION} \
    irods-dev=${IRODS_PKG_VERSION}

# Clone the Utrecht University Davrods repository
WORKDIR /tmp
RUN git clone https://github.com/UtrechtUniversity/davrods.git
RUN mkdir -p /tmp/davrods/build

# Update iRODS version in CMakeLists file
RUN sed -i 's/${DAVRODS_IRODS_VERSION}/${IRODS_PKG_VERSION}/g' /tmp/davrods/CMakeLists.txt
# Update TTL to get around password_min_time error
RUN sed -i 's/rods_auth_ttl = 1/rods_auth_ttl = 336/g' /tmp/davrods/src/config.c
# Update password length limit to enable token auth
RUN sed -i 's/strlen(password) > 63/strlen(password) > 128/g' /tmp/davrods/src/auth.c
# Workaround proposed by iRODS team in https://github.com/UtrechtUniversity/davrods/issues/35
RUN sed -i 's/module AP_MODULE_DECLARE_DATA davrods_module;/extern module AP_MODULE_DECLARE_DATA davrods_module;/g' /tmp/davrods/src/mod_davrods.h
# Build Davrods for iRODS version
WORKDIR /tmp/davrods/build
RUN cmake ..
RUN make

# Main Stage ------------------------------------------------------------------

FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="mikko.nieminen@bih-charite.de"
LABEL org.opencontainers.image.source="https://github.com/bihealth/davrods-docker"

ARG DEBIAN_FRONTEND=noninteractive
ARG IRODS_PKG_VERSION="4.3.3"
ARG DAVRODS_VERSION="1.5.1"
ARG DAVRODS_IRODS_VERSION="4.2.12"

# Environment variables for container runtime
# TODO: Update as needed
ENV IRODS_PKG_VERSION=$IRODS_PKG_VERSION \
    IRODS_HOST_NAME=localhost \
    IRODS_ZONE_PORT=1247 \
    IRODS_ZONE_NAME=sodarZone \
    IRODS_SSL_VERIFY_SERVER=none \
    IRODS_SSL_CA_CERT_PATH=/etc/apache2/irods/irods_server.crt \
    IRODS_CLIENT_SERVER_NEGOTIATION=off \
    IRODS_CLIENT_SERVER_POLICY=CS_NEG_REFUSE \
    DAVRODS_ENABLE_TICKETS=0 \
    DAVRODS_AUTH_NAME="Please log in." \
    DAVRODS_AUTH_SCHEME=native \
    DAVRODS_LOG_LEVEL=info

# Install dependencies
RUN apt-get update
RUN apt-get install -y wget gnupg2 git rsync apache2 vim

# Install iRODS runtime and icommands
# We install the version that is currently running in acc/prod
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.irods.org/apt/ jammy main" | tee /etc/apt/sources.list.d/renci-irods.list \
    && apt-get update \
    && apt-get install -y \
    irods-runtime=${IRODS_PKG_VERSION} \
    irods-icommands=${IRODS_PKG_VERSION}

# Install j2cli for templating
# TODO: Upgrade to Python3?
RUN apt-get install -y python3-pip python3-jinja2 python3-yaml
RUN pip install j2cli

# Install Davrods
RUN wget https://github.com/UtrechtUniversity/davrods/releases/download/${DAVRODS_IRODS_VERSION}_${DAVRODS_VERSION}/davrods-${DAVRODS_IRODS_VERSION}-${DAVRODS_VERSION}.deb -O /tmp/davrods.deb \
    && dpkg -i --force-depends /tmp/davrods.deb

# Backup original vhost conf
RUN mv /etc/apache2/sites-available/davrods-vhost.conf /etc/apache2/sites-available/davrods-vhost.conf.org

# Copy entrypoint and template files
COPY docker-entrypoint.sh \
     templates/davrods-vhost.conf.j2 \
     templates/irods_environment.json.j2 /
RUN chmod +x /docker-entrypoint.sh

RUN sed -ri \
    -e 's!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g' \
    -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' \
    "/etc/apache2/apache2.conf"

# Enable davrods in Apache2
RUN a2enmod davrods
# Add customized davrods executable to be used with iRODS runtime
COPY --from=build /tmp/davrods/build/mod_davrods.so /usr/lib/apache2/modules/mod_davrods.so

# Set up theme dir and volume
VOLUME "/etc/apache2/irods/theme"

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["davrods-start"]
