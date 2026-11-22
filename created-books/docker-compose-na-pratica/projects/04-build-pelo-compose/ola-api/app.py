from http.server import BaseHTTPRequestHandler, HTTPServer

VERSAO = "1"


class Ola(BaseHTTPRequestHandler):
    def do_GET(self):
        corpo = f"Olá do Compose! versão {VERSAO}\n".encode()
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(corpo)


# 0.0.0.0 para aceitar conexões vindas de fora do contêiner
HTTPServer(("0.0.0.0", 8000), Ola).serve_forever()
