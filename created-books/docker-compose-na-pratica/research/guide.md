# Guia do tema · Docker Compose na prática

Adapta o perfil `stem` a um livro de ferramenta de linha de comando. Referência: Docker Compose v5.7.0 e Docker Engine 29.9.3 (Docker Desktop 4.99.0 no Windows, máquina do autor), conferidas em 2026-11-20.

## Como o livro ensina

- Cada capítulo parte de um problema que o leitor teria com `docker run` (pré-requisito: *Docker do zero*) e o resolve com uma chave do `compose.yaml` ou um subcomando.
- Ordem do tópico: por quê → definição em negrito → previsão → arquivo/comando → saída real → diagrama → erro comum.
- Um projeto que cresce: `meu-site` (c01–c05, nginx) e, a partir do c06, a aplicação com API, banco e proxy, que fecha no c14.

## Tipo de prática

- 🧪 Lab em todo capítulo: pastas e arquivos criados do zero, comandos na ordem, o que deve aparecer.
- Escada: converter `docker run` em `compose.yaml`, completar chaves, escrever um arquivo novo, desafio que mistura serviços.
- Exercícios de diagnóstico: ler uma mensagem de erro real e dizer a causa.

## Como o leitor confere sozinho

- `docker compose config`: mostra como o Compose leu o arquivo (erro de chave ou de indentação aparece aqui).
- `docker compose ps`, `curl -s localhost:<porta>`, `docker compose logs`.
- `docker compose version` e `docker version` para saber se as saídas do livro valem para a sua máquina.

## Saídas e versões

- Toda saída mostrada foi capturada com a versão de referência. Com Compose mais novo (no Linux, o repositório já oferece v5.8.0), pequenas diferenças de texto são esperadas.
- Sem terminal interativo, `up`/`down` imprimem pares de linhas (`Creating`/`Created`, `Starting`/`Started`); num terminal, a mesma informação aparece animada. O livro mostra a forma sem animação.
- Caminhos absolutos da máquina do autor nunca aparecem: cortar a saída ou usar `...`.
- Diferenças de sistema (Windows/PowerShell, macOS, Linux) são indicadas quando o comando muda.

## Diagramas

- `compare` para dois jeitos de fazer (run × compose, Desktop × Linux, dev × produção).
- Árvore/blocos para projeto → serviços → contêineres, redes e volumes.
- Sequência para ordem de início (c08) e watch (c10).

## Segurança

- Comandos com `sudo` só no Linux e só os da documentação oficial.
- Senhas nunca no `compose.yaml` versionado a partir do c12; antes disso, usar valores de exemplo e avisar.
- `down -v` apaga dados: aviso antes de usar (c07).

## Evitar

- `docker-compose` (com hífen, Compose v1) como comando principal: citar só como legado.
- Chave `version:` no topo do arquivo (obsoleta).
- Recursos fora da referência v5.7.0.
