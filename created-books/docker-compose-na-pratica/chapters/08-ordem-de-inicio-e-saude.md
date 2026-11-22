# 8. Ordem de início e saúde

> 🗺️ **Neste capítulo:** você vai ensinar o Compose a perguntar se cada serviço está pronto, com `healthcheck`, e a fazer a API esperar o banco ficar pronto, com `depends_on` e `service_healthy`. No fim, um `up` só devolve o terminal quando tudo responde. · ⏱️ ~45 min

> 🔥 **Aquecimento:** (1) Que nome tem o volume nomeado `db-data` no projeto `contador`? (2) Depois de um `docker compose down`, sem `-v`, o contador continua de onde parou?
>
> <details>
> <summary>Ver resposta</summary>
>
> (1) `contador_db-data`: o nome do projeto, um sublinhado e o nome do volume (capítulo 7). (2) Continua: o `down` remove contêineres e rede, mas mantém o volume nomeado (capítulo 7).
>
> </details>

## De onde paramos

Desde o capítulo 6, depois de cada `up` do contador você espera “uns cinco segundos” antes do primeiro `curl`. Num script, num colega com uma máquina mais lenta ou num servidor, esse “uns cinco segundos” vira erro. Neste capítulo, o projeto passa a saber sozinho quando está pronto.

## Healthcheck

Veja o problema de perto. Com o banco zerado (`docker compose down -v`), suba o contador e acesse a API várias vezes seguidas, logo em seguida:

```bash
docker compose up -d
curl -sS localhost:8000
```

Repetindo o `curl` a cada meio segundo, as primeiras respostas foram (trecho; linhas cortadas e quebradas para caber na página):

```text
curl: (52) Empty reply from server
Sem banco: connection failed: connection to server at "172.20.0.2",
  port 5432 failed: Connection ref
Visita número 1
```

A primeira tentativa chegou antes de a API estar escutando: `Empty reply from server`. A segunda achou a API, mas o banco ainda não aceitava conexões. Só a terceira funcionou. Para o Compose, os dois contêineres estavam `Started` desde o começo, e `Started` quer dizer só que o processo começou a rodar.

**O `healthcheck` é um comando que o Docker roda dentro do contêiner, de tempos em tempos, para saber se o programa está pronto: se o comando termina sem erro, o contêiner está `healthy`; se falha várias vezes seguidas, fica `unhealthy`.**

Cada programa tem o seu jeito de responder “estou pronto”. A imagem do PostgreSQL traz o `pg_isready`, feito para isso. Na API, a forma mais segura é ter uma rota que responde sem fazer trabalho de verdade. O `app.py` do contador ganha a rota `/saude`, e o resto do código não muda:

<!-- project: contador | run: cd contador && docker compose config | expect: service_healthy -->

**contador/app.py**

```python
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

import psycopg

# o endereço do banco vem do compose.yaml: o nome do serviço
CONEXAO = {
    "host": os.environ.get("DB_HOST", "db"),
    "port": os.environ.get("DB_PORTA", "5432"),
    "user": "postgres",
    "password": os.environ["DB_SENHA"],
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
            self.responder(200, f"Visita número {linha[0]}\n")
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
```

No `compose.yaml`, cada serviço ganha um bloco `healthcheck`:

```yaml
# trecho do serviço db
  db:
    image: postgres:17
    healthcheck:
      # -h localhost: testa pela rede, o mesmo caminho que a API usa
      test: ["CMD-SHELL", "pg_isready -h localhost -U postgres"]
      interval: 2s
      timeout: 3s
      retries: 10
```

As quatro chaves:

- `test`: o comando. Começando com `CMD-SHELL`, ele roda num shell; começando com `CMD`, roda direto, sem shell.
- `interval`: o tempo entre um teste e outro.
- `timeout`: quanto o teste pode demorar antes de contar como falha.
- `retries`: quantas falhas seguidas tornam o contêiner `unhealthy`.

Com esses valores, o Docker testa o banco a cada 2 segundos e desiste depois de 10 falhas seguidas, cerca de 20 segundos. O livro sempre escreve os quatro valores no arquivo, em vez de confiar nos padrões: quem lê o arquivo sabe exatamente o que esperar.

> 💡 **Analogia:** na loja do capítulo 1, ramal certo não quer dizer alguém pronto para atender, como o capítulo 6 mostrou. Por isso o gerente liga, de tempos em tempos, para cada ramal e pergunta: “já dá para atender cliente?”.
>
> - O `test` é a pergunta, e cada setor tem a sua: no PostgreSQL, ela é o `pg_isready`.
> - O `interval` é o tempo entre uma ligação e a próxima; o `timeout`, quanto o gerente espera alguém atender antes de desligar; o `retries`, quantas ligações seguidas sem resposta fazem ele marcar o setor como fora de serviço, o `unhealthy`.
> - O `healthy` é a resposta “pode mandar”.
> - O `depends_on` com `service_healthy`, da próxima seção, é a regra da loja: a porta só abre para os clientes depois que o estoque respondeu “pode mandar”.
>
> **Onde a analogia para de valer:** o gerente de verdade faz alguma coisa quando um setor para de atender. O Docker só anota o estado. Num teste com um serviço que passou a falhar no healthcheck depois de subir, mesmo com `restart: unless-stopped`, o contêiner ficou `Up 14 seconds (unhealthy)`, com `RestartCount=0`, e o serviço que dependia dele continuou rodando. A espera do `depends_on` vale só para o início.

O `docker compose ps` passa a mostrar a saúde junto do estado:

```text
NAME             STATUS
contador-api-1   Up 3 seconds (healthy)
contador-db-1    Up 5 seconds (healthy)
```

Enquanto os testes ainda não passaram, aparece `(health: starting)`. Para ver o que o último teste respondeu, use o `docker inspect` com o nome do contêiner:

```bash
docker inspect contador-db-1 \
  --format '{{.State.Health.Status}} {{(index .State.Health.Log 0).Output}}'
```

```text
healthy /var/run/postgresql:5432 - accepting connections
```

> ⚠️ **Erro comum:** escrever um teste com uma ferramenta que a imagem não tem. O `curl` é o exemplo clássico. Com `test: ["CMD", "curl", "-f", "http://localhost:5432"]` no banco, o contêiner ficou `Up 7 seconds (unhealthy)`, e o `docker inspect` mostrou o motivo:
>
> ```text
> OCI runtime exec failed: exec failed: unable to start container process: exec: "curl": executable file not found in $PATH
> ```
>
> Use o que a imagem traz: `pg_isready` no PostgreSQL, `redis-cli ping` no Redis, `wget` nas imagens Alpine, o próprio `python` numa imagem Python.

## depends_on com condition

Saber que o banco está pronto ainda não basta: a API precisa **esperar** por isso antes de começar. É uma relação entre dois serviços.

**`depends_on` diz de quais serviços um serviço depende; com `condition`, diz também em que estado a dependência precisa estar para o Compose iniciar o serviço.**

A forma curta, uma lista de nomes, parece resolver:

```yaml
# forma curta: só garante a ordem de início
  api:
    depends_on:
      - db
```

O `up` passa a criar e iniciar o banco antes da API:

```text
 Container contador-db-1 Starting
 Container contador-db-1 Started
 Container contador-api-1 Starting
 Container contador-api-1 Started
```

Mas, acessando logo depois, o resultado foi o mesmo de antes (trecho; linha quebrada para caber na página):

```text
curl: (52) Empty reply from server
Sem banco: connection failed: connection to server at "172.20.0.2",
  port 5432 failed: Connection ref
Visita número 1
```

A forma curta equivale a `condition: service_started`: a API espera o contêiner do banco **iniciar**, não o PostgreSQL ficar pronto. Entre os dois há alguns segundos, e é neles que a API falha.

| `condition` | A API espera o serviço `db`... |
| --- | --- |
| `service_started` (o da forma curta) | iniciar o contêiner |
| `service_healthy` | passar no `healthcheck` |
| `service_completed_successfully` | terminar com código 0 (para tarefas que rodam uma vez) |

> ⚠️ **Erro comum:** achar que `depends_on: [db]` faz a API esperar o banco ficar pronto. Ele só ordena o início dos contêineres. Para esperar o banco, a dependência precisa de `condition: service_healthy`, e o banco precisa de um `healthcheck`; sem ele, o Compose não tem como saber se o banco está saudável.

## service_healthy e up --wait

Juntando as peças: o banco tem um `healthcheck`, e a API depende dele com `service_healthy`.

**Com `condition: service_healthy`, o Compose só inicia o serviço quando a dependência fica `healthy`; se ela ficar `unhealthy`, o serviço nem é iniciado.**

**contador/compose.yaml**

```yaml
services:
  api:
    build: .
    ports:
      - "127.0.0.1:8000:8000"
    environment:
      DB_HOST: db
      DB_SENHA: ${DB_SENHA:?defina DB_SENHA no .env}
    # a API só inicia quando o banco passar no healthcheck
    depends_on:
      db:
        condition: service_healthy
    healthcheck:
      test:
        - CMD
        - python
        - -c
        - "import urllib.request as u; u.urlopen('http://localhost:8000/saude')"
      interval: 2s
      timeout: 3s
      retries: 10
  db:
    image: postgres:17
    environment:
      POSTGRES_PASSWORD: ${DB_SENHA:?defina DB_SENHA no .env}
    volumes:
      - db-data:/var/lib/postgresql/data
    healthcheck:
      # -h localhost: testa pela rede, o mesmo caminho que a API usa
      test: ["CMD-SHELL", "pg_isready -h localhost -U postgres"]
      interval: 2s
      timeout: 3s
      retries: 10

volumes:
  db-data:
```

O `healthcheck` da API usa o próprio Python, porque a imagem `python:3.13-slim` não tem `curl`. A lista em várias linhas é o mesmo que `["CMD", "python", "-c", "..."]`, só que cabe na tela. O `urlopen` termina com erro se a API não responder, e o teste falha.

Falta uma peça: o `depends_on` faz a API esperar o banco, mas quem espera a API? O `up -d` devolve o terminal assim que inicia os contêineres. A opção `--wait` faz o `up` esperar até todos os serviços estarem rodando e, os que têm `healthcheck`, `healthy`.

Antes de rodar, preveja: na saída do `up`, a API vai aparecer como `Starting` antes ou depois de o banco aparecer como `Healthy`?

```bash
docker compose up -d --wait
curl -s localhost:8000
```

Saída (trecho; linhas de volume e rede cortadas):

```text
 Container contador-db-1 Starting
 Container contador-db-1 Started
 Container contador-db-1 Waiting
 Container contador-db-1 Healthy
 Container contador-api-1 Starting
 Container contador-api-1 Started
 Container contador-db-1 Waiting
 Container contador-api-1 Waiting
 Container contador-db-1 Healthy
 Container contador-api-1 Healthy
Visita número 1
```

Leia de cima para baixo. O banco inicia, o Compose espera (`Waiting`) até ele ficar `Healthy`, e só então inicia a API: é o `depends_on` agindo. Depois vem o `--wait`: ele espera de novo os dois serviços, até a API também ficar `Healthy`. Quando o terminal volta, o primeiro `curl` já responde `Visita número 1`. Em três rodadas seguidas, com o banco zerado a cada vez, o resultado foi o mesmo.

![Fluxo do up -d --wait: o db inicia; se o pg_isready não respondeu, testa de novo em 2 segundos e fica unhealthy depois de 10 falhas; quando responde, o db fica healthy e a api inicia; se o /saude não respondeu, testa de novo em 2 segundos; quando responde, o terminal volta e o primeiro curl funciona](../img/c08-espera.svg)

O teste de saúde aparece nos logs da API, porque é um acesso como outro qualquer, só que de dentro do contêiner (`127.0.0.1`):

```text
api-1  | 127.0.0.1 - - [21/Nov/2026 04:16:26] "GET /saude HTTP/1.1" 200 -
```

É por isso que o teste usa `/saude` e não `/`: na raiz, cada teste contaria uma visita, e o contador subiria sozinho a cada 2 segundos.

> ⚠️ **Erro comum:** um `healthcheck` que nunca passa trava a subida inteira. No teste com o `curl` no banco, o `up` terminou com:
>
> ```text
>  Container contador-api-1 not started: condition "service_healthy" of service "db" not met
> dependency failed to start: container contador-db-1 is unhealthy
> ```
>
> E o `ps -a` mostrou a API em `Created`: criada, mas nunca iniciada. Quando um serviço não sobe, olhe primeiro a saúde das dependências dele.

## 🧪 Lab: um up que espera

1. Na pasta `contador`, troque o `app.py` pelo da seção “Healthcheck” e o `compose.yaml` pelo da seção “service_healthy e up --wait”. O `Dockerfile` e o `.env` não mudam.
2. Zere o banco para ver a espera completa: `docker compose down -v`.
3. Suba com `docker compose up -d --wait --build`. O `--build` reconstrói a imagem com a rota nova. Procure, na saída, `contador-db-1 Healthy` antes de `contador-api-1 Starting`.
4. Assim que o terminal voltar, rode `curl -s localhost:8000`. Deve aparecer `Visita número 1`, sem espera.
5. Confira a saúde: `docker compose ps --format 'table {{.Name}}\t{{.Status}}'` deve mostrar `(healthy)` nos dois.
6. Teste a rota de saúde do seu terminal: `curl -s localhost:8000/saude` responde `ok`. Acesse `/` de novo e veja que a contagem não pulou números por causa dos testes.
7. Derrube com `docker compose down`.

## 🏋️ Pratique

### 1. Exemplo resolvido

Um colega copiou de um tutorial este `healthcheck` para o banco do contador:

```yaml
# o teste copiado: usa curl e trata o banco como um site
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5432"]
      interval: 2s
      timeout: 3s
      retries: 3
```

O `up` falha com `dependency failed to start: container contador-db-1 is unhealthy`.

Passo a passo:

1. A mensagem diz que a API não subiu porque o banco ficou `unhealthy`. O problema está no `healthcheck` do `db`, não na API.
2. O `docker compose ps -a` confirma: `contador-db-1` com `(unhealthy)`, `contador-api-1` em `Created`.
3. Para saber por que o teste falha, veja a saída dele:

   ```bash
   docker inspect contador-db-1 \
     --format '{{(index .State.Health.Log 0).Output}}'
   ```

   ```text
   OCI runtime exec failed: exec failed: unable to start container process:
     exec: "curl": executable file not found in $PATH
   ```

4. A imagem do PostgreSQL não tem `curl`. E, mesmo que tivesse, o PostgreSQL não fala HTTP na porta 5432: o teste falharia de qualquer jeito.
5. Troque pela ferramenta da própria imagem, feita para isso:

   ```yaml
   # pg_isready vem na imagem postgres e fala o protocolo do banco
       healthcheck:
         test: ["CMD-SHELL", "pg_isready -h localhost -U postgres"]
         interval: 2s
         timeout: 3s
         retries: 10
   ```

6. Rode `docker compose up -d --wait` de novo: o banco fica `Healthy`, e a API sobe.

### 2. Complete

Um serviço `app` precisa esperar um Redis (`redis:7-alpine`) ficar pronto. O Redis responde `PONG` ao comando `redis-cli ping`. Complete:

```yaml
# o app só inicia com o cache saudável
services:
  app:
    image: nginx:1.27-alpine
    depends_on:
      cache:
        condition: ________
  cache:
    image: redis:7-alpine
    ________:
      test: ["CMD", "________", "________"]
      interval: 2s
      timeout: 3s
      retries: 5
```

<details>
<summary>Ver resposta</summary>

```yaml
services:
  app:
    image: nginx:1.27-alpine
    depends_on:
      cache:
        condition: service_healthy
  cache:
    image: redis:7-alpine
    # redis-cli vem na própria imagem do Redis
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 2s
      timeout: 3s
      retries: 5
```

Numa pasta `cache`, o `up -d` mostrou `Container cache-cache-1 Waiting`, `Healthy` e só depois `Container cache-app-1 Started`; a saída do teste, no `docker inspect`, foi `PONG`. Erros comuns: `condition: healthy` (o nome é `service_healthy`); pôr o `healthcheck` no `app` em vez de no `cache`, que é quem precisa provar que está pronto; e usar `["CMD", "redis-cli ping"]`, com o comando e o argumento juntos num item só, que a forma `CMD` trata como o nome de um programa que não existe.

</details>

### 3. Sozinho

Dê ao `meu-site` (nginx em `nginx:1.27-alpine`, porta 8080) um `healthcheck` que confirme que o nginx entrega a página inicial. A imagem Alpine não tem `curl`, mas tem `wget`. Depois suba com `--wait` e diga o que o `ps` deve mostrar.

<details>
<summary>Ver resposta</summary>

```yaml
services:
  web:
    image: nginx:1.27-alpine
    ports:
      - "127.0.0.1:8080:80"
    volumes:
      - ./site:/usr/share/nginx/html:ro
    # --spider: só confere se a página existe, sem baixá-la
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost/"]
      interval: 5s
      timeout: 3s
      retries: 3
```

O `docker compose up -d --wait` termina com `Container meu-site-web-1 Healthy`, e o `ps` mostra `Up 6 seconds (healthy)` (o tempo varia). Repare que o teste usa `localhost` na porta 80: ele roda **dentro** do contêiner do nginx, onde `localhost` é o próprio nginx, e onde vale a porta do contêiner, não a 8080 publicada. Se você usou `http://localhost:8080/`, o teste falha, e o contêiner fica `unhealthy` depois de três tentativas.

</details>

### 4. Desafio

Um colega diz que já resolveu a ordem de início do contador com `depends_on: [db]`, sem `healthcheck`, e que o `up` mostra o banco iniciando antes da API. Mesmo assim, o script de testes dele, que roda `docker compose up -d` e logo em seguida um `curl`, falha às vezes. Explique por que a ordem não basta, monte a solução completa (o que vai em cada serviço e no comando) e explique por que o `healthcheck` da API não deve usar a rota `/`.

<details>
<summary>Ver resposta</summary>

A forma curta é `service_started`: a API espera o **contêiner** do banco iniciar, não o PostgreSQL aceitar conexões. Nos testes deste capítulo, com a forma curta, o `curl` logo depois do `up` respondeu `Empty reply from server` (a API ainda não escutava) e depois `Sem banco: ... Connection refused` (o banco ainda não aceitava conexões). E o `up -d` não espera nada além do início dos contêineres.

A solução tem três partes:

1. No `db`, um `healthcheck` com `pg_isready -h localhost -U postgres`.
2. Na `api`, `depends_on` com `condition: service_healthy`, e um `healthcheck` próprio, na rota `/saude`.
3. No script, `docker compose up -d --wait`, que só devolve o terminal com todos os serviços `healthy`.

Com isso, o primeiro `curl` respondeu `Visita número 1` nas três rodadas de teste.

O `healthcheck` da API não deve usar `/` porque essa rota faz trabalho de verdade: grava uma visita no banco. Um teste a cada 2 segundos inflaria a contagem e ainda ligaria a saúde da API à do banco. A rota `/saude` responde sem efeito colateral.

Uma resposta completa separa as três esperas: o `healthcheck` diz se cada serviço está pronto; o `depends_on` com `service_healthy` faz a API esperar o banco; o `--wait` faz o comando esperar a API.

</details>

## 🧠 Revisão rápida

1. Por que um contêiner `Started` ainda pode recusar conexões?
2. O que fazem as chaves `interval`, `timeout` e `retries` de um `healthcheck`?
3. Qual a diferença entre `depends_on: [db]` e `depends_on` com `condition: service_healthy`?
4. Para que serve o `--wait` no `docker compose up -d --wait`?
5. (Capítulo 7) Por que o lab deste capítulo usa `down -v` no começo, e por que não se deve usá-lo por hábito?

<details>
<summary>Ver resposta</summary>

1. Porque `Started` só diz que o processo começou. O programa ainda pode estar se preparando, como o PostgreSQL nos primeiros segundos.
2. `interval` é o tempo entre testes; `timeout`, quanto um teste pode demorar; `retries`, quantas falhas seguidas tornam o contêiner `unhealthy`.
3. A forma curta só garante que o contêiner do banco inicie antes. Com `service_healthy`, a API só inicia quando o banco passar no `healthcheck`.
4. Faz o `up` esperar até todos os serviços estarem rodando e, os que têm `healthcheck`, `healthy`, antes de devolver o terminal.
5. Para zerar o banco e ver a espera mais longa, a de um PostgreSQL novo. Por hábito, não: o `-v` apaga o volume `contador_db-data` e todas as visitas, sem desfazer.

</details>

## 🤖 Estude com um tutor de IA

Copie e cole num assistente de IA:

```text
Estou aprendendo Docker Compose. Faça 5 perguntas, uma de cada vez,
sobre healthcheck, depends_on com condition e docker compose up --wait.
Inclua uma pergunta sobre um healthcheck que nunca passa.
Espere minha resposta antes de comentar e não me dê as respostas antes.
```

```text
Meu serviço fica unhealthy e eu não sei por quê. Vou colar o
healthcheck e a saída do docker inspect. Me ajude a descobrir
o problema com perguntas, sem me dar a solução pronta.
Healthcheck e saída: <cole aqui>
```

> ➡️ **Próximo passo:** com o contador subindo sozinho e na ordem certa, o capítulo 9 mostra os comandos do dia a dia com o projeto rodando: entrar num contêiner com `exec`, rodar tarefas avulsas com `run` e escolher o que acontece quando um contêiner cai, com `restart`.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| `Started` | O processo começou; não quer dizer que o programa está pronto |
| `healthcheck` | Comando que o Docker roda no contêiner para saber se ele está `healthy` |
| `test` | `CMD` roda o programa direto; `CMD-SHELL` roda a linha num shell |
| `interval`, `timeout`, `retries` | De quanto em quanto tempo testar, quanto esperar cada teste, quantas falhas toleram |
| `depends_on: [db]` | Só ordena o início (`service_started`) |
| `condition: service_healthy` | O serviço só inicia quando a dependência fica `healthy` |
| `up -d --wait` | Só devolve o terminal com todos os serviços rodando e saudáveis |
| Rota de saúde | Uma rota sem efeito colateral, como `/saude`, para o teste da API |

## 📚 Fontes

- [Control startup order](https://docs.docker.com/compose/how-tos/startup-order/) (conferido em 20/11/2026)
- [Services (Compose file reference)](https://docs.docker.com/reference/compose-file/services/) (conferido em 20/11/2026)
- [docker compose up](https://docs.docker.com/reference/cli/docker/compose/up/) (conferido em 20/11/2026)

> 🔁 **Revise hoje:** capítulos 1, 5 e 7

<!-- nav:start -->
---

[◀ Capítulo anterior](07-volumes-no-compose.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](09-comandos-do-dia-a-dia.md)
<!-- nav:end -->
