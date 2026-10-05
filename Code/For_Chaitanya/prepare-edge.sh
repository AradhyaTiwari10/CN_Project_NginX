#!/bin/sh
set -eu
cd -- "$(dirname -- "$0")"
if ! command -v nginx >/dev/null 2>&1; then
    printf '%s\n' 'Finish brew install nginx openssl@3 first.'
    exit 1
fi
CN_OPENSSL="$(brew --prefix openssl@3)/bin/openssl"
if [ ! -x "$CN_OPENSSL" ]; then
    printf '%s\n' 'Finish brew install openssl@3 first.'
    exit 1
fi
python3 configure-edge.py
umask 077
if [ ! -f runtime/private/edge.key ] && [ ! -f public/edge.crt ]; then
    "$CN_OPENSSL" req -x509 -newkey rsa:2048 -sha256 -nodes -days 30 -config certificate.cnf -keyout runtime/private/edge.key -out public/edge.crt
elif [ ! -f runtime/private/edge.key ] || [ ! -f public/edge.crt ]; then
    printf '%s\n' 'Only one certificate/key file exists. Stop and report this rather than overwriting it.'
    exit 1
fi
chmod 600 runtime/private/edge.key
"$CN_OPENSSL" x509 -in public/edge.crt -noout -subject -dates -fingerprint -sha256
nginx -t -p "$PWD/runtime/" -c "$PWD/nginx.conf"
printf '%s\n' 'Ready. Run: bash start-edge.sh' 'Send only public/edge.crt to the client Macs. Keep runtime/private/edge.key private.'
