#!/bin/bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
CN_SERVICE="${1:-Wi-Fi}"
CN_EXPECTED='DA003CF4A7A23C8538F6C704E6564B47EF873C0FC209CCBA6014BD0B46A4FEDA'
CN_ACTUAL=$(/usr/bin/openssl x509 -in edge.crt -noout -fingerprint -sha256 | /usr/bin/awk -F= '{print $2}' | /usr/bin/tr -d ':\r\n' | /usr/bin/tr '[:lower:]' '[:upper:]')
if [ "$CN_ACTUAL" != "$CN_EXPECTED" ]; then
    printf '%s\n' 'STOP: certificate fingerprint does not match Chaitanya.'
    exit 1
fi
if [ -f original-service.txt ]; then
    if [ "$(cat original-service.txt)" != "$CN_SERVICE" ]; then
        printf '%s\n' 'STOP: this folder contains a backup for a different network service.'
        exit 1
    fi
else
    /usr/sbin/networksetup -getdnsservers "$CN_SERVICE" > original-dns.txt
    printf '%s\n' "$CN_SERVICE" > original-service.txt
fi
printf '%s\n' 'Original DNS settings are saved in original-dns.txt.'
printf '%s\n' 'This trusts the verified project certificate for SSL and sets Wi-Fi DNS to 10.7.15.68.'
sudo -v
sudo /usr/bin/security add-trusted-cert -d -r trustRoot -p ssl -k /Library/Keychains/System.keychain "$PWD/edge.crt"
sudo /usr/sbin/networksetup -setdnsservers "$CN_SERVICE" 10.7.15.68
sudo /usr/bin/dscacheutil -flushcache
sudo /usr/bin/killall -HUP mDNSResponder
printf '\n%s\n' 'Checking normal DNS resolution:'
/usr/bin/dig app.team1.test +time=5 +tries=1
/usr/bin/dig api.team1.test +time=5 +tries=1
printf '\n%s\n' 'Checking native resolver:'
/usr/bin/dscacheutil -q host -a name app.team1.test
printf '\n%s\n' 'Checking HTTPS using normal DNS and system certificate trust:'
/usr/bin/curl --noproxy '*' --http1.1 --fail-with-body -i --connect-timeout 5 --max-time 20 https://app.team1.test:8443/api/status
