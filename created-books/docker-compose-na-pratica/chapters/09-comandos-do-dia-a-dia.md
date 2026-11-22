# 9. Comandos do dia a dia

> 🗺️ **Neste capítulo:** com o contador rodando, você vai executar comandos dentro dos contêineres com `exec`, rodar tarefas avulsas com `run --rm`, escolher o que acontece quando um contêiner cai com `restart`, pausar o projeto com `stop` e `start`, trocar o comando de um serviço com `command` e `entrypoint` e copiar arquivos com `cp`. · ⏱️ ~55 min

> 🔥 **Aquecimento:** (1) O que `condition: service_healthy` muda num `depends_on`? (2) Depois de um `down -v`, a contagem de visitas recomeça?
>
> <details>
> <summary>Ver resposta</summary>
>
> (1) O serviço só inicia quando a dependência passa no `healthcheck`, e não apenas quando o contêiner dela inicia (capítulo 8). (2) Recomeça: o `-v` apaga o volume `contador_db-data` com as visitas (capítulo 7).
>
> </details>

## De onde paramos

No capítulo 8 o contador passou a subir sozinho e na ordem certa, com `docker compose up -d --wait`. Agora ele fica rodando, e as perguntas mudam: quantas visitas há no banco? Que versão da biblioteca está instalada na imagem? E se a API cair de madrugada? Este capítulo traz os comandos para isso, e também como mudar o comando que um serviço roda e tirar arquivos de dentro dos contêineres.

## exec

Para saber quantas visitas o banco guarda, você poderia publicar a porta do banco e instalar um programa de PostgreSQL na sua máquina. Mas o contêiner do banco já tem o `psql`, o cliente de linha de comando do PostgreSQL. Falta só rodá-lo **lá dentro**.

**`docker compose exec` roda um comando dentro do contêiner de um serviço que já está rodando.**

Com o contador no ar e três visitas feitas:

```bash
docker compose exec db psql -U postgres -c "SELECT count(*) FROM visitas"
```

```text
 count
-------
     3
(1 row)
```

O comando tem três partes: `exec`, o nome do **serviço** (`db`, como em `logs`) e o comando a rodar no contêiner (`psql -U postgres -c "..."`). Tudo depois do nome do serviço é do contêiner, não do Compose.

O `exec` serve para qualquer programa que a imagem tenha. Para conferir a variável que o Compose entregou à API, ou ver a pasta de trabalho dela:

```bash
docker compose exec api printenv DB_HOST
docker compose exec api sh -c 'pwd; ls'
```

```text
db
/app
app.py
```

Para uma sessão interativa, peça um shell: `docker compose exec api sh` abre um prompt dentro do contêiner, e `exit` volta ao seu terminal.

Por padrão, o `exec` liga o comando a um terminal interativo (TTY), como se você estivesse digitando lá dentro. Num script, ou quando a saída vai para outro programa, desligue isso com `-T`. Com `-tA` no `psql`, que tira o cabeçalho e o alinhamento, sobra só o número:

```bash
docker compose exec -T db psql -U postgres -tAc "SELECT max(id) FROM visitas"
```

```text
3
```

> ⚠️ **Erro comum:** usar `exec` com o serviço parado. O `exec` não sobe nada; ele entra num contêiner que já está rodando. Com a API parada, a resposta é:
>
> ```text
> service "api" is not running
> ```
>
> Suba o serviço com `docker compose up -d` (ou `start`, mais abaixo) e tente de novo, ou use `run`, que cria um contêiner novo.

## run --rm

Algumas tarefas não precisam do serviço rodando: conferir a versão de uma biblioteca, rodar um script de migração, testar um comando. Para elas, entrar no contêiner da API (que está atendendo visitas) não é o ideal.

**`docker compose run` cria um contêiner novo, a partir da configuração de um serviço, para rodar um comando avulso; com `--rm`, o contêiner é apagado quando o comando termina.**

```bash
docker compose run --rm api \
  python -c "import psycopg; print(psycopg.__version__)"
```

```text
 Container contador-db-1 Running
 Container contador-db-1 Waiting
 Container contador-db-1 Healthy
 Container contador-api-run-9c86d752dd49 Creating
 Container contador-api-run-9c86d752dd49 Created
3.3.9
```

Três coisas aparecem na saída. O `run` respeitou o `depends_on`: conferiu que o `db` estava `Healthy` antes de criar o contêiner. O contêiner novo tem um nome diferente, `contador-api-run-` seguido de um código, para não se confundir com o `contador-api-1`. E a última linha é a resposta do comando: a imagem tem o `psycopg` 3.3.9, a versão fixada no `Dockerfile` do capítulo 6.

Se a tarefa não precisa do banco, `--no-deps` pula as dependências: `docker compose run --rm --no-deps api python -c "print('sem banco junto')"` criou só o contêiner avulso.

O `run` também **não** publica as portas do serviço, para não brigar com o contêiner principal, que já usa a 8000. Um `run -d api`, que sobe a API num contêiner avulso, ficou sem nenhuma porta publicada. Para publicá-las, existe `--service-ports`; com ele, o contêiner avulso respondeu `Visita número 7` em `localhost:8000` (com o contêiner principal parado, para a porta estar livre).

![Comparação: docker compose exec usa o contêiner que já roda, falha se o serviço estiver parado, vê os mesmos arquivos e processos e não deixa nada para limpar; docker compose run cria um contêiner novo, sobe as dependências antes, não publica as portas do serviço e, sem --rm, o contêiner fica](../img/c09-exec-run.svg)

> ⚠️ **Erro comum:** esquecer o `--rm`. Sem ele, cada `run` deixa um contêiner parado, como `contador-api-run-6b377c1d722e Exited (0)`. E o `down` comum não remove contêineres do `run`: no teste, ele parou em `Network contador_default Resource is still in use`, porque um contêiner avulso ainda usava a rede. O que limpa é `docker compose down --remove-orphans`, que remove também esses contêineres. Use sempre `run --rm`.

## restart

Até aqui, se a API caísse, ela ficaria caída até alguém notar. Para simular uma queda, este comando manda à API o mesmo sinal de um Ctrl+C, que o Python transforma num erro e encerra o programa:

```bash
docker compose exec -T api \
  python -c "import os, signal; os.kill(1, signal.SIGINT)"
```

O `1` é o processo principal do contêiner, a API. Três segundos depois:

```bash
docker compose ps -a --format '{{.Name}} {{.Status}}'
```

Saída (trecho):

```text
contador-api-1 Exited (130) 3 seconds ago
```

A API saiu com código 130, e o log mostra o motivo, um `KeyboardInterrupt`. E ficou assim: parada.

**A política de reinício (`restart`) diz ao Docker o que fazer quando o contêiner de um serviço termina: deixá-lo parado ou iniciá-lo de novo.**

| Valor | O que faz |
| --- | --- |
| `no` | o padrão: nunca reinicia |
| `always` | sempre reinicia, até o contêiner ser removido |
| `on-failure` | reinicia só se o código de saída indicar erro (diferente de 0); `on-failure:3` limita a 3 tentativas |
| `unless-stopped` | reinicia qualquer que seja o código de saída, mas para de reiniciar quando você para o serviço |

Com `restart: unless-stopped` no serviço `api`, a mesma queda teve outro final:

```yaml
# trecho do serviço api
  api:
    build: .
    restart: unless-stopped
```

```text
contador-api-1 Up 4 seconds (healthy)
```

O `docker inspect contador-api-1 --format '{{.RestartCount}}'` mostrou `1`: o Docker reiniciou a API uma vez, sozinho, e o `curl` voltou a contar visitas. Com `on-failure`, o resultado foi o mesmo, porque 130 é um código de erro.

Você já viu `restart: unless-stopped` no `meu-site` do capítulo 1. Para serviços que devem ficar no ar, como a API e o banco, ele é a escolha mais comum: reinicia depois de uma queda, mas respeita quando **você** manda parar.

> ⚠️ **Erro comum:** esperar que a política de reinício conserte um erro de configuração. Se a API cai na partida porque falta uma variável, ela vai cair de novo a cada reinício, em ciclo. A política cobre quedas eventuais; um erro que se repete aparece no `docker compose logs` e precisa ser corrigido no arquivo.

## stop e start

Às vezes você quer liberar a máquina sem desmontar o projeto: fechar o contador no fim do dia e retomá-lo amanhã, com os mesmos contêineres.

**`docker compose stop` para os contêineres do projeto sem removê-los; `docker compose start` inicia de novo os contêineres que existem.**

```bash
docker compose stop api
docker compose ps -a --format '{{.Name}} {{.Status}}'
```

```text
contador-api-1 Exited (137) 4 seconds ago
contador-db-1 Up 20 seconds (healthy)
```

Mesmo com `restart: unless-stopped`, a API continuou parada: o `stop` conta como “você mandou parar”. O código 137 quer dizer que o processo foi encerrado à força. O banco, quando parado com `docker compose stop db`, saiu com `Exited (0)`: o PostgreSQL atende o pedido de parada e encerra sozinho, sem erro.

```bash
docker compose start api
```

```text
 Container contador-db-1 Waiting
 Container contador-db-1 Healthy
 Container contador-api-1 Starting
 Container contador-api-1 Started
```

O `start` também respeita o `depends_on`. Há ainda o `docker compose restart api`, que para e inicia de uma vez (`Restarting`, `Started`).

| Comando | Contêineres | Rede | Volumes |
| --- | --- | --- | --- |
| `stop` | parados, continuam existindo | fica | ficam |
| `start` / `restart` | os mesmos, iniciados de novo | fica | ficam |
| `down` | removidos | removida | ficam |
| `up -d` | criados ou recriados se o arquivo mudou | criada se faltar | criados se faltarem |

> ⚠️ **Erro comum:** editar o `compose.yaml` e rodar `restart` para aplicar a mudança. O `restart` reinicia os **mesmos** contêineres, com a configuração antiga. No teste, com `DB_HOST` trocado para `banco` no arquivo, o `restart` manteve a API contando visitas normalmente; só o `up -d` aplicou a mudança (`Recreate`) e fez a API responder `failed to resolve host 'banco'`. Mudou o arquivo, use `up -d`.

## command e entrypoint

Às vezes você quer que um serviço rode a mesma imagem com outro comando: o banco com um registro mais detalhado, para investigar um problema, ou a API com uma opção a mais. Criar uma imagem nova para isso seria exagero.

Toda imagem guarda duas partes do comando que roda ao iniciar o contêiner, e o `docker image inspect` mostra as duas:

```bash
docker image inspect contador-api postgres:17 \
  --format '{{.RepoTags}} E={{json .Config.Entrypoint}} C={{json .Config.Cmd}}'
```

```text
[contador-api:latest] E=null C=["python","-u","app.py"]
[postgres:17] E=["docker-entrypoint.sh"] C=["postgres"]
```

O `E` é o *entrypoint*, e o `C`, o *cmd*: o processo do contêiner é o entrypoint seguido do cmd. Na API, sem entrypoint, roda `python -u app.py`, o `CMD` do Dockerfile do capítulo 6. No PostgreSQL, roda `docker-entrypoint.sh postgres`: o script prepara o banco (é ele que lê `POSTGRES_PASSWORD` e cria o banco no volume vazio) e depois inicia o programa recebido como argumento.

**A chave `command` troca o `CMD` da imagem, os argumentos padrão, e mantém o `ENTRYPOINT`; a chave `entrypoint` troca o `ENTRYPOINT` e faz o Compose ignorar o `CMD` da imagem, que você passa a informar em `command`.**

Antes de rodar, preveja: com `command: postgres -c log_statement=all` no banco, o script `docker-entrypoint.sh` ainda roda?

```yaml
# trecho do serviço db
  db:
    image: postgres:17
    # o mesmo programa, com uma opção a mais: registrar todo comando SQL
    command: postgres -c log_statement=all
```

```bash
docker compose up -d --wait
curl -s localhost:8000
docker compose logs db | grep -m3 "statement:"
docker inspect contador-db-1 \
  --format 'Entrypoint={{json .Config.Entrypoint}} Cmd={{json .Config.Cmd}}'
```

Saída (as linhas do log com a data cortada; uma delas quebrada para caber na página):

```text
Visita número 25
db-1  | ... LOG:  statement: BEGIN
db-1  | ... LOG:  statement: CREATE TABLE IF NOT EXISTS visitas
  (id serial PRIMARY KEY)
db-1  | ... LOG:  statement: INSERT INTO visitas DEFAULT VALUES RETURNING id
Entrypoint=["docker-entrypoint.sh"] Cmd=["postgres","-c","log_statement=all"]
```

O entrypoint ficou o da imagem e o `command` virou o novo `Cmd`. O banco agora registra cada comando SQL que a API manda. O `docker compose config` mostra que o Compose dividiu o texto numa lista, `[postgres, -c, log_statement=all]`; você também pode escrever a lista direto, como no `healthcheck` do capítulo 8. Para voltar ao normal, apague a linha `command` e rode `up -d`.

Agora o `entrypoint`. Na API, com `entrypoint: ["python", "-u"]` e nenhum `command`:

```text
container contador-api-1 exited (0)
```

O `docker inspect` mostrou `Entrypoint=["python","-u"] Cmd=null`. Ao trocar o entrypoint, o Compose descartou o `CMD` da imagem: rodou só `python -u`, sem arquivo nenhum, e o Python encerrou na hora, sem erro. Com `command: ["app.py"]` junto, o contêiner voltou a rodar `python -u app.py` e a contar visitas (`Visita número 26`).

| | `command` | `entrypoint` |
| --- | --- | --- |
| Troca, da imagem | o `CMD` | o `ENTRYPOINT` |
| O resto da imagem | o `ENTRYPOINT` continua | o `CMD` é ignorado |
| Uso comum | outro comando ou outras opções | trocar o programa que inicia tudo |
| No `run` | o que vem depois do nome do serviço | a opção `--entrypoint` |

O `run` segue as mesmas regras. Com o `entrypoint` da API em `python -u`, `docker compose run --rm --no-deps api -c "print('só o command mudou')"` imprimiu `só o command mudou`: o texto depois de `api` trocou só o `command`. E `docker compose run --rm --no-deps --entrypoint python api --version` imprimiu `Python 3.13.18`.

> ⚠️ **Erro comum:** trocar o `entrypoint` de uma imagem que depende do dela. Com `entrypoint: ["postgres"]` no banco, o `docker-entrypoint.sh` deixou de rodar, e com ele a preparação do banco e a troca para um usuário sem privilégios. O banco não subiu:
>
> ```text
> db-1  | "root" execution of the PostgreSQL server is not permitted.
> db-1  | The server must be started under an unprivileged user ID to prevent
> ```
>
> Com `restart: unless-stopped`, ele ficou em `Restarting (1)`, em ciclo. Para mudar as opções de um programa, use `command` e deixe o `entrypoint` da imagem em paz.

## docker compose cp

O `exec` roda comandos lá dentro, mas não traz nada para fora. Para guardar uma cópia das visitas na sua máquina, ou pôr um arquivo no contêiner para um teste rápido, você precisa copiar arquivos entre os dois lados.

**`docker compose cp` copia arquivos e pastas entre o contêiner de um serviço e a sua máquina, nos dois sentidos: `serviço:caminho` de um lado e o caminho local do outro.**

Uma cópia de segurança da tabela de visitas, em dois passos: o `pg_dump`, ferramenta de exportação do PostgreSQL, grava o arquivo dentro do contêiner do banco, e o `cp` o traz para a pasta do projeto.

```bash
# 1. exporta a tabela para um arquivo dentro do contêiner do banco
docker compose exec db pg_dump -U postgres -t visitas -f /tmp/visitas.sql
# 2. copia do contêiner (serviço:caminho) para a pasta atual
docker compose cp db:/tmp/visitas.sql ./visitas.sql
```

```text
 contador-db-1 Copying contador-db-1:/tmp/visitas.sql to ./visitas.sql
 contador-db-1 Copied contador-db-1:/tmp/visitas.sql to ./visitas.sql
```

O `visitas.sql` chegou com 2.095 bytes e 120 linhas, com o `CREATE TABLE public.visitas` e os dados. O nome do serviço, `db`, basta: o Compose acha o contêiner sozinho.

No outro sentido, o caminho local vem primeiro:

```bash
printf 'nota de teste\n' > nota.txt
docker compose cp nota.txt api:/app/nota.txt
docker compose exec api ls /app
```

```text
 contador-api-1 Copying nota.txt to contador-api-1:/app/nota.txt
 contador-api-1 Copied nota.txt to contador-api-1:/app/nota.txt
app.py
nota.txt
```

Antes de rodar, preveja: depois de um `docker compose down` e um `up -d`, o `nota.txt` continua em `/app`?

Não continua. O teste mostrou só `app.py`: o `down` removeu o contêiner, e o novo nasceu da imagem, que não tem o arquivo. O mesmo vale para um `app.py` copiado para dentro: ele muda o contêiner atual, não a imagem, e a API só lê o arquivo novo depois de um `restart`. Para mudanças que devem ficar, use a imagem (`up -d --build`), um volume (capítulo 7) ou, ao desenvolver, o `watch` do próximo capítulo.

> ⚠️ **Erro comum:** usar o nome do contêiner em vez do nome do serviço. O `docker compose cp` espera o **serviço**:
>
> ```text
> no container found for service "contador-db-1"
> ```
>
> Escreva `db:/tmp/visitas.sql`. Um caminho que não existe no contêiner dá outro erro: `Could not find the file /tmp/nao-existe.sql in container ...`. Se o serviço tiver várias cópias, a opção `--index` escolhe de qual contêiner copiar.

## 🧪 Lab: um dia na vida do contador

1. Na pasta `contador`, acrescente `restart: unless-stopped` aos serviços `api` e `db`, logo abaixo de `build: .` e de `image: postgres:17`.
2. Suba com `docker compose up -d --wait` e faça três visitas com `curl -s localhost:8000`.
3. Conte as visitas no banco: `docker compose exec db psql -U postgres -c "SELECT count(*) FROM visitas"`.
4. Confira a versão do `psycopg` num contêiner avulso: `docker compose run --rm api python -c "import psycopg; print(psycopg.__version__)"`. Deve aparecer `3.3.9`.
5. Derrube a API de propósito com o comando da seção “restart” e, uns cinco segundos depois, confira com `docker compose ps`: a API deve estar `Up` de novo.
6. Pare só a API com `docker compose stop api`, espere alguns segundos e veja que ela **não** volta. Depois, `docker compose start api`.
7. Acrescente `command: postgres -c log_statement=all` ao `db`, rode `docker compose up -d --wait`, faça uma visita e procure as linhas `statement:` com `docker compose logs db`. Depois, apague a linha e rode `up -d` de novo.
8. Faça a cópia de segurança da seção “docker compose cp”: `pg_dump` com `exec` e `docker compose cp db:/tmp/visitas.sql ./visitas.sql`. Abra o arquivo e procure o `CREATE TABLE`.
9. No fim, `docker compose down`. Se ele reclamar de `Resource is still in use`, sobrou um contêiner de `run`: use `docker compose down --remove-orphans`.

## 🏋️ Pratique

### 1. Exemplo resolvido

Você quer um script que mostre, numa linha só, quantas visitas o contador já recebeu, para usar num relatório.

1. O número está no banco, que já está rodando: é trabalho para `exec`, não para `run`.
2. O comando vai rodar num script, sem ninguém digitando: o `-T` desliga o terminal interativo.
3. A saída precisa ser só o número: o `psql` com `-t` (sem cabeçalho) e `-A` (sem alinhamento) entrega isso. O `-c` passa a consulta.
4. Juntando:

   ```bash
   # -T: sem terminal interativo, para funcionar dentro de scripts
   docker compose exec -T db \
     psql -U postgres -tAc "SELECT max(id) FROM visitas"
   ```

5. A saída tem apenas o número, `7` (o número muda conforme as suas visitas). O `max(id)` dá o número da última visita; como os `id` começam em 1 e sobem de um em um, ele coincide com o total enquanto nenhuma linha for apagada.

### 2. Complete

Complete com o comando certo para cada tarefa no contador:

```bash
# 1. ver as variáveis de ambiente do contêiner da API, que está rodando
docker compose ________ api printenv
# 2. teste avulso na imagem da API, sem subir o banco e sem sobras
docker compose run ________ ________ api python -c "print('ok')"
# 3. pausar o projeto no fim do dia, sem remover nada
docker compose ________
# 4. aplicar uma mudança feita no compose.yaml
docker compose ________ ________
```

<details>
<summary>Ver resposta</summary>

```bash
# exec no que roda, run --rm no avulso, stop pausa, up -d aplica
docker compose exec api printenv
docker compose run --rm --no-deps api python -c "print('ok')"
docker compose stop
docker compose up -d
```

Erros comuns: usar `run` na tarefa 1, que mostraria as variáveis de um contêiner novo, e não do que está rodando (aqui seriam as mesmas, mas só por acaso); esquecer o `--rm` na 2, que deixa um contêiner `contador-api-run-...` parado; usar `down` na 3, que remove contêineres e rede; e usar `restart` na 4, que não lê o arquivo de novo.

</details>

Agora, complete o `compose.yaml` e os comandos de cópia:

```yaml
# o banco com outro comando, sem trocar o docker-entrypoint.sh da imagem
  db:
    image: postgres:17
    ________: postgres -c log_statement=all
```

```bash
# 5. trazer o arquivo /tmp/visitas.sql do banco para a pasta atual
docker compose cp ________ ./visitas.sql
# 6. levar o nota.txt da pasta atual para /app, no contêiner da API
docker compose cp nota.txt ________
```

<details>
<summary>Ver resposta</summary>

```yaml
  db:
    image: postgres:17
    # command troca só o CMD; o entrypoint da imagem continua
    command: postgres -c log_statement=all
```

```bash
docker compose cp db:/tmp/visitas.sql ./visitas.sql
docker compose cp nota.txt api:/app/nota.txt
```

Erros comuns: usar `entrypoint` no lugar de `command`, que pula o `docker-entrypoint.sh` e dá `"root" execution of the PostgreSQL server is not permitted`; escrever `contador-db-1:/tmp/visitas.sql`, nome do contêiner, que dá `no container found for service "contador-db-1"`; e inverter a ordem dos dois lados no `cp`: a origem vem sempre primeiro.

</details>

### 3. Sozinho

Escolha a política de reinício da API e do banco do contador, sabendo que: (a) se a API cair por um erro, ela deve voltar sozinha; (b) quando você para o projeto com `stop` para economizar memória, nada deve voltar sozinho. Escreva as linhas e diga o que acontece, com a sua escolha, quando a API sai com código 130 e quando você roda `docker compose stop api`.

<details>
<summary>Ver resposta</summary>

```yaml
# nos dois serviços: volta depois de uma queda, respeita o stop
  api:
    build: .
    restart: unless-stopped
  db:
    image: postgres:17
    restart: unless-stopped
```

Com o código 130 (a queda simulada neste capítulo), o Docker reinicia a API: o `ps` mostrou `Up 4 seconds (healthy)` e `RestartCount` 1. Com `docker compose stop api`, ela fica `Exited` e não volta, até você rodar `start` ou `up -d`.

`on-failure` também atende os dois itens, porque 130 é um código de erro, mas não reiniciaria um contêiner que saísse com código 0. `always` também passou nos dois testes: depois de um `stop`, a API ficou `Exited`. O `unless-stopped` tem a vantagem de dizer a intenção no próprio nome. `no` falha o item (a).

</details>

Agora, outra tarefa: você suspeita que o `app.py` dentro do contêiner da API não é o mesmo da sua pasta. Sem abrir um shell no contêiner, traga o arquivo de lá com outro nome e compare os dois. Diga também como fazer a API usar o arquivo da pasta, se eles forem diferentes.

<details>
<summary>Ver resposta</summary>

```bash
# copia com outro nome, para não sobrescrever o seu app.py
docker compose cp api:/app/app.py ./app-do-conteiner.py
diff app.py app-do-conteiner.py
```

No teste, o `diff` não mostrou nada: os arquivos eram iguais. Com uma linha a mais no `app.py` da pasta, ele mostrou a diferença (`< # mudança local`). No PowerShell, `Compare-Object (Get-Content app.py) (Get-Content app-do-conteiner.py)` faz a mesma comparação.

Para a API usar o arquivo da pasta de verdade, reconstrua a imagem com `docker compose up -d --build` (capítulo 4). Copiar com `docker compose cp app.py api:/app/app.py` e reiniciar com `docker compose restart api` também funciona, mas só até o próximo `down`: o contêiner novo nasce da imagem, com o arquivo antigo. Erro comum: copiar para `./app.py`, que apaga a sua versão antes de comparar.

</details>

### 4. Desafio

Um colega usa o contador há semanas e reclama: `docker compose down` termina com `Network contador_default Resource is still in use`, e o `docker ps -a` mostra vários contêineres com nomes como `contador-api-run-6b377c1d722e`. Explique de onde eles vieram, por que o `down` não os remove, como limpar tudo de uma vez e o que mudar no hábito dele.

<details>
<summary>Ver resposta</summary>

Os contêineres vieram de `docker compose run` sem `--rm`: cada `run` cria um contêiner avulso, com o sufixo `-run-` e um código, e ele fica parado quando o comando termina. Algum deles pode até estar rodando, se foi criado com `run -d`.

O `down` remove os contêineres dos **serviços**, os que o `up` criou. Os contêineres do `run` são avulsos e ficam de fora. Como algum deles ainda está ligado à rede `contador_default`, o Docker não consegue removê-la: `Resource is still in use`.

Para limpar tudo, `docker compose down --remove-orphans`. No teste, ele parou e removeu os dois contêineres avulsos e, depois, a rede.

O hábito: sempre `run --rm`, para o contêiner sumir ao terminar. E, para olhar algo num serviço que já está rodando, `exec`, que não cria contêiner nenhum.

Uma resposta completa liga a origem (o `run` sem `--rm`), o motivo do erro (contêiner avulso segurando a rede) e as duas correções, a da limpeza e a do hábito.

</details>

Um segundo desafio: uma colega quer que o banco registre todos os comandos SQL e escreveu no `db`:

```yaml
# o que ela escreveu: o entrypoint vira o próprio postgres
    entrypoint: ["postgres", "-c", "log_statement=all"]
```

O banco não sobe, e o log mostra `"root" execution of the PostgreSQL server is not permitted.` Explique por que, usando o que o `docker image inspect postgres:17` mostra, e corrija com uma linha.

<details>
<summary>Ver resposta</summary>

O `docker image inspect` mostra o entrypoint `["docker-entrypoint.sh"]` e o cmd `["postgres"]` da imagem. O script da imagem prepara o banco e inicia o `postgres` com um usuário sem privilégios. Ao trocar o `entrypoint`, ela pulou o script: o `postgres` rodou direto como `root`, o que ele recusa. E, com `entrypoint` definido, o Compose ignora também o `CMD` da imagem.

A correção é trocar o `CMD`, não o `ENTRYPOINT`:

```yaml
# o script da imagem continua; só os argumentos mudam
    command: postgres -c log_statement=all
```

No teste, o `docker inspect` mostrou `Entrypoint=["docker-entrypoint.sh"] Cmd=["postgres","-c","log_statement=all"]`, e o log passou a ter as linhas `statement:`. Uma resposta completa usa o `inspect` para mostrar as duas partes, explica por que o script importa e troca `entrypoint` por `command`.

</details>

## 🧠 Revisão rápida

1. Qual a diferença entre `docker compose exec api ...` e `docker compose run --rm api ...`?
2. Para que serve o `-T` no `exec`?
3. O `run` publica as portas do serviço? Como pedir que publique?
4. Com `restart: unless-stopped`, o que acontece quando a API cai sozinha, e quando você roda `docker compose stop api`?
5. Qual a diferença entre `command` e `entrypoint` num serviço?
6. Um arquivo copiado com `docker compose cp` para dentro do contêiner sobrevive a um `down` e um `up -d`? Por quê?
7. (Capítulo 6) Dentro do contêiner da API, `printenv DB_HOST` mostra `db`. Por que esse valor basta para achar o banco?

<details>
<summary>Ver resposta</summary>

1. O `exec` roda o comando no contêiner que já está rodando; o `run` cria um contêiner novo a partir do serviço, e o `--rm` o apaga no fim.
2. Desliga o terminal interativo, para o comando funcionar em scripts e a saída poder ir para outro programa.
3. Não, para não brigar com o contêiner principal pelas mesmas portas. Com `--service-ports`, ele publica.
4. Quando cai sozinha, o Docker a reinicia. Quando você a para com `stop`, ela fica parada até `start` ou `up -d`.
5. O `command` troca o `CMD` da imagem e mantém o `ENTRYPOINT`; o `entrypoint` troca o `ENTRYPOINT` e faz o Compose ignorar o `CMD`.
6. Não: o `down` remove o contêiner, e o novo nasce da imagem, sem o arquivo.
7. Porque, na rede do projeto, o nome do serviço funciona como endereço: o Docker traduz `db` para o IP atual do contêiner do banco.

</details>

## 🤖 Estude com um tutor de IA

Copie e cole num assistente de IA:

```text
Estou aprendendo Docker Compose. Faça 5 perguntas, uma de cada vez,
sobre exec, run --rm, as políticas de restart, a diferença entre
stop, restart, down e up -d, command x entrypoint e docker compose cp.
Misture perguntas de "qual comando usar".
Espere minha resposta antes de comentar e não me dê as respostas antes.
```

```text
Vou descrever uma tarefa no meu projeto Compose e o comando que eu
usaria. Diga se o comando é o melhor para a tarefa e por quê, mas
sem me dar a resposta certa logo de cara: me faça uma pergunta antes.
Tarefa e comando: <cole aqui>
```

> ➡️ **Próximo passo:** até aqui, toda mudança no código pede um `up -d --build`. No capítulo 10, o `watch` passa a fazer isso sozinho: ele vigia os arquivos e sincroniza, reinicia ou reconstrói conforme o que mudou.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| `exec` | Roda um comando no contêiner de um serviço que já está rodando |
| `exec -T` | O mesmo, sem terminal interativo, para scripts |
| `run --rm` | Cria um contêiner avulso para uma tarefa e o apaga no fim |
| `run --no-deps` | Não sobe as dependências do serviço |
| `run --service-ports` | Publica as portas do serviço, que o `run` normalmente não publica |
| `restart: unless-stopped` | Reinicia depois de uma queda; respeita o `stop` |
| `stop` / `start` | Para e retoma os mesmos contêineres, sem remover nada |
| `restart` (comando) | Reinicia os contêineres, mas não aplica mudanças do arquivo |
| `down --remove-orphans` | Remove também contêineres avulsos, como os do `run` |
| `command` | Troca o `CMD` da imagem; o `ENTRYPOINT` continua |
| `entrypoint` | Troca o `ENTRYPOINT`; o `CMD` da imagem é ignorado |
| `docker compose cp` | Copia arquivos entre o contêiner de um serviço e a máquina |

## 📚 Fontes

- [docker compose exec](https://docs.docker.com/reference/cli/docker/compose/exec/) (conferido em 21/11/2026)
- [docker compose run](https://docs.docker.com/reference/cli/docker/compose/run/) (conferido em 21/11/2026)
- [docker compose restart](https://docs.docker.com/reference/cli/docker/compose/restart/) (conferido em 21/11/2026)
- [Services (Compose file reference)](https://docs.docker.com/reference/compose-file/services/) (conferido em 21/11/2026)
- [Compose Specification: container_spec (command e entrypoint)](https://github.com/compose-spec/compose-spec/blob/main/container_spec.md) (conferido em 21/11/2026)
- [docker compose cp](https://docs.docker.com/reference/cli/docker/compose/cp/) (conferido em 21/11/2026)

> 🔁 **Revise hoje:** capítulos 2, 6 e 8

<!-- nav:start -->
---

[◀ Capítulo anterior](08-ordem-de-inicio-e-saude.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](10-desenvolvimento-com-watch.md)
<!-- nav:end -->
