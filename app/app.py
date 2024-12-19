from http.server import HTTPServer, BaseHTTPRequestHandler


class StepFinalHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"OK")
        else:
            self.send_response(404)


if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), StepFinalHandler)
    print("StepFinalProject v 1.0.0")
    server.serve_forever()
