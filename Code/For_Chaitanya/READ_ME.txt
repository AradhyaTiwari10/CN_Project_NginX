CHAITANYA - PHASE 1 HTTPS EDGE

1. Finish: brew install nginx openssl@3
2. Receive the actual For_Chaitanya.zip and extract it.
3. Open Terminal. Type "cd " (with a trailing space), drag the extracted
   For_Chaitanya folder into Terminal, and press Return.
4. Run: bash prepare-edge.sh
5. Send the preparation output, including nginx's configuration test result.
6. Run: bash start-edge.sh
   Keep that Terminal open. No sudo is needed for ports 8080 and 8443.
7. Send only the public/edge.crt file to your teammate and Anuj for trust setup.
   Keep runtime/private/edge.key private and out of the submission zip.

If you move the extracted folder later, rerun prepare-edge.sh so nginx's
absolute paths are regenerated. Existing keys/certificates are preserved.

The addresses are:
  Team DNS: 10.7.15.68
  Your edge: 10.7.22.151, HTTPS TCP 8443
  Windows A: 10.7.2.89, HTTP TCP 3001
  Anuj B: 10.7.6.93, HTTP TCP 3002

Once backends are running, test in a second Terminal:
  curl -i --connect-timeout 5 --max-time 10 http://10.7.2.89:3001/api/status
  curl -i --connect-timeout 5 --max-time 10 http://10.7.6.93:3002/api/status

The service URL is https://app.team1.test:8443/api/status.
Normal hostname access also requires the pending client DNS and certificate
trust setup. Do not use curl -k as demonstration evidence.
Control-C stops the foreground edge. This package is Phase 1 only.
