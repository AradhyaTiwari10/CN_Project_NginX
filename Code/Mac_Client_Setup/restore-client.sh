#!/bin/bash
set -euo pipefail
cd -- "$(dirname -- "$0")"
if [ ! -f original-service.txt ] || [ ! -f original-dns.txt ]; then
    printf '%s\n' 'No saved DNS settings found in this folder. Stop and report this.'
    exit 1
fi
sudo -v
python3 - <<'PY'
import ipaddress, subprocess
from pathlib import Path
service = Path('original-service.txt').read_text().strip()
addresses = []
for line in Path('original-dns.txt').read_text().splitlines():
    try:
        ipaddress.ip_address(line.strip())
        addresses.append(line.strip())
    except ValueError:
        pass
subprocess.run(['sudo','/usr/sbin/networksetup','-setdnsservers',service,*(addresses or ['Empty'])],check=True)
PY
sudo /usr/bin/security remove-trusted-cert -d "$PWD/edge.crt"
sudo /usr/bin/dscacheutil -flushcache
sudo /usr/bin/killall -HUP mDNSResponder
printf '%s\n' 'Restored the saved DNS settings and removed project certificate trust.'
