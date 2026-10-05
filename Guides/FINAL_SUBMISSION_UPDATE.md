# Final submission update — 5 October 2026

Team **NginX**, Section **E**. Read this alongside the original report, which remains a historical record of the first testing session.

- Final DNS configuration replaces the two `host-record=` entries with `address=` entries and explicitly adds `interface=en0`. Both configuration copies in this repository match the saved terminal output. Earlier screenshots legitimately show the previous working configuration.
- Anuj repeated normal client DNS after selecting `10.7.15.68`; both names returned `10.7.22.151` with TTL 30 and NOERROR. The app query ID was 52035, query time 1589 ms, at 23:21:26 IST on 5 October. See the final-form screenshot.
- Later HTTPS root request returned HTTP/2 200 at 17:31:10 GMT on 5 October, with backend A and successful certificate verification using TLS 1.3. The older report capture used TLS 1.2 deliberately.
- Six newer responses at 17:25:58–59 GMT alternate B/A/B/A/B/A, all 200. `/cache` HEAD returns 200, public/max-age=60 and the shared ETag at 17:26:39 GMT.
- Selected form failure: wrong port 8444. Before at 18:03:13 GMT: 200 from B. Wrong port: DNS resolves the edge, TCP connection refused, curl exit 7, 1204 ms. After at 18:03:14 GMT: correct port 8443 returns 200 from A. These times/results are transcribed from user-provided terminal output, not a new live run by the repository preparer.
- The final form requires a GitHub repository and five-minute video, despite the earlier guide being based only on the original PDF. Video status and access must be checked separately. No video is included here.
- Three Macs plus one Windows laptop are accurately disclosed; no faculty exception or dropdown category approval is claimed.

Full service setup, commands, names and enrollment numbers are in the root README.
