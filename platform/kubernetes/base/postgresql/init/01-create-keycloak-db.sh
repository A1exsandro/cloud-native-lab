#!/bin/bash
set -e

psql \
  --username "$POSTGRES_USER" \
  --dbname "$POSTGRES_DB" \
  --set=keycloak_password="$KEYCLOAK_DB_PASSWORD" \
  <<'SQL'
CREATE ROLE keycloak_user
    WITH LOGIN
    PASSWORD :'keycloak_password';

CREATE DATABASE keycloak
    OWNER keycloak_user;

GRANT ALL PRIVILEGES ON DATABASE keycloak TO keycloak_user;
SQL
