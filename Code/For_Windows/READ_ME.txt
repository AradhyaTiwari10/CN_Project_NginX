WINDOWS TEAMMATE - PHASE 1 BACKEND A

1. Receive the actual For_Windows.zip file and choose Extract All.
   Do not run the files from inside the unopened zip archive.
2. Double-click start-backend-a.cmd inside the extracted For_Windows folder.
3. Leave the window open. Expect:
   Backend A: http://0.0.0.0:3001
4. Open a second Command Prompt and run:
   curl.exe -i http://127.0.0.1:3001/api/status
   Expect X-Backend: A and JSON with backend A and status ok.
5. Send both outputs to your teammate.

The project uses Wi-Fi IPv4 10.7.2.89, not the Ethernet 2 address 192.168.56.1.
Python 3.13.14 was reported installed. If Windows requests permission for
Python network access, note the prompt and your current network profile;
the running backend must accept team connections on TCP port 3001.
Do not disable Windows Firewall. If remote access fails after the local
test passes, report the error so a narrow project rule can be configured.

Control-C stops the backend. Phase 2 is outside the current scope.
