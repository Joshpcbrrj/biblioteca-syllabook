# Glossário

Um termo por linha, em ordem alfabética, com o termo em inglês quando ele é diferente e o link para o capítulo que o explica.

- **Alias de rede** (*network alias*): nome extra pelo qual um contêiner é achado numa rede criada pelo usuário. [Capítulo 10](10-redes-conteineres-que-conversam.md)
- **`ARG`:** variável do Dockerfile que só existe durante o build, mas aparece no `docker history`. [Capítulo 7](07-seu-primeiro-dockerfile.md)
- **Backend WSL 2** (*WSL 2 backend*): modo do Docker Desktop no Windows que roda o motor num Linux leve gerenciado pelo WSL. [Capítulo 2](02-docker-desktop-no-windows-ativar-e-instalar.md)
- **Bind mount:** pasta do seu computador ligada a uma pasta do contêiner. [Capítulo 9](09-volumes-dados-que-sobrevivem.md)
- **Build multi-stage** (*multi-stage build*): Dockerfile com vários `FROM`, em que só o último estágio vira a imagem final. [Capítulo 8](08-builds-rapidos-e-imagens-enxutas.md)
- **Cache de build** (*build cache*): camadas reaproveitadas quando a instrução e os arquivos não mudaram. [Capítulo 8](08-builds-rapidos-e-imagens-enxutas.md)
- **Camada** (*layer*): parte somente leitura de uma imagem, criada por uma instrução do Dockerfile. [Capítulo 6](06-imagens-e-o-docker-hub.md)
- **Camada gravável** (*writable layer*): espaço de escrita do contêiner, que some com ele. [Capítulo 9](09-volumes-dados-que-sobrevivem.md)
- **cgroups:** recurso do kernel que limita o uso de CPU, memória e outros recursos de um grupo de processos. [Capítulo 1](01-por-que-conteineres-existem.md)
- **`CMD`:** instrução que define o comando padrão do contêiner; o `docker run` pode substituí-lo. [Capítulo 7](07-seu-primeiro-dockerfile.md)
- **containerd:** componente por baixo do Docker Engine que cuida do ciclo de vida dos contêineres. [Capítulo 1](01-por-que-conteineres-existem.md)
- **Contêiner** (*container*): processo isolado do sistema, criado a partir de uma imagem. [Capítulo 1](01-por-que-conteineres-existem.md)
- **Contexto da CLI** (*context*): nome que guarda o endereço do motor com o qual o `docker` conversa. [Capítulo 5](05-docker-desktop-na-pratica-interface-linha-de.md)
- **Contexto de build** (*build context*): conjunto de arquivos enviado ao Docker quando você roda `docker build`. [Capítulo 7](07-seu-primeiro-dockerfile.md)
- **Dangling:** imagem sem tag (`<none>:<none>`). [Capítulo 6](06-imagens-e-o-docker-hub.md)
- **Digest:** identificador `sha256:` do conteúdo exato de uma imagem. [Capítulo 6](06-imagens-e-o-docker-hub.md)
- **Docker Desktop:** aplicativo que reúne o motor, a CLI e uma janela de gerenciamento. [Capítulo 2](02-docker-desktop-no-windows-ativar-e-instalar.md)
- **Docker Engine:** o serviço `dockerd`, que recebe os pedidos da CLI e cuida de imagens, contêineres, redes e volumes. [Capítulo 1](01-por-que-conteineres-existem.md)
- **Docker Hub:** registro público padrão do Docker. [Capítulo 6](06-imagens-e-o-docker-hub.md)
- **Dockerfile:** arquivo de texto com as instruções para construir uma imagem. [Capítulo 7](07-seu-primeiro-dockerfile.md)
- **`.dockerignore`:** arquivo que lista o que fica fora do contexto de build, para a imagem sair menor e sem segredos. [Capítulo 7](07-seu-primeiro-dockerfile.md)
- **`ENTRYPOINT`:** instrução que define o programa fixo do contêiner. [Capítulo 7](07-seu-primeiro-dockerfile.md)
- **`ENV`:** variável de ambiente definida na imagem e visível no contêiner. [Capítulo 7](07-seu-primeiro-dockerfile.md)
- **Estados do contêiner** (*container states*): `created`, `running`, `paused` e `exited`. [Capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md)
- **Forma exec** (*exec form*): `CMD ["programa", "argumento"]`, em que o programa é o PID 1. [Capítulo 7](07-seu-primeiro-dockerfile.md)
- **Grupo `docker`** (*docker group*): grupo do Linux que dá acesso ao socket do Docker, com poder equivalente ao de root. [Capítulo 3](03-instalar-no-linux-e-no-mac.md)
- **Host:** o computador (ou a VM) em que o Docker roda. [Capítulo 1](01-por-que-conteineres-existem.md)
- **`host.docker.internal`:** nome que o contêiner usa para falar com o computador hospedeiro. [Capítulo 10](10-redes-conteineres-que-conversam.md)
- **Imagem** (*image*): pacote somente leitura (camadas mais configuração) do qual saem os contêineres. [Capítulo 1](01-por-que-conteineres-existem.md)
- **Kernel:** núcleo do sistema operacional, compartilhado entre o host e os contêineres. [Capítulo 1](01-por-que-conteineres-existem.md)
- **Multi-arquitetura** (*multi-platform image*): tag que aponta para imagens de várias plataformas. [Capítulo 6](06-imagens-e-o-docker-hub.md)
- **Namespaces:** recurso do kernel que dá a cada contêiner a sua visão de processos, rede e arquivos. [Capítulo 1](01-por-que-conteineres-existem.md)
- **PID 1:** processo principal do contêiner, o que recebe os sinais do `docker stop`. [Capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md)
- **Porta publicada** (*published port*): porta do contêiner ligada a uma do host com `-p`. [Capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md)
- **Rede definida pelo usuário** (*user-defined network*): rede criada com `docker network create`, com resolução de nomes. [Capítulo 10](10-redes-conteineres-que-conversam.md)
- **Registro** (*registry*): servidor que guarda imagens em repositórios. [Capítulo 11](11-publicar-a-imagem.md)
- **SIGKILL e SIGTERM:** sinais que o `docker stop` envia; o SIGTERM pede para terminar, o SIGKILL encerra na hora. [Capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md)
- **Socket do Docker** (*Docker socket*): arquivo pelo qual a CLI conversa com o Engine. [Capítulo 3](03-instalar-no-linux-e-no-mac.md)
- **Tag:** rótulo móvel de uma imagem, como `3.14-slim`. [Capítulo 6](06-imagens-e-o-docker-hub.md)
- **tmpfs:** montagem que guarda os dados só na memória. [Capítulo 9](09-volumes-dados-que-sobrevivem.md)
- **Token de acesso pessoal** (*personal access token*): credencial com permissões limitadas, usada no lugar da senha da conta. [Capítulo 11](11-publicar-a-imagem.md)
- **Volume nomeado** (*named volume*): armazenamento criado e gerenciado pelo Docker, que sobrevive ao contêiner. [Capítulo 9](09-volumes-dados-que-sobrevivem.md)
- **WSL 2:** o Subsistema Windows para Linux, versão 2. [Capítulo 2](02-docker-desktop-no-windows-ativar-e-instalar.md)

<!-- index:start -->
## Índice remissivo

- backend WSL 2: [2. Docker Desktop no Windows: ativar e instalar](02-docker-desktop-no-windows-ativar-e-instalar.md)
- bind mount: [9. Volumes: dados que sobrevivem](09-volumes-dados-que-sobrevivem.md)
- build multi-stage: [8. Builds rápidos e imagens enxutas](08-builds-rapidos-e-imagens-enxutas.md)
- cache de build: [8. Builds rápidos e imagens enxutas](08-builds-rapidos-e-imagens-enxutas.md)
- camadas: [6. Imagens e o Docker Hub](06-imagens-e-o-docker-hub.md)
- CMD × ENTRYPOINT: [7. Seu primeiro Dockerfile](07-seu-primeiro-dockerfile.md)
- configuração por variáveis de ambiente: [12. Projeto final: API com banco em contêineres](12-projeto-final-api-com-banco-em-conteineres.md)
- contexto de build e .dockerignore: [7. Seu primeiro Dockerfile](07-seu-primeiro-dockerfile.md)
- contextos da CLI: [5. Docker Desktop na prática: interface × linha de comando](05-docker-desktop-na-pratica-interface-linha-de.md)
- contêiner: [1. Por que contêineres existem](01-por-que-conteineres-existem.md)
- contêiner × máquina virtual: [1. Por que contêineres existem](01-por-que-conteineres-existem.md)
- Docker Desktop: [2. Docker Desktop no Windows: ativar e instalar](02-docker-desktop-no-windows-ativar-e-instalar.md)
- Docker Engine (cliente e servidor): [1. Por que contêineres existem](01-por-que-conteineres-existem.md)
- docker push e pull: [11. Publicar a imagem](11-publicar-a-imagem.md)
- docker run e suas opções: [4. Ciclo de vida do contêiner na linha de comando](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md)
- Dockerfile: [7. Seu primeiro Dockerfile](07-seu-primeiro-dockerfile.md)
- estados do contêiner: [4. Ciclo de vida do contêiner na linha de comando](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md)
- grupo docker e o socket: [3. Instalar no Linux e no Mac](03-instalar-no-linux-e-no-mac.md)
- imagem: [1. Por que contêineres existem](01-por-que-conteineres-existem.md)
- isolamento (namespaces e cgroups): [1. Por que contêineres existem](01-por-que-conteineres-existem.md)
- logs, exec e inspect: [4. Ciclo de vida do contêiner na linha de comando](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md)
- publicar portas (-p): [4. Ciclo de vida do contêiner na linha de comando](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md)
- rede definida pelo usuário: [10. Redes: contêineres que conversam](10-redes-conteineres-que-conversam.md)
- registro (Docker Hub): [6. Imagens e o Docker Hub](06-imagens-e-o-docker-hub.md)
- repositório oficial do Docker (apt): [3. Instalar no Linux e no Mac](03-instalar-no-linux-e-no-mac.md)
- resolução por nome do contêiner: [10. Redes: contêineres que conversam](10-redes-conteineres-que-conversam.md)
- tag × digest: [6. Imagens e o Docker Hub](06-imagens-e-o-docker-hub.md)
- token de acesso pessoal: [11. Publicar a imagem](11-publicar-a-imagem.md)
- volume nomeado: [9. Volumes: dados que sobrevivem](09-volumes-dados-que-sobrevivem.md)
<!-- index:end -->

<!-- credit:start -->
---

📘 *Criado pela skill Claude Syllabook - Joshpcbrrj* · [github.com/Joshpcbrrj/syllabook](https://github.com/Joshpcbrrj/syllabook)
<!-- credit:end -->

<!-- nav:start -->
---

[◀ Capítulo anterior](13-simulado-final.md) · [Mapa do livro](../README.md)
<!-- nav:end -->
