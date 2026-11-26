# API de tarefas do livro "Docker do zero" (versão 1.0).
# Só biblioteca padrão e dados em memória: a imagem não precisa de pip.
import json
import os
import signal
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

# tudo que muda entre máquinas vem do ambiente (ENV no Dockerfile
# ou -e no docker run), e não do código
ENDERECO = os.environ.get("ENDERECO", "0.0.0.0")
PORTA = int(os.environ.get("PORTA", "8000"))
VERSAO = os.environ.get("APP_VERSAO", "dev")

# a lista some quando o contêiner for removido: o capítulo 9 resolve
tarefas = [{"id": 1, "titulo": "Estudar Docker"}]


class Api(BaseHTTPRequestHandler):
    def enviar(self, codigo, conteudo):
        corpo = json.dumps(conteudo, ensure_ascii=False).encode("utf-8")
        self.send_response(codigo)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(corpo)))
        self.end_headers()
        self.wfile.write(corpo)

    def do_GET(self):
        if self.path == "/saude":
            self.enviar(200, {"status": "ok", "versao": VERSAO})
        elif self.path == "/tarefas":
            self.enviar(200, tarefas)
        else:
            self.enviar(404, {"erro": "rota não existe"})

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
        nova = {"id": len(tarefas) + 1, "titulo": titulo}
        tarefas.append(nova)
        self.enviar(201, nova)


def encerrar(sinal, quadro):
    # o PID 1 não tem tratador padrão de SIGTERM (capítulo 4):
    # sair aqui faz o docker stop terminar na hora, com código 0
    raise SystemExit(0)


if __name__ == "__main__":
    signal.signal(signal.SIGTERM, encerrar)
    servidor = ThreadingHTTPServer((ENDERECO, PORTA), Api)
    print(f"Servidor pronto em {ENDERECO}:{PORTA} (versão {VERSAO})",
          flush=True)
    servidor.serve_forever()
