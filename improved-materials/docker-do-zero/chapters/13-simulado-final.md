# 13. Simulado final

> 🗺️ **Neste capítulo:** 29 perguntas que cobrem todos os objetivos do livro, misturando capítulos e tipos de questão. Responda todas antes de abrir qualquer resposta, anote seus erros e use a tabela de diagnóstico do fim. · ⏱️ ~60 min

Deixe o terminal fechado na primeira passada: o objetivo é saber o que você já tem de cabeça. Depois, se quiser, confira no terminal as questões em que ficou em dúvida. Nas respostas, as senhas são sempre de laboratório.

## Perguntas

**1.** Explique em duas frases a diferença entre imagem e contêiner.

<details>
<summary>Ver resposta</summary>

A imagem é o pacote somente leitura com o ambiente pronto (a receita); o contêiner é um processo isolado criado a partir dela (a cozinha em funcionamento). Da mesma imagem saem quantos contêineres você quiser. Revise no [capítulo 1](01-por-que-conteineres-existem.md).

</details>

**2.** Verdadeiro ou falso: um contêiner de Alpine e um de Debian, na mesma máquina, mostram versões de kernel diferentes no `uname -r`. Justifique.

<details>
<summary>Ver resposta</summary>

Falso. O contêiner não traz kernel: os dois usam o do host, e o `uname -r` mostra o mesmo valor. O que muda entre eles são os arquivos da distribuição. Revise no [capítulo 1](01-por-que-conteineres-existem.md).

</details>

**3.** Depois de rodar `wsl --install` num terminal de administrador, que passos faltam antes de usar o Docker Desktop com o backend WSL 2?

<details>
<summary>Ver resposta</summary>

Reiniciar o computador e atualizar o WSL com `wsl --update`. Em seguida, instale o Docker Desktop e confirme com `docker run --rm hello-world`. Revise no [capítulo 2](02-docker-desktop-no-windows-ativar-e-instalar.md).

</details>

**4.** O comando `docker` funciona no PowerShell, mas dá `command not found` no Ubuntu do WSL. O que falta?

<details>
<summary>Ver resposta</summary>

Ligar a integração com a distro em **Settings > Resources > WSL integration** do Docker Desktop, escolhendo o Ubuntu. Se houver um Docker Engine instalado dentro da distro, remova-o antes, porque os dois juntos conflitam. Revise no [capítulo 2](02-docker-desktop-no-windows-ativar-e-instalar.md).

</details>

**5.** Numa instalação do Engine no Ubuntu pelo repositório oficial, que pacotes você remove antes e por quê?

<details>
<summary>Ver resposta</summary>

Os que conflitam com o Engine da Docker: `docker.io`, `podman-docker`, `containerd` e `runc` do Ubuntu. Depois entram a chave GPG, a fonte `docker.sources` e os pacotes `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin` e `docker-compose-plugin`. Revise no [capítulo 3](03-instalar-no-linux-e-no-mac.md).

</details>

**6.** Um servidor Linux tem o `ufw` bloqueando tudo, mas um contêiner com `-p 8080:80` responde a outros computadores da rede. Por quê, e como evitar?

<details>
<summary>Ver resposta</summary>

As portas publicadas pelo Docker passam por fora das regras do `ufw` (e do `firewalld`). Para o serviço ficar só na máquina, publique com `-p 127.0.0.1:8080:80`. Revise no [capítulo 3](03-instalar-no-linux-e-no-mac.md).

</details>

**7.** Escreva o comando que roda a imagem `python:3.14-slim` em segundo plano, com o nome `dz-web`, publicando a porta 8000 do contêiner na 8080 do seu computador, acessível só por ele.

<details>
<summary>Ver resposta</summary>

`docker run -d --name dz-web -p 127.0.0.1:8080:8000 python:3.14-slim ...` (o comando do servidor vem depois da imagem). As opções vêm antes da imagem, e na porta o host vem primeiro. Revise no [capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md).

</details>

**8.** Um `docker stop` demorou alguns segundos e `docker ps -a` mostra `Exited (137)`. O que aconteceu e como o `--init` muda o resultado?

<details>
<summary>Ver resposta</summary>

O processo principal (PID 1) ignorou o SIGTERM, o prazo acabou e o Docker mandou SIGKILL: 128 + 9 = 137. Com `--init`, um mini-processo (`tini`) repassa o sinal, o contêiner termina por SIGTERM e o código é 143. Revise no [capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md).

</details>

**9.** Como ver só as 20 últimas linhas de log de `dz-web` e continuar acompanhando as novas?

<details>
<summary>Ver resposta</summary>

`docker logs --tail 20 -f dz-web`. O `--tail` limita as linhas; o `-f` (*follow*) acompanha. `Ctrl+C` encerra o acompanhamento sem parar o contêiner. Revise no [capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md).

</details>

**10.** Você criou um contêiner pela janela do Docker Desktop. Ele aparece no `docker ps` do terminal? Por quê?

<details>
<summary>Ver resposta</summary>

Aparece. A janela e a linha de comando são dois clientes do mesmo motor (Engine): o que um cria, o outro vê. Revise no [capítulo 5](05-docker-desktop-na-pratica-interface-linha-de.md).

</details>

**11.** Cite as três formas de escolher o contexto da CLI e diga o alcance de cada uma.

<details>
<summary>Ver resposta</summary>

`--context <nome>` vale para um comando; a variável `DOCKER_CONTEXT` vale para o terminal em que foi definida; `docker context use <nome>` muda o padrão para tudo. Revise no [capítulo 5](05-docker-desktop-na-pratica-interface-linha-de.md).

</details>

**12.** Divida `docker.io/library/python:3.14-slim` nas quatro partes do nome de uma imagem.

<details>
<summary>Ver resposta</summary>

Registro: `docker.io`; namespace: `library`; repositório: `python`; tag: `3.14-slim`. Sem registro, o Docker Hub é o padrão, e sem tag vale `latest`. Revise no [capítulo 6](06-imagens-e-o-docker-hub.md).

</details>

**13.** Qual a diferença entre referenciar uma imagem pela tag e pelo digest? Quando o digest compensa?

<details>
<summary>Ver resposta</summary>

A tag é um rótulo móvel, que o autor pode passar para outra imagem; o digest (`@sha256:...`) identifica sempre o mesmo conteúdo. Compensa quando você precisa de uma construção reproduzível ou quer ter certeza do que roda. Revise no [capítulo 6](06-imagens-e-o-docker-hub.md).

</details>

**14.** O `docker rmi` de uma imagem recusa a remoção porque um contêiner parado a usa. O que fazer?

<details>
<summary>Ver resposta</summary>

Remover primeiro o contêiner (`docker rm <nome>`) e depois a imagem. O `docker rmi` só retira a etiqueta quando há outras apontando para a imagem, e a apaga de fato na última. Revise no [capítulo 6](06-imagens-e-o-docker-hub.md).

</details>

**15.** O que o `EXPOSE 8000` do Dockerfile faz, e quem de fato torna a porta acessível no seu computador?

<details>
<summary>Ver resposta</summary>

Só documenta a porta em que o programa escuta. Quem publica é o `-p` no `docker run`. Revise no [capítulo 7](07-seu-primeiro-dockerfile.md).

</details>

**16.** Explique `ENTRYPOINT` × `CMD` e por que o livro usa sempre a forma exec.

<details>
<summary>Ver resposta</summary>

O `ENTRYPOINT` é o programa fixo; o `CMD` é o padrão (por exemplo, os argumentos), que o que vem depois da imagem no `docker run` substitui. Na forma exec (`["python", "app.py"]`) o programa é o PID 1 e recebe o SIGTERM; na forma shell o PID 1 é o `sh`, que não repassa o sinal. Revise no [capítulo 7](07-seu-primeiro-dockerfile.md).

</details>

**17.** Para que serve o `.dockerignore` e que arquivo nunca deve ir parar na imagem por descuido?

<details>
<summary>Ver resposta</summary>

Lista o que fica fora do contexto de build: o envio é menor e nada indesejado entra no `COPY`. O arquivo `.env` (com segredos) é o exemplo clássico: nunca deve ser copiado para a imagem. Revise no [capítulo 7](07-seu-primeiro-dockerfile.md).

</details>

**18.** Por que o `COPY requirements.txt .` e o `pip install` vêm antes do `COPY app.py .`? Que ganho de tempo o livro mediu?

<details>
<summary>Ver resposta</summary>

Para o cache: quando só o código muda, as camadas anteriores são reaproveitadas e o `pip install` não se repete. No projeto, o build caiu de cerca de 8,9 s para 1,5 s. Revise no [capítulo 8](08-builds-rapidos-e-imagens-enxutas.md).

</details>

**19.** Por que apagar as listas do `apt` num `RUN` separado não diminui a imagem?

<details>
<summary>Ver resposta</summary>

Cada instrução cria uma camada, e a camada anterior continua guardando os arquivos. A limpeza precisa estar no mesmo `RUN` que instalou, para que os arquivos nunca cheguem a ficar na camada. Revise no [capítulo 8](08-builds-rapidos-e-imagens-enxutas.md).

</details>

**20.** O que muda num build multi-stage, e o que o livro obteve com ele no projeto?

<details>
<summary>Ver resposta</summary>

Há vários `FROM`; o estágio de build compila as dependências e só o necessário vai para o estágio final com `COPY --from=`, sem o compilador (`gcc`). A imagem caiu de cerca de 511 MB para 197 MB. Revise no [capítulo 8](08-builds-rapidos-e-imagens-enxutas.md).

</details>

**21.** O que acontece com os arquivos que um contêiner grava na própria camada quando ele é removido? Como o `docker diff` ajuda a perceber isso?

<details>
<summary>Ver resposta</summary>

Somem junto com o contêiner. O `docker diff` mostra o que foi alterado na camada gravável desde a criação do contêiner: tudo o que aparece ali e não está num volume vai embora com o `docker rm`. Revise no [capítulo 9](09-volumes-dados-que-sobrevivem.md).

</details>

**22.** O `docker run` do PostgreSQL 18 com `-v dz-dados:/var/lib/postgresql/data` falha. Qual é o ajuste?

<details>
<summary>Ver resposta</summary>

A partir do PostgreSQL 18, o volume deve ser montado em `/var/lib/postgresql` (os dados ficam em `18/docker` dentro dele). Confira o caminho na página da imagem no Docker Hub. Revise no [capítulo 9](09-volumes-dados-que-sobrevivem.md).

</details>

**23.** Quando usar um bind mount em vez de um volume nomeado, e quando o oposto?

<details>
<summary>Ver resposta</summary>

Bind mount: ligar uma pasta do seu computador, como o código em desenvolvimento, para ver as mudanças sem reconstruir a imagem. Volume nomeado: dados que o contêiner produz, como os de um banco, geridos pelo Docker. Revise no [capítulo 9](09-volumes-dados-que-sobrevivem.md).

</details>

**24.** Na rede padrão (`bridge`), por que um contêiner não acha o outro pelo nome, e o que muda numa rede criada por você?

<details>
<summary>Ver resposta</summary>

Na rede padrão não há resolução de nomes: só dá para usar o IP, que muda. Numa rede criada com `docker network create`, o DNS do Docker resolve o nome do contêiner (e o `--network-alias`). Revise no [capítulo 10](10-redes-conteineres-que-conversam.md).

</details>

**25.** No projeto, só a API tem `-p`. Por que o banco fica sem publicar porta?

<details>
<summary>Ver resposta</summary>

Quem precisa do banco é a API, que está na mesma rede e o acha pelo nome. Publicar a porta do banco exporia o serviço ao seu computador (ou à rede) sem necessidade. Revise no [capítulo 10](10-redes-conteineres-que-conversam.md).

</details>

**26.** Escreva os comandos que dão à imagem `dz-api:1.1` o nome de um repositório `usuario/tarefas-api` com as tags `1.1.0` e `1.1` e enviam as duas.

<details>
<summary>Ver resposta</summary>

`docker tag dz-api:1.1 usuario/tarefas-api:1.1.0`, `docker tag dz-api:1.1 usuario/tarefas-api:1.1`, depois `docker push usuario/tarefas-api:1.1.0` e `docker push usuario/tarefas-api:1.1`. O segundo `push` envia quase nada: as camadas já estão no registro. Revise no [capítulo 11](11-publicar-a-imagem.md).

</details>

**27.** Como fazer o `docker login` sem expor a credencial, e por que não usar a senha da conta?

<details>
<summary>Ver resposta</summary>

Crie um token de acesso pessoal, guarde-o numa variável de ambiente e use `docker login -u <usuario> --password-stdin`, alimentando a entrada padrão com ela. O token tem permissões limitadas e pode ser revogado sem trocar a senha da conta. Revise no [capítulo 11](11-publicar-a-imagem.md).

</details>

**28.** Como o projeto passa o endereço e a senha do banco para a API, e por que não os escrever no código ou na imagem?

<details>
<summary>Ver resposta</summary>

Por variáveis de ambiente (`-e DB_HOST=dz-db`, `-e DB_PASSWORD=...`). Na imagem ou no código, o valor viraria parte do artefato publicado e igual para todos os ambientes; por variável, a mesma imagem serve a qualquer ambiente. Revise no [capítulo 12](12-projeto-final-api-com-banco-em-conteineres.md).

</details>

**29.** Você removeu os contêineres da API e do banco, mas manteve o volume `dz-dados`. Como recuperar o projeto, e o que a API faz se o banco estiver fora do ar?

<details>
<summary>Ver resposta</summary>

Recrie a rede (se removida), o banco com o mesmo `-v dz-dados:/var/lib/postgresql` e a API: as tarefas continuam lá. Com o banco fora do ar, a API responde `503` em vez de quebrar; ao iniciar, ela tenta se conectar por até 30 tentativas, registrando "Aguardando o banco". Revise no [capítulo 12](12-projeto-final-api-com-banco-em-conteineres.md).

</details>

## Diagnóstico

| Se você errou... | Revise |
| --- | --- |
| as perguntas 1 e 2 | [capítulo 1](01-por-que-conteineres-existem.md) |
| as perguntas 3 e 4 | [capítulo 2](02-docker-desktop-no-windows-ativar-e-instalar.md) |
| as perguntas 5 e 6 | [capítulo 3](03-instalar-no-linux-e-no-mac.md) |
| as perguntas 7, 8 e 9 | [capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md) |
| as perguntas 10 e 11 | [capítulo 5](05-docker-desktop-na-pratica-interface-linha-de.md) |
| as perguntas 12, 13 e 14 | [capítulo 6](06-imagens-e-o-docker-hub.md) |
| as perguntas 15, 16 e 17 | [capítulo 7](07-seu-primeiro-dockerfile.md) |
| as perguntas 18, 19 e 20 | [capítulo 8](08-builds-rapidos-e-imagens-enxutas.md) |
| as perguntas 21, 22 e 23 | [capítulo 9](09-volumes-dados-que-sobrevivem.md) |
| as perguntas 24 e 25 | [capítulo 10](10-redes-conteineres-que-conversam.md) |
| as perguntas 26 e 27 | [capítulo 11](11-publicar-a-imagem.md) |
| as perguntas 28 e 29 | [capítulo 12](12-projeto-final-api-com-banco-em-conteineres.md) |

Acertou 23 ou mais? Você domina o que o livro propôs. Entre 16 e 22, revise os capítulos da tabela e refaça só as perguntas que errou daqui a três dias. Menos de 16, refaça o *Pratique* dos capítulos indicados antes de tentar de novo.

> ➡️ **Próximo passo:** o [Glossário](glossario.md) reúne os termos do livro, e a seção *Próximos caminhos*, no fim do capítulo 12, sugere o que estudar a seguir.

<!-- nav:start -->
---

[◀ Capítulo anterior](12-projeto-final-api-com-banco-em-conteineres.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](glossario.md)
<!-- nav:end -->
