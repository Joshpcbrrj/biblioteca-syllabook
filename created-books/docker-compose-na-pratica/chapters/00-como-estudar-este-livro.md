# 0. Como estudar este livro

> Escrito com IA (Claude) a partir das fontes citadas em cada capítulo. Conferido em 21/11/2026. Revisão humana: não. Edição 1.0.

Este livro leva você do primeiro `compose.yaml` a uma stack com proxy, API em réplicas e banco, subida com um comando. A referência é o Docker Compose v5.7.0 com o Docker Engine 29.9.3: todos os comandos e saídas foram executados nessas versões.

## 📇 O livro numa página

![O livro numa página, em sete cartões. 1-2, o arquivo e a instalação: serviço é a receita e contêiner a instância; docker compose version; plugin, não docker-compose. 3-4, subir e construir: up -d, ps, logs, down; build: . e image com build; up -d --build recria. 5-6, variáveis e rede: ${VAR:-padrão} e .env; o nome do serviço é o endereço; ports só para fora da rede. 7-8, volumes e saúde: volume nomeado guarda o banco; down -v apaga os dados; service_healthy com --wait. 9-10, dia a dia e watch: exec, run --rm, cp; restart não aplica mudança; develop.watch com sync e rebuild. 11-12, perfis e segredos: --profile e compose.override; -f soma listas e troca valores; secrets em /run/secrets. 13-14, escala e projeto final: limits de cpus e memory; --scale api=3 atrás do proxy; base, override e prod.](../img/c00-o-livro-numa-pagina.svg)

## Como o livro está organizado

- **Capítulos 1 a 3:** o que o Compose resolve, a instalação e o primeiro arquivo, com `up`, `ps`, `logs` e `down`.
- **Capítulos 4 a 8:** imagem própria com `build`, variáveis e `.env`, rede entre serviços, volumes e ordem de início com `healthcheck`.
- **Capítulos 9 a 13:** o dia a dia (`exec`, `run`, `cp`), desenvolvimento com `watch`, perfis e arquivos sobrepostos, segredos, limites e réplicas.
- **Capítulo 14:** o projeto final, que junta tudo.

A partir do capítulo 2, cada capítulo abre com um **Aquecimento** sobre o anterior. Todos terminam com **Pratique**, **Revisão rápida**, **Estude com um tutor de IA**, **Resumo** e **Fontes**. As respostas ficam escondidas logo abaixo de cada pergunta, em **Ver resposta**; no EPUB, elas vão para um apêndice no fim do livro, com um link de volta ao exercício. Seções marcadas com 🔎 são opcionais: pule na primeira leitura, se quiser.

## Quatro hábitos que fazem diferença

1. **Responda antes de olhar.** Errar uma previsão e depois ver a resposta fixa mais do que ler a resposta direto.
2. **Volte nos dias sugeridos.** O fim de cada capítulo diz, em 🔁 **Revise hoje**, quais capítulos anteriores revisitar.
3. **Explique com suas palavras.** Se você não consegue dizer em voz alta o que `depends_on` faz, ainda não aprendeu.
4. **Misture o velho e o novo.** Ao praticar, refaça um exercício de um capítulo antigo junto com os do capítulo atual.

## Em quanto tempo

O livro soma cerca de 10 h de leitura e prática (615 min, pelos tempos de cada capítulo). Estudando todos os dias:

| Ritmo | Por dia | Termina em |
| --- | --- | --- |
| Leve | ~20 min | ~5 semanas |
| Médio | ~40 min | ~2 a 3 semanas |
| Intenso | ~90 min | ~1 semana |

Os exercícios de terminal costumam levar mais tempo na primeira vez; não se preocupe se passar do estimado.

## Revisões, tutor de IA e simulado

- Do capítulo 2 em diante, a **Revisão rápida** traz uma pergunta de um capítulo anterior. Responda de cabeça antes de abrir a resposta.
- Os prompts de **Estude com um tutor de IA** são para colar num assistente de IA. Eles pedem que o assistente pergunte e espere você responder: use-os para treinar, não para receber a resposta pronta. Confira no próprio livro qualquer comando que o assistente sugerir.
- O **Simulado final** cobre todos os objetivos do livro. Faça-o depois do capítulo 14 e use a tabela de diagnóstico do fim para saber o que revisar.

Para os exemplos, você precisa do Docker funcionando e de um terminal. No Windows, os comandos com `\` no fim da linha são para Bash; no PowerShell, troque a `\` pela crase (`` ` ``).

## 🎯 Teste de nivelamento

Se você nunca usou o Compose, pule o teste e comece pelo [capítulo 1](01-por-que-um-arquivo-para-o-projeto.md). Se já usou, responda as oito perguntas sem consultar nada e confira no fim.

1. Num `compose.yaml`, qual chave de topo lista os contêineres do projeto, e que nome o Compose dá ao contêiner do serviço `web` num projeto da pasta `meu-site`? *(capítulo 1)*
2. Que comando mostra a versão do Compose instalada? *(capítulo 2)*
3. O que `docker compose down` remove, e o que fica? *(capítulo 3)*
4. Você mudou o `Dockerfile` da API e rodou `docker compose up -d`. A API continua com o código antigo. Por quê, e qual comando resolve? *(capítulo 4)*
5. O que acontece com `${PORTA:-8000}` quando a variável `PORTA` não existe? *(capítulo 5)*
6. Dentro do contêiner da API, que endereço ela usa para chegar ao banco do serviço `db`: `localhost`, o nome `db` ou a porta publicada no host? *(capítulo 6)*
7. Qual é a diferença entre `docker compose down` e `docker compose down -v` para os dados do banco num volume nomeado? *(capítulo 7)*
8. Com `depends_on: [db]` na forma curta, a API espera o banco estar pronto para aceitar conexões? *(capítulo 8)*

<details>
<summary>Ver resposta</summary>

1. A chave `services`. O contêiner se chama `meu-site-web-1`: projeto, serviço e número da instância.
2. `docker compose version` (com `--short`, só o número).
3. Remove os contêineres e a rede do projeto. O `compose.yaml`, as imagens e os volumes ficam.
4. Porque o `up -d` só constrói a imagem quando ela não existe; como ela já existia, foi reaproveitada. `docker compose up -d --build` reconstrói e recria o contêiner.
5. O Compose usa o padrão `8000`. O `:-` também usa o padrão quando a variável existe mas está vazia.
6. O nome `db`, com a porta do contêiner (5432 no PostgreSQL). `localhost` é o próprio contêiner da API, e a porta do host não vale entre serviços.
7. O `down` mantém o volume, e os dados voltam no próximo `up`. O `down -v` apaga o volume, e com ele os dados, sem como desfazer.
8. Não. A forma curta só espera o contêiner do banco ter **iniciado**. Para esperar o banco ficar pronto, é preciso um `healthcheck` no `db` e `condition: service_healthy` na API.

</details>

| Se você acertou... | Comece pelo |
| --- | --- |
| menos de 3 perguntas | [capítulo 1](01-por-que-um-arquivo-para-o-projeto.md) |
| as perguntas 1 a 3 | [capítulo 4](04-build-pelo-compose.md) |
| as perguntas 1 a 5 | [capítulo 6](06-varios-servicos-e-a-rede-do-projeto.md) |
| as perguntas 1 a 7 | [capítulo 8](08-ordem-de-inicio-e-saude.md) |
| todas as 8 | [capítulo 9](09-comandos-do-dia-a-dia.md) |

Mesmo começando adiante, passe os olhos no *Resumo* dos capítulos que pulou: os exemplos dos capítulos seguintes reaproveitam os projetos `meu-site`, `ola-api` e `contador`.

> ➡️ **Próximo passo:** comece pelo capítulo que a tabela indicou.

<!-- nav:start -->
---

[Mapa do livro](../README.md) · [Próximo capítulo ▶](01-por-que-um-arquivo-para-o-projeto.md)
<!-- nav:end -->
