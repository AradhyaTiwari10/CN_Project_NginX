"""Small IPv4 HTTP backend for the four-laptop Computer Networks project."""
import argparse
import hashlib
import json
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlsplit

CACHE_BODY = b'{"message":"Same cacheable representation on both backends","version":1}\n'
ETAG = '"' + hashlib.sha256(CACHE_BODY).hexdigest() + '"'


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def do_GET(self):
        self.respond()

    def do_HEAD(self):
        self.respond(head_only=True)

    def respond(self, head_only=False):
        path = urlsplit(self.path).path
        backend = self.server.backend_name
        if path == "/cache":
            # GET/HEAD If-None-Match uses weak comparison.
            tags = [x.strip().removeprefix("W/") for x in
                    self.headers.get("If-None-Match", "").split(",")]
            unchanged = ETAG in tags or "*" in tags
            self.send_response(304 if unchanged else 200)
            self.send_header("X-Backend", backend)
            self.send_header("Cache-Control", "public, max-age=60")
            self.send_header("ETag", ETAG)
            if not unchanged:
                self.send_header("Content-Type", "application/json")
                self.send_header("Content-Length", str(len(CACHE_BODY)))
            self.end_headers()
            if not unchanged and not head_only:
                self.wfile.write(CACHE_BODY)
            return
        status = 200 if path in ("/", "/api/status") else 404
        payload = {"backend": backend, "status": "ok" if status == 200 else "not_found"}
        body = (json.dumps(payload) + "\n").encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("X-Backend", backend)
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        if not head_only:
            self.wfile.write(body)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--name", required=True, choices=["A", "B"])
    parser.add_argument("--port", required=True, type=int)
    parser.add_argument("--bind", default="0.0.0.0")
    args = parser.parse_args()
    server = ThreadingHTTPServer((args.bind, args.port), Handler)
    server.backend_name = args.name
    print(f"Backend {args.name}: http://{args.bind}:{args.port}", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
