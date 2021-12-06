# Dockerized Davrods

This is a dockerized version of [Davrods](https://github.com/UtrechtUniversity/davrods) tailored for use within Core Unit Bioinformatics at Berlin Institute of Health.
It is based on the [RIT-Davrods](https://github.com/MaastrichtUniversity/rit-davrods) Docker image developed at the Maastricht University.

This image allows for configuring Davrods and iRODS via environment variables. Optional support for read-only anonymous ticket access is also included.

Note that in our use case, secure connections are handled by Traefik in the
docker-compose environment. Thus we configure the host internally as HTTP.

## Building

Use the provided `build.sh` script to build the image.

## Commands

The following commands are available.
If you specify anything else then the startup script will `exec` this command (e.g., `bash`).

- `davrods-start` (default) -- Start Davrods

## Environment Variables

| Variable name                       | Default Value                     |
|-------------------------------------|-----------------------------------|
| IRODS_PKG_VERSION                   | 4.2.8-1                           |
| IRODS_HOST_NAME                     | localhost                         |
| IRODS_ZONE_PORT                     | 1247                              |
| IRODS_ZONE_NAME                     | sodarZone                         |
| IRODS_SSL_VERIFY_SERVER             | none                              |
| IRODS_SSL_CA_CERT_PATH              | /etc/httpd/irods/irods_server.crt |
| IRODS_AUTHENTICATION_SCHEME         | native                            |
| IRODS_CLIENT_SERVER_NEGOTIATION     | off                               |
| IRODS_CLIENT_SERVER_POLICY          | CS_NEG_REFUSE                     |
| DAVRODS_PKG_VERSION                 | 4.2.8_1.5.0                       |
| DAVRODS_ENABLE_TICKETS              | 0                                 |
| DAVRODS_AUTH_NAME                   | "Please log in."                  |
