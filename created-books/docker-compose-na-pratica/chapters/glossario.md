# Glossário

Um termo por linha, em ordem alfabética, com o termo em inglês quando ele é diferente e o link para o capítulo que o explica.

- **`.env`:** arquivo ao lado do `compose.yaml` com valores para a interpolação; não chega sozinho ao contêiner. [Capítulo 5](05-variaveis-env-e-configuracao.md)
- **Ação do watch** (*watch action*): o que o `develop.watch` faz ao ver uma mudança: `sync`, `sync+restart`, `sync+exec` ou `rebuild`. [Capítulo 10](10-desenvolvimento-com-watch.md)
- **Arquivo sobreposto** (*override file*): arquivo do Compose que se junta ao `compose.yaml`, como o `compose.override.yaml`, lido sozinho, ou os passados com `-f`. [Capítulo 11](11-perfis-e-arquivos-sobrepostos.md)
- **Bind mount:** pasta do host montada dentro do contêiner, em que as mudanças aparecem na hora. [Capítulo 7](07-volumes-no-compose.md)
- **Build multi-stage** (*multi-stage build*): `Dockerfile` com vários estágios (`FROM ... AS <nome>`), dos quais `build.target` escolhe qual construir. [Capítulo 14](14-projeto-final-stack-completa.md)
- **Build pelo Compose:** a chave `build`, que faz o Compose construir a imagem do serviço a partir de um `Dockerfile`. [Capítulo 4](04-build-pelo-compose.md)
- **`command`:** chave que troca o `CMD` da imagem e mantém o `ENTRYPOINT`. [Capítulo 9](09-comandos-do-dia-a-dia.md)
- **`compose.yaml`:** arquivo YAML que descreve os serviços, as redes, os volumes e os secrets de um projeto. [Capítulo 3](03-primeiro-compose-yaml.md)
- **Configuração declarativa** (*declarative configuration*): descrever num arquivo o estado desejado e deixar a ferramenta chegar nele. [Capítulo 1](01-por-que-um-arquivo-para-o-projeto.md)
- **Contexto de build** (*build context*): a pasta enviada para o build, indicada por `context`, relativa ao `compose.yaml`. [Capítulo 4](04-build-pelo-compose.md)
- **`depends_on`:** chave que define a ordem de início entre serviços; com `condition: service_healthy`, espera o outro ficar saudável. [Capítulo 8](08-ordem-de-inicio-e-saude.md)
- **`docker compose config`:** mostra o arquivo final, já com variáveis interpoladas e arquivos juntados, sem subir nada. [Capítulo 5](05-variaveis-env-e-configuracao.md)
- **`docker compose cp`:** copia arquivos entre o contêiner de um serviço e o host, com a origem primeiro. [Capítulo 9](09-comandos-do-dia-a-dia.md)
- **`down`:** remove os contêineres e a rede do projeto; com `-v`, também os volumes. [Capítulo 3](03-primeiro-compose-yaml.md)
- **`entrypoint`:** chave que troca o `ENTRYPOINT` da imagem e faz o `CMD` dela ser ignorado. [Capítulo 9](09-comandos-do-dia-a-dia.md)
- **`environment`:** lista de variáveis entregues ao contêiner; vence o `env_file`. [Capítulo 5](05-variaveis-env-e-configuracao.md)
- **`env_file`:** arquivo de variáveis entregue inteiro ao contêiner. [Capítulo 5](05-variaveis-env-e-configuracao.md)
- **`exec`:** roda um comando num contêiner do serviço que já está rodando. [Capítulo 9](09-comandos-do-dia-a-dia.md)
- **Healthcheck:** teste periódico que marca o contêiner como `healthy` ou `unhealthy`. [Capítulo 8](08-ordem-de-inicio-e-saude.md)
- **Interpolação de variáveis** (*variable interpolation*): troca de `${VAR}` no `compose.yaml` pelo valor da variável, com padrões como `${VAR:-padrão}`. [Capítulo 5](05-variaveis-env-e-configuracao.md)
- **Limite de recursos** (*resource limits*): teto de CPU e memória em `deploy.resources.limits`; memória acima do teto mata o processo. [Capítulo 13](13-recursos-e-escala.md)
- **Merge:** a junção de arquivos do Compose: valores únicos trocados, mapas juntados por chave, listas somadas. [Capítulo 11](11-perfis-e-arquivos-sobrepostos.md)
- **Nome do serviço como endereço** (*service discovery*): na rede do projeto, cada serviço é encontrado pelo seu nome. [Capítulo 6](06-varios-servicos-e-a-rede-do-projeto.md)
- **Perfil** (*profile*): rótulo em `profiles` que faz o serviço subir só quando o perfil é ativado. [Capítulo 11](11-perfis-e-arquivos-sobrepostos.md)
- **Plugin do Compose** (*Compose plugin*): o programa `docker-compose` que o `docker` acha em `cli-plugins` e que atende o `docker compose`. [Capítulo 2](02-instalar-e-conferir-o-compose.md)
- **Política de reinício** (*restart policy*): a chave `restart`, que diz quando o Docker reinicia o contêiner que parou. [Capítulo 9](09-comandos-do-dia-a-dia.md)
- **Projeto do Compose** (*Compose project*): o conjunto de serviços, redes e volumes de um `compose.yaml`; o nome padrão é o da pasta. [Capítulo 1](01-por-que-um-arquivo-para-o-projeto.md)
- **Proxy reverso** (*reverse proxy*): servidor que recebe os pedidos numa porta e os repassa aos serviços da rede interna. [Capítulo 14](14-projeto-final-stack-completa.md)
- **Push:** envio da imagem de um serviço com `image` a um registro, com `docker compose push`. [Capítulo 14](14-projeto-final-stack-completa.md)
- **Rede do projeto** (*default network*): rede `<projeto>_default` criada pelo Compose e compartilhada pelos serviços. [Capítulo 6](06-varios-servicos-e-a-rede-do-projeto.md)
- **Registro** (*registry*): servidor que guarda imagens, como o `registry:2` em `localhost:5000`. [Capítulo 14](14-projeto-final-stack-completa.md)
- **Réplica** (*replica*): cada contêiner de um serviço escalado com `--scale` ou `deploy.replicas`. [Capítulo 13](13-recursos-e-escala.md)
- **`run`:** cria um contêiner novo do serviço para um comando avulso; com `--rm`, ele é removido no fim. [Capítulo 9](09-comandos-do-dia-a-dia.md)
- **Secret:** dado sensível entregue ao contêiner como arquivo somente leitura em `/run/secrets/<nome>`. [Capítulo 12](12-segredos-e-dados-sensiveis.md)
- **Serviço** (*service*): a receita de um componente do projeto, da qual o Compose cria um ou mais contêineres. [Capítulo 1](01-por-que-um-arquivo-para-o-projeto.md)
- **`up`:** cria e inicia o que o `compose.yaml` descreve; com `-d`, em segundo plano, e com `--build`, reconstruindo as imagens. [Capítulo 3](03-primeiro-compose-yaml.md)
- **Volume nomeado** (*named volume*): volume declarado no topo do `compose.yaml` que guarda os dados entre um `down` e outro. [Capítulo 7](07-volumes-no-compose.md)
- **Watch:** recurso que copia mudanças do código para o contêiner ou reconstrói a imagem, com `up --watch` ou `docker compose watch`. [Capítulo 10](10-desenvolvimento-com-watch.md)

## Índice remissivo

<!-- index:start -->
## Índice remissivo

- arquivo .env: [5. Variáveis, .env e configuração](05-variaveis-env-e-configuracao.md)
- arquivos sobrepostos: [11. Perfis e arquivos sobrepostos](11-perfis-e-arquivos-sobrepostos.md)
- build multi-stage: [14. Projeto final: stack completa](14-projeto-final-stack-completa.md)
- build pelo Compose: [4. Build pelo Compose](04-build-pelo-compose.md)
- command e entrypoint: [9. Comandos do dia a dia](09-comandos-do-dia-a-dia.md)
- compose watch: [10. Desenvolvimento com watch](10-desenvolvimento-com-watch.md)
- compose.yaml: [3. Primeiro compose.yaml](03-primeiro-compose-yaml.md)
- configuração declarativa: [1. Por que um arquivo para o projeto](01-por-que-um-arquivo-para-o-projeto.md)
- depends_on: [8. Ordem de início e saúde](08-ordem-de-inicio-e-saude.md)
- docker compose cp: [9. Comandos do dia a dia](09-comandos-do-dia-a-dia.md)
- exec e run: [9. Comandos do dia a dia](09-comandos-do-dia-a-dia.md)
- healthcheck: [8. Ordem de início e saúde](08-ordem-de-inicio-e-saude.md)
- interpolação de variáveis: [5. Variáveis, .env e configuração](05-variaveis-env-e-configuracao.md)
- limites de CPU e memória: [13. Recursos e escala](13-recursos-e-escala.md)
- nome do serviço como endereço: [6. Vários serviços e a rede do projeto](06-varios-servicos-e-a-rede-do-projeto.md)
- perfis: [11. Perfis e arquivos sobrepostos](11-perfis-e-arquivos-sobrepostos.md)
- plugin do Compose: [2. Instalar e conferir o Compose](02-instalar-e-conferir-o-compose.md)
- política de reinício: [9. Comandos do dia a dia](09-comandos-do-dia-a-dia.md)
- projeto do Compose: [1. Por que um arquivo para o projeto](01-por-que-um-arquivo-para-o-projeto.md)
- proxy reverso: [14. Projeto final: stack completa](14-projeto-final-stack-completa.md)
- publicar a imagem com push: [14. Projeto final: stack completa](14-projeto-final-stack-completa.md)
- rede do projeto: [6. Vários serviços e a rede do projeto](06-varios-servicos-e-a-rede-do-projeto.md)
- réplicas e scale: [13. Recursos e escala](13-recursos-e-escala.md)
- secrets: [12. Segredos e dados sensíveis](12-segredos-e-dados-sensiveis.md)
- serviço: [1. Por que um arquivo para o projeto](01-por-que-um-arquivo-para-o-projeto.md)
- up, ps, logs e down: [3. Primeiro compose.yaml](03-primeiro-compose-yaml.md)
- volume nomeado: [7. Volumes no Compose](07-volumes-no-compose.md)
<!-- index:end -->

<!-- nav:start -->
---

[◀ Capítulo anterior](15-simulado-final.md) · [Mapa do livro](../README.md)
<!-- nav:end -->
