from http.server import HTTPServer, BaseHTTPRequestHandler

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.end_headers()
            html_content = """
                <!DOCTYPE html>
                <html>
                <head>
                    <title>StepFinalProject</title>
                    <style>
                        body {{
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh;
                            margin: 0;
                            font-family: Arial, sans-serif;
                            background-color: #f4f4f9;
                        }}
                        h1 {{
                            color: #333;
                        }}
                    </style>
                </head>
                <body>
                    <h1>StepFinalProject v 4.0.1</h1>
                </body>
                </html>
            """
            self.wfile.write(html_content.encode("utf-8"))
        else:
            self.send_response(404)

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), SimpleHandler)
    print("StepFinalProject v 4.0.1")
    server.serve_forever()
