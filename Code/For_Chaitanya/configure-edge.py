"""Create Chaitanya's Phase 1 nginx config using the confirmed LAN addresses."""
from pathlib import Path
import re
import subprocess

root = Path(__file__).resolve().parent
for path in [root / 'runtime/logs', root / 'runtime/private', root / 'public']:
    path.mkdir(parents=True, exist_ok=True)


def q(path):
    return '"' + str(path).replace('\\', '\\\\').replace('"', '\\"') + '"'


info = subprocess.run(['nginx', '-V'], capture_output=True, text=True, check=True)
version_text = info.stdout + info.stderr
match = re.search(r'nginx/(\d+)\.(\d+)\.(\d+)', version_text)
version = tuple(map(int, match.groups())) if match else (0, 0, 0)
http2_supported = '--with-http_v2_module' in version_text
listen = 'listen 8443 ssl;'
http2 = ''
if http2_supported:
    if version >= (1, 25, 1):
        http2 = 'http2 on;'
    else:
        listen = 'listen 8443 ssl http2;'

(root / 'nginx.conf').write_text(f'''worker_processes 1;
pid {q(root / 'runtime/nginx.pid')};
error_log {q(root / 'runtime/logs/error.log')} info;
events {{ worker_connections 256; }}
http {{
    log_format cn '$time_iso8601 client=$remote_addr "$request" status=$status '
                  'upstream=$upstream_addr upstream_status=$upstream_status';
    access_log {q(root / 'runtime/logs/access.log')} cn;
    upstream cn_backends {{
        server 10.7.2.89:3001 max_fails=1 fail_timeout=5s;
        server 10.7.6.93:3002 max_fails=1 fail_timeout=5s;
    }}
    server {{
        listen 8080;
        server_name app.team1.test api.team1.test;
        return 301 https://$host:8443$request_uri;
    }}
    server {{
        {listen}
        {http2}
        server_name app.team1.test api.team1.test;
        ssl_certificate {q(root / 'public/edge.crt')};
        ssl_certificate_key {q(root / 'runtime/private/edge.key')};
        ssl_protocols TLSv1.2 TLSv1.3;
        add_header X-Edge Chaitanya always;
        location / {{
            proxy_pass http://cn_backends;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header Connection "";
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_connect_timeout 3s;
            proxy_read_timeout 10s;
            proxy_next_upstream error timeout http_502 http_503 http_504;
            proxy_next_upstream_tries 2;
        }}
    }}
}}
''')
print('Configured Windows A at 10.7.2.89:3001 and Anuj B at 10.7.6.93:3002.')
print('HTTP/2 enabled:', http2_supported)
