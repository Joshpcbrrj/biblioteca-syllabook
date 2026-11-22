# 7. Volumes no Compose

> 🗺️ **Neste capítulo:** você vai descobrir por que o contador volta a 1 depois de um `down`, guardar os dados do banco num volume nomeado, usar bind mounts para arquivos que você edita e entender o que `down -v` apaga. · ⏱️ ~40 min

> 🔥 **Aquecimento:** (1) Dentro do contêiner da API, que endereço leva ao banco do serviço `db`? (2) O que o `docker compose down` remove?
>
> <details>
> <summary>Ver resposta</summary>
>
> (1) `db`, o nome do serviço, na porta do contêiner, 5432 (capítulo 6). (2) Os contêineres dos serviços e a rede do projeto (capítulo 3). Os volumes ficam, e este capítulo mostra o que isso significa.
>
> </details>

## De onde paramos

No fim do capítulo 6, o contador do projeto `contador` voltou a `Visita número 1` depois de um `down` e um `up`. O banco não tinha onde guardar os dados fora do contêiner, e o `down` removeu o contêiner. Este capítulo dá ao banco um lugar que sobrevive ao `down`.

## Volume nomeado

Em *Docker do zero* você viu que tudo o que um contêiner grava some com ele, a menos que esteja num volume. A imagem `postgres:17` sabe disso e declara um volume para os seus dados, em `/var/lib/postgresql/data`. Mas, sem instruções, o Docker cria ali um volume **anônimo**, com um nome sorteado:

```bash
docker inspect contador-db-1 \
  --format '{{range .Mounts}}{{.Type}} {{.Name}} -> {{.Destination}}{{end}}'
```

Saída (linha quebrada para caber na página):

```text
volume 961e50171e7da4a34fc75057da5d8b4b8771361a9b878849713e3c681d90e9ad
  -> /var/lib/postgresql/data
```

O `down` remove o contêiner, e o próximo `up` cria um contêiner novo, com **outro** volume anônimo, vazio. O antigo fica para trás, sem uso, com os dados das visitas dentro. É por isso que o contador recomeçou.

**Um volume nomeado é um volume declarado no `compose.yaml` com um nome fixo, que o Compose cria no primeiro `up` e reaproveita em todos os seguintes, mesmo depois de um `down`.**

São duas partes no arquivo: a declaração, na chave `volumes` do topo, e o uso, na chave `volumes` do serviço.

<!-- project: contador | run: cd contador && docker compose config --volumes | expect: db-data -->

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
  db:
    image: postgres:17
    environment:
      POSTGRES_PASSWORD: ${DB_SENHA:?defina DB_SENHA no .env}
    # nome do volume, dois-pontos, pasta onde o postgres:17 guarda os dados
    volumes:
      - db-data:/var/lib/postgresql/data

# a declaração: sem ela, o Compose não sabe o que é db-data
volumes:
  db-data:
```

A chave `volumes` do topo fica no mesmo nível de `services`, sem indentação. `db-data:` sem nada depois quer dizer “um volume com as opções padrão”.

Antes de rodar, preveja: que nome o volume vai ter no Docker? (Pense no que acontece com o nome dos contêineres e da rede.)

```bash
docker compose up -d
```

Saída (trecho):

```text
 Volume contador_db-data Creating
 Volume contador_db-data Creating
 Volume contador_db-data Created
 Volume contador_db-data Created
```

O volume se chama `contador_db-data`: o nome do projeto, um sublinhado e o nome que você deu. O `docker compose config` mostra a mesma coisa, na seção `volumes` do fim:

```text
volumes:
  db-data:
    name: contador_db-data
```

Agora o teste que falhou no capítulo 6. Espere o banco iniciar, acesse duas vezes, derrube e suba de novo:

```bash
# duas visitas, um down completo e mais uma visita
curl -s localhost:8000
curl -s localhost:8000
docker compose down
docker compose up -d
curl -s localhost:8000
```

Saída (as linhas do `down` e do `up` foram cortadas):

```text
Visita número 1
Visita número 2
Visita número 3
```

A contagem continuou. O `down` removeu os contêineres e a rede, mas a saída dele não tem nenhuma linha `Volume`: o `contador_db-data` ficou, e o contêiner novo do banco o encontrou com os dados dentro.

> ⚠️ **Erro comum:** usar o volume no serviço e esquecer a declaração no topo. O Compose recusa o arquivo:
>
> ```text
> service "db" refers to undefined volume db-data: invalid compose project
> ```
>
> Acrescente o bloco `volumes:` com `db-data:` no fim do arquivo, sem indentação.

## Bind mount

Um volume nomeado é guardado pelo Docker, num lugar que você não precisa conhecer. Isso é ótimo para os dados do banco, que só o PostgreSQL deve mexer. Para arquivos que **você** edita, como as páginas do `meu-site`, é o contrário: você quer abri-los no seu editor.

**Um bind mount liga uma pasta do host a uma pasta do contêiner: os dois veem os mesmos arquivos, e uma mudança de um lado aparece na hora do outro.**

Você usa um bind mount desde o capítulo 1, no `meu-site`:

```yaml
# começa com ./ : é uma pasta do host, não um volume nomeado
    volumes:
      - ./site:/usr/share/nginx/html:ro
```

O Compose diferencia os dois pelo lado esquerdo. Um caminho, como `./site`, é um bind mount, relativo à pasta do `compose.yaml`. Um nome sem barras, como `db-data`, é um volume nomeado, que precisa estar declarado no topo.

Com o `meu-site` rodando, mude a página no seu editor e acesse de novo, sem reiniciar nada:

```bash
curl -s localhost:8080
echo '<h1>Mudei sem reiniciar</h1>' > site/index.html
curl -s localhost:8080
```

```text
<h1>Olá, Compose!</h1>
<h1>Mudei sem reiniciar</h1>
```

O nginx serviu o arquivo novo na hora, porque a pasta do contêiner **é** a pasta `site` do host. O `:ro` no fim (*read-only*) impede o contêiner de gravar ali; uma tentativa de criar um arquivo nessa pasta, de dentro do contêiner, falhou com `Read-only file system`.

| | Volume nomeado | Bind mount |
| --- | --- | --- |
| No `compose.yaml` | `db-data:/var/lib/postgresql/data` | `./site:/usr/share/nginx/html` |
| Onde ficam os arquivos | numa área do Docker | numa pasta sua, ao lado do `compose.yaml` |
| Declaração no topo | obrigatória | não tem |
| Bom para | dados que o programa gerencia (banco) | arquivos que você edita (código, páginas) |
| O `down -v` apaga? | sim | nunca: são arquivos seus |

> ⚠️ **Erro comum:** errar o nome da pasta do host. Com `./vazio` no lugar de `./site`, o Compose não reclama: o Docker cria a pasta `vazio`, vazia, e a monta por cima da pasta de páginas do nginx. A página padrão da imagem fica escondida, e o site responde `403 Forbidden`. Se o contêiner sobe mas não vê os arquivos, confira o caminho do lado esquerdo e procure uma pasta nova e vazia no projeto.

> 💡 **No Windows com WSL:** se você usa o Docker pelo WSL, guarde as pastas de bind mount no disco do Linux, como `~/projetos/meu-site`, e não em `/mnt/c/...`, que é o disco `C:` do Windows visto de dentro do WSL. A documentação do Docker Desktop dá dois motivos: o acesso aos arquivos é bem mais rápido no disco do Linux, e os contêineres Linux só recebem as notificações de mudança de arquivo quando os arquivos estão nele. Programas que recarregam sozinhos ao ver um arquivo mudar dependem dessas notificações. O nginx desta seção não depende: ele lê o arquivo a cada pedido.
>
> Testes na máquina deste livro (Windows 11 com Docker Desktop e WSL 2 com Ubuntu 26.04), com o Docker usado pelo terminal do WSL. Um nginx servia a pasta `site` por bind mount, e um segundo contêiner, com o `inotifyd` da imagem `alpine`, escutava as notificações da mesma pasta:
>
> | | Pasta em `~/projetos` | Pasta em `/mnt/c` |
> | --- | --- | --- |
> | Mudança feita pelo WSL chega ao nginx | sim | sim |
> | Mudança feita por um programa do Windows chega ao nginx | sim (pelo caminho `\wsl.localhost\...`) | sim |
> | Notificação no contêiner, mudança feita pelo WSL | sim | sim |
> | Notificação no contêiner, mudança feita pelo Windows | sim | não |
> | Criar 2.000 arquivos pequenos de dentro do contêiner / ler todos | 0,08 s / 0,01 s | 4,85 s / 4,20 s |
>
> O bind mount funciona nos dois lugares; mudam a velocidade e as notificações. A documentação fala só do disco do Linux, e o teste mostrou um detalhe a mais: em `/mnt/c`, a mudança feita pelo próprio WSL gerou notificação, e a feita por um programa do Windows, que é o caso de quem edita no editor do Windows, não gerou nenhuma. Com o Docker usado pelo terminal do Windows e a pasta no disco `C:`, foi igual: nenhuma notificação para as mudanças feitas pelo Windows. Sem contêiner, pelo shell do WSL, a diferença de velocidade também aparece: 141 ms e 42 ms em `~/projetos`, contra 7.035 ms e 9.773 ms em `/mnt/c`.
>
> Um detalhe da pasta no WSL: os arquivos que o contêiner criou nela ficaram com dono `root`, e o `rm` do usuário comum falhou com `Permission denied`. Para apagá-los, use `sudo rm` ou apague de dentro do contêiner.

## down -v

Às vezes você quer começar do zero: apagar o banco de testes e deixar o `up` criar tudo de novo. O `down` comum não faz isso, de propósito.

**`docker compose down -v` faz o mesmo que o `down` e, além disso, apaga os volumes nomeados declarados no arquivo e os volumes anônimos dos contêineres do projeto.**

```bash
docker compose down -v
```

Saída (trecho):

```text
 Network contador_default Removing
 Volume contador_db-data Removing
 Volume contador_db-data Removed
 Network contador_default Removed
```

Depois de um `up`, a API respondeu `Visita número 1`: os dados das visitas se foram com o volume. Não há lixeira nem desfazer.

![Comparação: docker compose down remove contêineres e rede, mantém o volume nomeado com os dados e deixa o anônimo como sobra; o próximo up responde Visita número 3. docker compose down -v também remove contêineres e rede, mas apaga o volume nomeado e o anônimo; o próximo up responde Visita número 1](../img/c07-down.svg)

O `-v` também resolve as sobras do capítulo 6. Cada `down` sem volume nomeado deixou para trás um volume anônimo do PostgreSQL, que não aparece na saída do `down`. Num teste com o arquivo sem `volumes`, o `down` deixou o volume anônimo na máquina, e o `down -v` o removeu (sem mostrar linha `Volume` para ele). O comando `docker volume ls --filter dangling=true` lista os volumes que nenhum contêiner usa, de todos os projetos; confira o que é cada um antes de apagar com `docker volume rm <nome>`.

> ⚠️ **Erro comum:** usar `down -v` por hábito, “para limpar bem”. Num projeto de estudo, perder o banco não custa nada. Num projeto com dados que importam (um cadastro de teste que levou uma tarde para montar, o banco de um colega), custa. Use `down` no dia a dia; o `-v` só quando você quer, de verdade, apagar os dados.

## 🧪 Lab: o contador que não esquece

1. Na pasta `contador` do capítulo 6, troque o `compose.yaml` pelo da seção “Volume nomeado”.
2. Rode `docker compose config` e procure, no fim, `name: contador_db-data`.
3. Suba com `docker compose up -d` e procure as linhas `Volume contador_db-data Created`.
4. Espere uns cinco segundos e acesse `curl -s localhost:8000` duas vezes.
5. Rode `docker compose down` e confira que a saída não tem nenhuma linha `Volume`.
6. Suba de novo e acesse: a contagem deve continuar de onde parou.
7. Liste os volumes do projeto com `docker volume ls --filter name=contador`. Deve aparecer `contador_db-data`.
8. Agora apague os dados de propósito: `docker compose down -v`. Suba e acesse de novo: `Visita número 1`.
9. Derrube com `docker compose down` (sem `-v`, para guardar o banco novo).

## 🏋️ Pratique

### 1. Exemplo resolvido

Um colega acrescentou um volume ao banco do contador, mas a contagem continua voltando a 1 depois de cada `down` e `up`. O arquivo dele tem:

```yaml
# o caminho do contêiner está errado para o postgres:17
    volumes:
      - db-data:/var/lib/postgresql
```

No teste, a sequência acesso, acesso, `down`, `up`, acesso respondeu `Visita número 1`, `Visita número 2` e `Visita número 1`.

Passo a passo:

1. O volume está declarado e o arquivo foi aceito, então o problema não é a declaração.
2. O volume aparece no `up`, então ele existe. A pergunta passa a ser: os dados estão sendo gravados nele?
3. O lado direito diz onde o volume é montado no contêiner: `/var/lib/postgresql`. A imagem `postgres:17` guarda os dados em `/var/lib/postgresql/data`, uma pasta abaixo, e declara um volume nessa pasta.
4. Como ninguém montou nada exatamente em `/var/lib/postgresql/data`, o Docker criou ali um volume anônimo, e os dados foram para ele. O volume `db-data` ficou com uma pasta vazia, por cima.
5. A documentação da imagem avisa: nas versões 17 e anteriores, monte em `/var/lib/postgresql/data`, não em `/var/lib/postgresql`. Corrija o lado direito:

   ```yaml
   # a pasta exata dos dados no postgres:17
       volumes:
         - db-data:/var/lib/postgresql/data
   ```

6. Rode `docker compose down -v` uma vez (para apagar o volume anônimo e o `db-data` vazio), suba e repita o teste. A contagem passa a continuar.

O caminho certo depende da imagem e da versão: a partir do PostgreSQL 18, a documentação manda montar em `/var/lib/postgresql`. Confira sempre na página da imagem que você usa.

### 2. Complete

Um projeto tem um serviço `banco` com `postgres:17`, e os dados devem ficar num volume nomeado chamado `dados-banco`. Complete:

```yaml
# o volume é usado no serviço e declarado no topo
services:
  banco:
    image: postgres:17
    environment:
      POSTGRES_PASSWORD: ${DB_SENHA:?defina DB_SENHA no .env}
    volumes:
      - ________:________

________:
  ________:
```

<details>
<summary>Ver resposta</summary>

```yaml
services:
  banco:
    image: postgres:17
    environment:
      POSTGRES_PASSWORD: ${DB_SENHA:?defina DB_SENHA no .env}
    volumes:
      # nome do volume à esquerda, pasta de dados do postgres:17 à direita
      - dados-banco:/var/lib/postgresql/data

volumes:
  dados-banco:
```

Numa pasta `loja`, o volume vai se chamar `loja_dados-banco`. Erros comuns: indentar o `volumes:` do fim, que o põe dentro de `services` como se fosse um serviço; esquecer o `:` depois de `dados-banco` na declaração; e montar em `/var/lib/postgresql`, o erro do exemplo resolvido.

</details>

### 3. Sozinho

No `meu-site`, você quer editar o `index.html` no seu editor e ver a mudança no navegador sem reiniciar nada, e o nginx não deve conseguir alterar os seus arquivos. Diga qual tipo de montagem usar, escreva a linha de `volumes` do serviço `web` e preveja o que acontece se você trocar `./site` por `./paginas` sem criar a pasta `paginas`.

<details>
<summary>Ver resposta</summary>

Um bind mount, somente leitura:

```yaml
    # bind mount: a pasta site do projeto, e :ro para o nginx só ler
    volumes:
      - ./site:/usr/share/nginx/html:ro
```

É um bind mount porque os arquivos são seus e você os edita; o `:ro` impede o contêiner de gravar neles. Um volume nomeado não serve: os arquivos ficariam numa área do Docker, longe do seu editor.

Com `./paginas` sem a pasta existir, o Docker cria `paginas` vazia e a monta no lugar das páginas do nginx. O `up` não dá erro, mas o site responde `403 Forbidden`, como no teste com `./vazio` deste capítulo. Se você respondeu “o Compose dá erro de pasta inexistente”, essa é a expectativa natural, mas não é o que acontece.

</details>

### 4. Desafio

Depois de semanas de testes, uma colega renomeou a pasta do projeto de `contador` para `visitas-app`. Ao subir, a API respondeu `Visita número 1`, e ela achou que tinha perdido os dados. Explique: (a) os dados se perderam? (b) por que o contador recomeçou? (c) como fazer a pasta nova usar os dados antigos sem renomear nada de volta? Pense no que você sabe sobre o nome do projeto desde o capítulo 1.

<details>
<summary>Ver resposta</summary>

(a) Não. O volume `contador_db-data` continua na máquina, com as visitas dentro.

(b) O nome do projeto vem da pasta, e o nome do volume vem do projeto. Na pasta nova, o projeto se chama `visitas-app`, e o `up` criou um volume novo e vazio: a saída mostrou `Volume visitas-app_db-data Created`. O banco novo começou do zero.

(c) Fixe o nome do projeto com a chave `name` no topo do `compose.yaml`, como no capítulo 1:

```yaml
# o projeto volta a se chamar contador, e o volume, contador_db-data
name: contador
services:
  ...
```

No teste, com `name: contador` na pasta `visitas-app`, o `up` não criou nenhum volume, e a API respondeu `Visita número 3`, continuando a contagem antiga. O volume vazio `visitas-app_db-data` pode ser apagado com `docker volume rm visitas-app_db-data`, depois de conferir que é mesmo o vazio.

Uma resposta completa liga a pasta ao nome do projeto e o nome do projeto ao nome do volume. Um erro comum é tentar `down -v` na pasta nova “para resetar”: só apaga o volume vazio e não traz os dados antigos de volta.

</details>

## 🧠 Revisão rápida

1. Por que o contador do capítulo 6 voltava a 1 depois de um `down` e um `up`?
2. Que duas partes um volume nomeado precisa ter no `compose.yaml`?
3. Como o Compose sabe que `./site:/usr/share/nginx/html` é um bind mount e `db-data:/var/lib/postgresql/data` é um volume nomeado?
4. O que o `down -v` apaga que o `down` não apaga?
5. (Capítulo 5) Onde fica o `.env` do contador, e quem lê o `DB_SENHA` dele?

<details>
<summary>Ver resposta</summary>

1. Os dados ficavam num volume anônimo, e cada contêiner novo do banco ganhava outro volume anônimo, vazio.
2. O uso, em `volumes` do serviço (`db-data:/var/lib/postgresql/data`), e a declaração, em `volumes` do topo (`db-data:`).
3. Pelo lado esquerdo: um caminho (`./site`) é uma pasta do host; um nome sem barras (`db-data`) é um volume nomeado.
4. Os volumes nomeados declarados no arquivo e os volumes anônimos dos contêineres do projeto. Os bind mounts nunca são apagados.
5. Na pasta `contador`, ao lado do `compose.yaml`. Quem o lê é o Compose, para a interpolação; o valor chega aos contêineres pelas linhas de `environment` que citam `${DB_SENHA}`.

</details>

## 🤖 Estude com um tutor de IA

Copie e cole num assistente de IA:

```text
Estou aprendendo Docker Compose. Faça 5 perguntas, uma de cada vez,
sobre volume nomeado, volume anônimo, bind mount e a diferença entre
down e down -v. Inclua pelo menos uma pergunta de "o que acontece se".
Espere minha resposta antes de comentar e não me dê as respostas antes.
```

```text
Meus dados somem quando eu recrio o contêiner. Vou colar o compose.yaml
e a sequência de comandos que usei. Me ajude a descobrir a causa com
perguntas, sem me dar a solução pronta.
Arquivo e comandos: <cole aqui>
```

> ➡️ **Próximo passo:** o contador guarda os dados, mas ainda depende de você esperar alguns segundos depois do `up`, até o banco ficar pronto. No capítulo 8, a API passa a esperar o banco sozinha, com `healthcheck` e `depends_on`.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| Volume anônimo | Criado sem nome quando a imagem declara um volume; cada contêiner novo ganha outro |
| Volume nomeado | Declarado no topo e usado no serviço; sobrevive ao `down` e se chama `<projeto>_<nome>` |
| `volumes` do topo | Onde se declara o volume nomeado, no nível de `services` |
| Bind mount | Liga uma pasta do host (`./site`) a uma do contêiner; mudanças aparecem na hora |
| `:ro` | Monta somente leitura: o contêiner não grava ali |
| `down` | Mantém os volumes e os dados |
| `down -v` | Apaga os volumes nomeados e anônimos do projeto, sem desfazer |
| Caminho no contêiner | Depende da imagem: no `postgres:17`, `/var/lib/postgresql/data` |

## 📚 Fontes

- [Volumes (Compose file reference)](https://docs.docker.com/reference/compose-file/volumes/) (conferido em 20/11/2026)
- [docker compose down](https://docs.docker.com/reference/cli/docker/compose/down/) (conferido em 20/11/2026)
- [postgres (imagem oficial no Docker Hub)](https://hub.docker.com/_/postgres) (conferido em 21/11/2026)
- [WSL 2 best practices for Docker Desktop on Windows](https://docs.docker.com/desktop/features/wsl/best-practices/) (conferido em 21/11/2026)

> 🔁 **Revise hoje:** capítulos 4 e 6

<!-- nav:start -->
---

[◀ Capítulo anterior](06-varios-servicos-e-a-rede-do-projeto.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](08-ordem-de-inicio-e-saude.md)
<!-- nav:end -->
