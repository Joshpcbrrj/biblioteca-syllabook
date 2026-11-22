# 15. Simulado final

> 🗺️ **Neste capítulo:** 22 perguntas que cobrem todos os objetivos do livro, misturando capítulos e tipos de questão. Responda todas antes de abrir qualquer resposta, anote seus erros e use a tabela de diagnóstico do fim. · ⏱️ ~60 min

Deixe o terminal fechado na primeira passada: o objetivo é saber o que você já tem de cabeça. Depois, se quiser, confira no terminal as questões em que ficou em dúvida.

## Perguntas

**1.** Explique em uma frase a diferença entre o jeito imperativo de subir contêineres e o jeito declarativo do Compose.

<details>
<summary>Ver resposta</summary>

No imperativo, você dá as ordens uma por uma (`docker run` com todas as opções) e depende de lembrar de cada uma; no declarativo, você descreve no `compose.yaml` o estado que quer e o Compose faz o necessário para chegar nele. Revise no [capítulo 1](01-por-que-um-arquivo-para-o-projeto.md).

</details>

**2.** Num projeto da pasta `loja`, o serviço `api` tem duas instâncias. Como se chamam os contêineres, e como se chama a rede padrão do projeto?

<details>
<summary>Ver resposta</summary>

`loja-api-1` e `loja-api-2` (projeto, serviço e número); a rede é `loja_default`. O nome do projeto vem da pasta, a menos que a chave `name` diga outro. Revise nos capítulos [1](01-por-que-um-arquivo-para-o-projeto.md) e [6](06-varios-servicos-e-a-rede-do-projeto.md).

</details>

**3.** Num servidor Linux, `docker compose version` responde `docker: unknown command: docker compose`. O que falta, e como resolver?

<details>
<summary>Ver resposta</summary>

Falta o plugin do Compose, o programa que o `docker` procura na pasta `cli-plugins`. No Ubuntu, instale o pacote `docker-compose-plugin` pelo `apt` (do repositório do Docker) e rode `docker compose version` de novo. Revise no [capítulo 2](02-instalar-e-conferir-o-compose.md).

</details>

**4.** Este arquivo dá erro. Qual é a mensagem esperada do `docker compose config`, e o que está errado?

```yaml
services:
  web:
  image: nginx:1.27-alpine
```

<details>
<summary>Ver resposta</summary>

`services.image must be a mapping`. Como `image` está alinhada com `web`, o YAML a lê como um segundo serviço chamado `image`. A correção é indentar `image` dois espaços além de `web` (com espaços, nunca Tab). Revise no [capítulo 3](03-primeiro-compose-yaml.md).

</details>

**5.** Ordene os comandos para: subir o projeto em segundo plano, conferir os contêineres, ver as 20 últimas linhas do log do serviço `web` e derrubar tudo.

<details>
<summary>Ver resposta</summary>

`docker compose up -d`, `docker compose ps`, `docker compose logs -n 20 web` e `docker compose down`. Sem o `-d`, o `up` prende o terminal com os logs. Revise no [capítulo 3](03-primeiro-compose-yaml.md).

</details>

**6.** Depois do `docker compose down`, o que continua existindo: os contêineres, a rede, as imagens, os volumes, o `compose.yaml`?

<details>
<summary>Ver resposta</summary>

Continuam as imagens, os volumes e o `compose.yaml`. O `down` remove os contêineres e a rede do projeto. Revise nos capítulos [3](03-primeiro-compose-yaml.md) e [4](04-build-pelo-compose.md).

</details>

**7.** O `Dockerfile` da API está em `api/Dockerfile.dev`, e o `compose.yaml` está na pasta acima de `api`. Escreva a chave `build` do serviço.

<details>
<summary>Ver resposta</summary>

```yaml
    build:
      context: ./api
      dockerfile: Dockerfile.dev
```

O `context` parte da pasta do `compose.yaml`, e o `dockerfile` parte do contexto. Escrever `dockerfile: api/Dockerfile.dev` faria o Compose procurar `api/api/Dockerfile.dev`. Revise no [capítulo 4](04-build-pelo-compose.md).

</details>

**8.** Você mudou o `app.py` copiado pelo `Dockerfile` e rodou `docker compose up -d`. O `ps` mostra o contêiner `Running` e a API continua com o código antigo. Por quê?

<details>
<summary>Ver resposta</summary>

O `up -d` só constrói a imagem quando ela ainda não existe. Como ela já existia, o Compose a reaproveitou e não mexeu no contêiner. `docker compose up -d --build` reconstrói a imagem e recria o contêiner (`Recreate`). Revise no [capítulo 4](04-build-pelo-compose.md).

</details>

**9.** O `.env` tem `PORTA=9000`, e você roda `PORTA=7000 docker compose up -d`. Com `ports: - "${PORTA:-8000}:8000"`, qual porta do host é publicada? E sem `.env` e sem a variável no terminal?

<details>
<summary>Ver resposta</summary>

A 7000: a variável do terminal vence o `--env-file`, que vence o `.env`. Sem nenhuma das duas, vale o padrão, 8000. Para ver o valor final sem subir nada, use `docker compose config`. Revise no [capítulo 5](05-variaveis-env-e-configuracao.md).

</details>

**10.** Certo ou errado: “toda variável do `.env` chega automaticamente ao contêiner”. Justifique.

<details>
<summary>Ver resposta</summary>

Errado. O `.env` serve à interpolação do `compose.yaml`. Para a variável chegar ao contêiner, ela precisa estar em `environment` (por exemplo, `SAUDACAO: ${SAUDACAO:-Olá}`) ou num arquivo citado em `env_file`. Revise no [capítulo 5](05-variaveis-env-e-configuracao.md).

</details>

**11.** A API do projeto `contador` responde `Sem banco: ... Connection refused` com `DB_HOST: localhost`. Qual é a causa e qual valor resolve?

<details>
<summary>Ver resposta</summary>

Dentro do contêiner da API, `localhost` é a própria API, onde não há banco. Na rede do projeto, cada serviço é encontrado pelo nome: `DB_HOST: db`, com a porta do contêiner, 5432. Revise no [capítulo 6](06-varios-servicos-e-a-rede-do-projeto.md).

</details>

**12.** O serviço `db` não tem `ports`. A API consegue falar com ele? E você, do host, com um cliente na porta 5432?

<details>
<summary>Ver resposta</summary>

A API consegue, pela rede do projeto. Do host, não: sem `ports`, nada é publicado, e o `ps` mostra só `5432/tcp`, sem seta. Deixar o banco sem `ports` é o mais seguro; para acessá-lo do host em desenvolvimento, publique uma porta só no override. Revise nos capítulos [6](06-varios-servicos-e-a-rede-do-projeto.md) e [11](11-perfis-e-arquivos-sobrepostos.md).

</details>

**13.** Complete o arquivo para os dados do PostgreSQL sobreviverem a um `down`, num volume chamado `db-data`.

```yaml
services:
  db:
    image: postgres:17
    # ...
```

<details>
<summary>Ver resposta</summary>

```yaml
services:
  db:
    image: postgres:17
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

O volume aparece no serviço e é declarado na chave `volumes` do topo; sem a declaração, o Compose recusa com `undefined volume`. Os dados só somem com `docker compose down -v`. Revise no [capítulo 7](07-volumes-no-compose.md).

</details>

**14.** O `up` falha com `dependency failed to start: container contador-db-1 is unhealthy`. O que essa mensagem diz, e onde você investiga primeiro?

<details>
<summary>Ver resposta</summary>

A API tem `depends_on` com `condition: service_healthy`, e o `healthcheck` do `db` falhou todas as tentativas, então a API não chegou a iniciar. Investigue o teste do `healthcheck` do `db`, com `docker compose ps` e `docker inspect` no campo `.State.Health`, que guarda a saída das últimas tentativas. Um comando que não existe na imagem, como `curl`, é causa comum. Revise no [capítulo 8](08-ordem-de-inicio-e-saude.md).

</details>

**15.** Qual comando você usa para cada caso: (a) abrir o `psql` no banco que já está rodando; (b) rodar um script de migração num contêiner novo, que some ao terminar; (c) copiar o arquivo `/tmp/visitas.sql` do serviço `db` para a pasta atual?

<details>
<summary>Ver resposta</summary>

(a) `docker compose exec db psql -U postgres`; (b) `docker compose run --rm api <comando>`, e sem o `--rm` sobra um contêiner que faz o `down` parar em `Resource is still in use`; (c) `docker compose cp db:/tmp/visitas.sql ./visitas.sql`, com a origem sempre primeiro e o nome do serviço, não o do contêiner. Revise no [capítulo 9](09-comandos-do-dia-a-dia.md).

</details>

**16.** No serviço `db`, você escreveu `command: postgres -c log_statement=all`. E se tivesse escrito `entrypoint: postgres -c log_statement=all`? O que muda?

<details>
<summary>Ver resposta</summary>

O `command` troca só o `CMD` da imagem e mantém o `ENTRYPOINT`, o script que prepara o banco; funciona. O `entrypoint` troca o `ENTRYPOINT` e ignora o `CMD`: o `postgres` roda sem o script da imagem e, no teste do livro, recusou rodar como root. Revise no [capítulo 9](09-comandos-do-dia-a-dia.md).

</details>

**17.** Associe cada mudança à ação do `develop.watch`: (a) uma página HTML servida pelo nginx; (b) o `app.py` de um servidor que só lê o código ao iniciar; (c) o `Dockerfile`. Ações: `sync`, `sync+restart`, `rebuild`.

<details>
<summary>Ver resposta</summary>

(a) `sync`; (b) `sync+restart`; (c) `rebuild`, que exige a chave `build` no serviço. Para rodar um comando depois de copiar, como `nginx -s reload`, existe `sync+exec`. Revise no [capítulo 10](10-desenvolvimento-com-watch.md).

</details>

**18.** O serviço `adminer` tem `profiles: [ferramentas]`. O que sobe com `docker compose up -d`? E com `docker compose --profile ferramentas up -d`?

<details>
<summary>Ver resposta</summary>

Sem o perfil, sobem só os serviços sem `profiles`; o `adminer` fica de fora. Com `--profile ferramentas` (ou `COMPOSE_PROFILES=ferramentas`), sobe também o `adminer`. Lembre de usar o mesmo perfil no `down`, ou o `adminer` e a rede ficam. Revise no [capítulo 11](11-perfis-e-arquivos-sobrepostos.md).

</details>

**19.** O `compose.yaml` publica a API em `127.0.0.1:8000:8000`, e o `compose.prod.yaml` declara `ports: - "0.0.0.0:80:8000"`. Com `docker compose -f compose.yaml -f compose.prod.yaml config`, quais portas a API tem? Como ficar só com a 80?

<details>
<summary>Ver resposta</summary>

As duas: no merge, listas como `ports` são somadas. Para trocar a lista inteira, use `ports: !override` no `compose.prod.yaml`. Note também que, com `-f`, o `compose.override.yaml` não é lido. Revise no [capítulo 11](11-perfis-e-arquivos-sobrepostos.md).

</details>

**20.** Por que trocar `environment: POSTGRES_PASSWORD: ...` por um secret? E em que caminho o contêiner lê o secret `db_senha`?

<details>
<summary>Ver resposta</summary>

Porque a variável de ambiente vaza no `docker compose config`, no `docker inspect` e no `printenv` dentro do contêiner. O secret chega como arquivo somente leitura em `/run/secrets/db_senha`, e a imagem do PostgreSQL o lê com `POSTGRES_PASSWORD_FILE: /run/secrets/db_senha`. O arquivo de origem fica fora do Git, no `.gitignore`. Revise no [capítulo 12](12-segredos-e-dados-sensiveis.md).

</details>

**21.** Com `deploy.resources.limits.memory: 64M`, o processo tenta usar 200 MB. O que acontece? E com `cpus: "0.50"` e um cálculo pesado?

<details>
<summary>Ver resposta</summary>

Acima do limite de memória, o processo é morto: o contêiner sai com código 137 e o `docker inspect` mostra `OOMKilled` como `true`. Acima do limite de CPU, nada é morto; o processo só fica mais lento, perto de 50% de um núcleo no `docker stats`. Revise no [capítulo 13](13-recursos-e-escala.md).

</details>

**22.** Na stack final, por que o `proxy_pass` do nginx aponta para `http://api:8000`, e o que é preciso fazer depois de `--scale api=3`? Para fechar: em produção, a imagem da API se chama `localhost:5000/stack-api:1.0`. Que comando a envia ao registro, e por que o mesmo comando responde `Skipped` em desenvolvimento?

<details>
<summary>Ver resposta</summary>

O proxy fala com a API pela rede do projeto: nome do serviço e porta do contêiner; só o proxy publica porta. Depois de mudar as réplicas, recarregue o nginx (`docker compose exec proxy nginx -s reload`), que só descobre os endereços de `api` ao iniciar ou recarregar. A imagem vai ao registro com `docker compose -f compose.yaml -f compose.prod.yaml push api`; em desenvolvimento, sem o arquivo de produção, a API não tem `image`, e o `push` pula serviços sem nome de imagem. Revise no [capítulo 14](14-projeto-final-stack-completa.md).

</details>

## Diagnóstico

| Se você errou... | Revise |
| --- | --- |
| as perguntas 1 e 2 | [capítulo 1](01-por-que-um-arquivo-para-o-projeto.md) |
| a pergunta 3 | [capítulo 2](02-instalar-e-conferir-o-compose.md) |
| as perguntas 4, 5 e 6 | [capítulo 3](03-primeiro-compose-yaml.md) |
| as perguntas 7 e 8 | [capítulo 4](04-build-pelo-compose.md) |
| as perguntas 9 e 10 | [capítulo 5](05-variaveis-env-e-configuracao.md) |
| as perguntas 11 e 12 | [capítulo 6](06-varios-servicos-e-a-rede-do-projeto.md) |
| a pergunta 13 | [capítulo 7](07-volumes-no-compose.md) |
| a pergunta 14 | [capítulo 8](08-ordem-de-inicio-e-saude.md) |
| as perguntas 15 e 16 | [capítulo 9](09-comandos-do-dia-a-dia.md) |
| a pergunta 17 | [capítulo 10](10-desenvolvimento-com-watch.md) |
| as perguntas 18 e 19 | [capítulo 11](11-perfis-e-arquivos-sobrepostos.md) |
| a pergunta 20 | [capítulo 12](12-segredos-e-dados-sensiveis.md) |
| a pergunta 21 | [capítulo 13](13-recursos-e-escala.md) |
| a pergunta 22 | [capítulo 14](14-projeto-final-stack-completa.md) |

Acertou 18 ou mais? Você domina o que o livro propôs. Entre 12 e 17, revise os capítulos da tabela e refaça só as perguntas que errou daqui a três dias. Menos de 12, refaça o *Pratique* dos capítulos indicados antes de tentar de novo.

> ➡️ **Próximo passo:** o [Glossário](glossario.md) reúne os termos do livro, e os *Próximos caminhos*, no fim do capítulo 14, sugerem o que estudar a seguir.

<!-- nav:start -->
---

[◀ Capítulo anterior](14-projeto-final-stack-completa.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](glossario.md)
<!-- nav:end -->
