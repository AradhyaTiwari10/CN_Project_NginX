#!/bin/sh
set -eu
CN_DNS_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CN_DNS_BIN="/opt/homebrew/opt/dnsmasq/sbin/dnsmasq"
"$CN_DNS_BIN" --test --conf-file="$CN_DNS_DIR/dnsmasq.conf"
exec "$CN_DNS_BIN" --no-daemon --conf-file="$CN_DNS_DIR/dnsmasq.conf"
