ANUJ - PHASE 1 BACKEND B

1. Receive the actual For_Anuj.zip file from your teammate and extract it.
2. Open Terminal. Type "cd " (with a trailing space), drag the extracted
   For_Anuj folder from Finder into Terminal, then press Return.
3. Run:
   bash start-backend-b.sh
4. Leave this Terminal open. Expect:
   Backend B: http://0.0.0.0:3002
5. In a second Terminal, test:
   curl -i http://127.0.0.1:3002/api/status
   Expect X-Backend: B and JSON with backend B and status ok.

If macOS asks about incoming Python connections, allow the project service.
Send the startup output and the second Terminal's result to your teammate.
The current LAN address is 10.7.6.93. Report any IP change before testing.
Control-C stops the backend. Phase 2 is outside the current scope.
