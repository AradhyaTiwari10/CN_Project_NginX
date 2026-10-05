#!/bin/sh
set -eu
cd -- "$(dirname -- "$0")"
printf '%s\n' 'Starting Anuj Backend B on port 3002. Keep this Terminal open.'
exec python3 backend.py --name B --port 3002
