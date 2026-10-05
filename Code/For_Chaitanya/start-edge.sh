#!/bin/sh
set -eu
cd -- "$(dirname -- "$0")"
nginx -t -p "$PWD/runtime/" -c "$PWD/nginx.conf"
printf '%s\n' 'Starting HTTPS edge on port 8443. Keep this Terminal open.'
exec nginx -p "$PWD/runtime/" -c "$PWD/nginx.conf" -g 'daemon off;'
