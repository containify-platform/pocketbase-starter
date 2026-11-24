#!/bin/sh
# Start PocketBase on every address (IPv4 and IPv6). With PB_ADMIN_EMAIL and
# PB_ADMIN_PASSWORD set, that superuser is created (or its password reset)
# first, so there's no installer link to find in the logs.
set -e
cd /pb
if [ -n "$PB_ADMIN_EMAIL" ] && [ -n "$PB_ADMIN_PASSWORD" ]; then
  pocketbase superuser upsert "$PB_ADMIN_EMAIL" "$PB_ADMIN_PASSWORD" --dir=/pb/pb_data >/dev/null
fi
exec pocketbase serve --http="[::]:${PORT:-8090}" --dir=/pb/pb_data \
  --migrationsDir=/pb/pb_migrations --hooksDir=/pb/pb_hooks --publicDir=/pb/pb_public "$@"
