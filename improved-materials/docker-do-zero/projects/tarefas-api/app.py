# API de tarefas do livro "Docker do zero" (versão 1.1).
# As tarefas agora moram no PostgreSQL, e não mais na memória.
import json
import os
import signal
import sys
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import psycopg

# tudo que muda entre máquinas vem do ambiente (ENV no Dockerfile
# ou -e no docker run), e não do código
ENDERECO = os.environ.get("ENDERECO", "0.0.0.0")
PORTA = int(os.environ.get("PORTA", "8000"))
VERSAO = os.environ.get("APP_VERSAO", "dev")

BANCO = {
    "host": os.environ.get("DB_HOST", "banco"),
    "port": os.environ.get("DB_PORT", "5432"),
    "dbname": os.environ.get("DB_NAME", "tarefas"),
    "user": os.environ.get("DB_USER", "postgres"),
    "password": os.environ.get("DB_PASSWORD", ""),
    "connect_timeout": 3,
}


def conectar():
    # uma conexão por pedido: simples de entender; o commit
    # acontece ao sair do bloco "with"
    return psycopg.connect(**BANCO)


def preparar_banco(tentativas=30):
    # o banco pode demorar a subir: tenta por até 30 segundos
    # antes de desistir, em vez de cair na primeira recusa
    for n in range(1, tentativas + 1):
        try:
            with conectar() as conexao:
                conexao.execute(
                    "CREATE TABLE IF NOT EXISTS tarefas ("
                    "id serial PRIMARY KEY, titulo text NOT NULL, "
                    "feita boolean DEFAULT false)")
            print("Banco pronto", flush=True)
            return
        except psycopg.OperationalError as erro:
            motivo = str(erro).strip().splitlines()[0][:100]
            print(f"Aguardando o banco ({n}/{tentativas}): {motivo}",
                  flush=True)
            time.sleep(1)
    sys.exit("O banco não respondeu a tempo")


class Api(BaseHTTPRequestHandler):
    def enviar(self, codigo, conteudo):
        corpo = json.dumps(conteudo, ensure_ascii=False).encode("utf-8")
        self.send_response(codigo)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(corpo)))
        self.end_headers()
        self.wfile.write(corpo)

    def do_GET(self):
        try:
            if self.path == "/saude":
                with conectar() as conexao:
                    conexao.execute("SELECT 1")
                self.enviar(200, {"status": "ok", "versao": VERSAO,
                                  "banco": "ok"})
            elif self.path == "/tarefas":
                with conectar() as conexao:
                    linhas = conexao.execute(
                        "SELECT id, titulo, feita FROM tarefas "
                        "ORDER BY id").fetchall()
                self.enviar(200, [{"id": i, "titulo": t, "feita": f}
                                  for i, t, f in linhas])
            else:
                self.enviar(404, {"erro": "rota não existe"})
        except psycopg.OperationalError:
            self.enviar(503, {"erro": "banco indisponível"})

    def do_POST(self):
        if self.path != "/tarefas":
            self.enviar(404, {"erro": "rota não existe"})
            return
        tamanho = int(self.headers.get("Content-Length", 0))
        try:
            titulo = str(json.loads(self.rfile.read(tamanho))["titulo"])
        except (ValueError, KeyError, TypeError):
            self.enviar(400, {"erro": "envie um JSON com o campo titulo"})
            return
        try:
            with conectar() as conexao:
                nova = conexao.execute(
                    "INSERT INTO tarefas (titulo) VALUES (%s) "
                    "RETURNING id, titulo, feita", (titulo,)).fetchone()
            self.enviar(201, {"id": nova[0], "titulo": nova[1],
                              "feita": nova[2]})
        except psycopg.OperationalError:
            self.enviar(503, {"erro": "banco indisponível"})


def encerrar(sinal, quadro):
    # o PID 1 não tem tratador padrão de SIGTERM (capítulo 4):
    # sair aqui faz o docker stop terminar na hora, com código 0
    raise SystemExit(0)


if __name__ == "__main__":
    signal.signal(signal.SIGTERM, encerrar)
    preparar_banco()
    servidor = ThreadingHTTPServer((ENDERECO, PORTA), Api)
    print(f"Servidor pronto em {ENDERECO}:{PORTA} (versão {VERSAO})",
          flush=True)
    servidor.serve_forever()
