import sys

import psycopg

# o endereço do banco vem da linha de comando: o que muda é só o nome
host = sys.argv[1]
try:
    with psycopg.connect(host=host, user="postgres",
                         password="senha-de-teste", dbname="tarefas",
                         connect_timeout=3) as conexao:
        versao = conexao.execute("select version()").fetchone()[0]
        print(host, "->", versao[:23])
except psycopg.OperationalError as erro:
    print(host, "-> erro:", str(erro).strip().splitlines()[0][:110])
