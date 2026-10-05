PHASE 1 MAC CLIENT SETUP - YOUR MAC, CHAITANYA AND ANUJ

Run this only after the backend/edge services are running and while the DNS
server on 10.7.15.68 stays running. Each person uses their own extracted copy.

1. Extract Mac_Client_Setup.zip.
2. Open Terminal, type "cd " with a space, drag the extracted Mac_Client_Setup
   folder into Terminal, and press Return.
3. Run: bash configure-client.sh
4. Enter your own Mac login password locally when sudo asks.
5. Send the full command output. Expect DNS SERVER 10.7.15.68, answer
   10.7.22.151, and HTTPS HTTP/1.1 200 OK with X-Backend A or B.
6. Open https://app.team1.test:8443/ in a browser and confirm no certificate
   warning. Also verify https://api.team1.test:8443/api/status.

This script trusts only the fingerprint-verified project certificate for SSL
and replaces the chosen network service's DNS list with 10.7.15.68. It saves
the prior DNS settings. The default service is Wi-Fi. If your service has a
different name, provide it as a quoted argument.

The final curl check uses normal name resolution and system certificate trust;
it does not use -k, --resolve, or --cacert.

Keep this folder's original-dns.txt and original-service.txt on the machine
where they were created. Do not send your populated backup folder to another
teammate. Send the clean zip instead.

After the project demonstration, run: bash restore-client.sh
This restores that Mac's saved DNS settings and removes project SSL trust.
