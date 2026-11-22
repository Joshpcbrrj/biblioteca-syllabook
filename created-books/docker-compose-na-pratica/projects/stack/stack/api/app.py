import os
import socket
from http.server import BaseHTTPRequestHandler, HTTPServer

import psycopg


def ler_senha():
    # o segredo chega como arquivo; strip() tira a quebra de linha do fim
    with open(os.environ["DB_SENHA_FILE"]) as arquivo:
        return arquivo.read().strip()


# o endereço do banco vem do compose.yaml: o nome do serviço
CONEXAO = {
    "host": os.environ.get("DB_HOST", "db"),
    "port": os.environ.get("DB_PORTA", "5432"),
    "user": "postgres",
    "password": ler_senha(),
    "connect_timeout": 3,
}


class Contador(BaseHTTPRequestHandler):
    def do_GET(self):
        # rota de saúde: responde sem tocar no banco nem contar visita
        if self.path == "/saude":
            self.responder(200, "ok\n")
            return
        try:
            # uma conexão por acesso: a API não cai se o banco sumir
            with psycopg.connect(**CONEXAO) as banco:
                banco.execute(
                    "CREATE TABLE IF NOT EXISTS visitas (id serial PRIMARY KEY)"
                )
                linha = banco.execute(
                    "INSERT INTO visitas DEFAULT VALUES RETURNING id"
                ).fetchone()
            # o nome do contêiner mostra qual réplica atendeu
            replica = socket.gethostname()
            texto = f"Visita número {linha[0]} (réplica {replica})\n"
            self.responder(200, texto)
        except psycopg.OperationalError as erro:
            self.responder(503, f"Sem banco: {erro}\n")

    def responder(self, status, texto):
        corpo = texto.encode()
        self.send_response(status)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(corpo)


# 0.0.0.0 para aceitar conexões vindas de fora do contêiner
HTTPServer(("0.0.0.0", 8000), Contador).serve_forever()
