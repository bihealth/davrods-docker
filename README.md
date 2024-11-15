# Dockerized Davrods

This is a dockerized version of [Davrods](https://github.com/UtrechtUniversity/davrods) tailored for use within Core Unit Bioinformatics at Berlin Institute of Health.
It is based on the [RIT-Davrods](https://github.com/MaastrichtUniversity/rit-davrods) Docker image developed at the Maastricht University.

This image allows for configuring Davrods and iRODS via environment variables. Optional support for read-only anonymous ticket access is also included.

Note that in our use case, secure connections are handled by Traefik in the
docker-compose environment. Thus we configure the host internally as HTTP.

This version supports iRODS v4.3.3 and may not be compatible with older or newer server versions.

## Building

Use the provided `build.sh` script to build the image.

## Commands

The following commands are available.
If you specify anything else then the startup script will `exec` this command (e.g., `bash`).

- `davrods-start` (default) -- Start Davrods

## Environment Variables

| Variable name                       | Default Value                     |
|-------------------------------------|-----------------------------------|
| IRODS_PKG_VERSION                   | 4.3.3                             |
| IRODS_HOST_NAME                     | localhost                         |
| IRODS_ZONE_PORT                     | 1247                              |
| IRODS_ZONE_NAME                     | sodarZone                         |
| IRODS_SSL_VERIFY_SERVER             | none                              |
| IRODS_SSL_CA_CERT_PATH              | /etc/httpd/irods/irods_server.crt |
| IRODS_CLIENT_SERVER_NEGOTIATION     | off                               |
| IRODS_CLIENT_SERVER_POLICY          | CS_NEG_REFUSE                     |
| DAVRODS_VERSION                     | 1.5.1                             |
| DAVRODS_IRODS_VERSION (1)           | 4.2.12                            |
| DAVRODS_ENABLE_TICKETS              | 0                                 |
| DAVRODS_AUTH_NAME                   | "Please log in."                  |
| DAVRODS_AUTH_SCHEME (2)             | native                            |
| DAVRODS_LOG_LEVEL (3)               | info                              |

1. This should be the iRODS version set in the most recent build of Davrods we're modifying.
2. Until Davrods switches to using the new iRODS client plugins, this may require a different value than your iCommands auth scheme.
3. Set to `debug` to see iRODS client error messages in your logs.

## Custom Theme

To introduce your own theme, use the `/etc/httpd/irods/theme/` volume and copy or overwrite the Davrods HTML template files.
