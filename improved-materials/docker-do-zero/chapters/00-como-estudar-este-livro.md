# 0. Como estudar este livro

> Escrito com IA (Claude) a partir das fontes citadas em cada capítulo. Conferido em 26/11/2026. Revisão humana: não. Edição 2.0.
>
> Este livro aprimora um material anterior do autor (notas em Markdown). Só a estrutura, os temas e os objetivos dele foram aproveitados: o texto, os exemplos e as saídas foram refeitos do zero.

Este livro leva você do primeiro contêiner a uma API com banco de dados, em dois contêineres numa rede própria, com os dados num volume e a imagem publicada num registro. A referência é o Docker Engine 29.9.3 com o Docker Desktop 4.99: os comandos e as saídas foram executados nessas versões, e o que não pôde ser executado está marcado no capítulo.

## 📇 O livro numa página

![O livro numa página: 1. Por que contêineres: contêiner = processo isolado, usa o kernel do host sem VM, imagem é a receita e contêiner a cozinha. 2. Desktop no Windows: ligar WSL 2 e a virtualização, instalar o Docker Desktop, hello-world confirma a instalação. 3. Linux e Mac: Engine pelo repositório oficial, grupo docker equivale a root, Docker Desktop no Mac. 4. Ciclo de vida: run -d -p 127.0.0.1:8080:8000, stop dá exit 143 e kill dá exit 137, logs, exec e inspect --format. 5. Desktop na prática: janela e CLI falam com o mesmo motor, docker context ls e use, o que se repete fica na CLI. 6. Imagens e Docker Hub: nome registro/ns/repo:tag, a tag muda e o digest não, pull, tag, rmi, save e load. 7. Primeiro Dockerfile: docker build -t dz-api:1.0 ., CMD na forma exec e USER app, .dockerignore deixa o .env de fora. 8. Builds enxutos: requirements antes do código, multi-stage de 511 MB para 197 MB, limpar no mesmo RUN. 9. Volumes: docker rm não apaga o volume, volume × bind mount × tmpfs, backup com tar e teste da restauração. 10. Redes: rede própria acha por nome, localhost é o próprio contêiner, só a API com -p 127.0.0.1. 11. Publicar a imagem: docker tag e docker push, versão 1.1.0 e 1.1 e não só latest, login com token e nunca a senha. 12. Projeto final: API e banco na rede dz-net, configuração por -e, dados no volume dz-dados.](../img/c00-o-livro-numa-pagina.svg)

## Como o livro está organizado

- **Capítulos 1 a 4:** o que é um contêiner, a instalação (Windows, Linux e Mac) e o ciclo de vida pela linha de comando.
- **Capítulos 5 a 8:** o Docker Desktop e os contextos, imagens e Docker Hub, o seu primeiro Dockerfile e como deixar o build rápido e a imagem enxuta.
- **Capítulos 9 a 12:** volumes, redes, publicação da imagem e o projeto final.

O fio condutor é uma **API de tarefas**. No capítulo 1 ela é só uma página servida por um contêiner; cada capítulo acrescenta uma peça, e no 12 ela grava num banco de dados.

A partir do capítulo 2, cada capítulo abre com um **Aquecimento** sobre o anterior. Todos têm um **🧪 Laboratório** e terminam com **Pratique**, **Revisão rápida**, **Estude com um tutor de IA**, **Resumo** e **Fontes**. As respostas ficam escondidas logo abaixo de cada pergunta, em **Ver resposta**; no EPUB, vão para um apêndice no fim do livro, com um link de volta ao exercício. Seções marcadas com 🔎 são opcionais. No começo de cada parte (capítulos 1, 5 e 9) há uma folha de revisão da parte, em uma imagem.

## Quatro hábitos que fazem diferença

1. **Responda antes de olhar.** Errar uma previsão e depois ver a resposta fixa mais do que ler a resposta direto.
2. **Volte nos dias sugeridos.** O fim de cada capítulo diz, em 🔁 **Revise hoje**, quais capítulos anteriores revisitar.
3. **Explique com suas palavras.** Se você não consegue dizer em voz alta o que um volume faz que a camada do contêiner não faz, ainda não aprendeu.
4. **Misture o velho e o novo.** Ao praticar, refaça um exercício de um capítulo antigo junto com os do capítulo atual.

## Em quanto tempo

O livro soma cerca de 8 h 30 min de leitura e prática (515 min, pelos tempos de cada capítulo). Estudando todos os dias:

| Ritmo | Por dia | Termina em |
| --- | --- | --- |
| Leve | ~20 min | ~4 semanas |
| Médio | ~40 min | ~2 semanas |
| Intenso | ~90 min | ~1 semana |

Os laboratórios costumam levar mais tempo na primeira vez (downloads de imagem, por exemplo); não se preocupe se passar do estimado.

## Antes de rodar os comandos

- **Terminal:** os exemplos usam Bash. No Windows, use o Git Bash ou o terminal de uma distro WSL (o capítulo 2 explica). No Git Bash, se um caminho que começa com `/` for "traduzido" para um caminho do Windows, rode antes `export MSYS_NO_PATHCONV=1`. Nos comandos com `\` no fim da linha, no PowerShell troque a `\` pela crase (`` ` ``).
- **Nomes `dz-`:** tudo o que o livro cria (contêineres, volumes, redes, imagens) começa com `dz-`. Assim você limpa o que é do livro sem tocar no que é seu, e os comandos de limpeza sempre citam o nome. Evite `docker system prune` e `docker volume prune` numa máquina com outros projetos: eles apagam também o que não é do livro.
- **Portas:** os exemplos publicam em `127.0.0.1:8080`, e só o seu computador acessa. Se a 8080 estiver ocupada, escolha outra (por exemplo, `127.0.0.1:8090:8000`) e use-a nos comandos seguintes.
- **Senhas:** o banco dos capítulos 9 a 12 usa uma senha de laboratório (`senha-de-teste`). Nunca use uma senha real num exemplo do livro, nem a cole num tutor de IA.
- **Versões:** a saída na sua máquina pode diferir em números e datas (IDs, tamanhos, tempos). O que importa é a forma da saída, e o livro diz o que observar.

## Revisões, tutor de IA e simulado

- Do capítulo 2 em diante, o **Aquecimento** e a **Revisão rápida** trazem perguntas de capítulos anteriores. Responda de cabeça antes de abrir a resposta.
- Os prompts de **Estude com um tutor de IA** são para colar num assistente de IA. Eles pedem que o assistente pergunte e espere você responder: use-os para treinar, não para receber a resposta pronta. Confira no próprio livro qualquer comando que o assistente sugerir.
- O [Simulado final](13-simulado-final.md) cobre todos os objetivos do livro. Faça-o depois do capítulo 12 e use a tabela de diagnóstico do fim para saber o que revisar. O [Glossário](glossario.md) reúne os termos.

## Teste de nivelamento

Se você nunca usou o Docker, pule o teste e comece pelo [capítulo 1](01-por-que-conteineres-existem.md). Se já usou, responda as dez perguntas sem consultar nada e confira no fim.

1. Você roda `uname -r` dentro de um contêiner de Alpine e de outro de Debian. As versões do kernel serão iguais ou diferentes? Por quê? *(capítulo 1)*
2. No Windows, qual é o backend padrão do Docker Desktop, e que comando liga o WSL? *(capítulo 2)*
3. Por que colocar uma pessoa no grupo `docker` de um Linux é uma decisão de segurança? *(capítulo 3)*
4. O `docker stop` demorou e o código de saída foi 137. O que aconteceu? *(capítulo 4)*
5. Qual a diferença entre a tag e o digest de uma imagem? *(capítulo 6)*
6. Num Dockerfile, qual a diferença entre `CMD python app.py` e `CMD ["python", "app.py"]`? *(capítulo 7)*
7. Por que o `COPY requirements.txt .` e o `pip install` vêm antes do `COPY` do código? *(capítulo 8)*
8. O `docker rm` do contêiner do banco apaga os dados que estavam num volume nomeado? *(capítulo 9)*
9. A API, em um contêiner, tenta falar com o banco em `localhost:5432` e falha. Por quê, e o que você usa no lugar? *(capítulo 10)*
10. Como fazer o `docker login` sem digitar a senha da conta no comando? *(capítulo 11)*

<details>
<summary>Ver resposta</summary>

1. Iguais. O contêiner não traz kernel: todos usam o do host. Só os arquivos (a distribuição) mudam.
2. O WSL 2. O comando é `wsl --install`, num terminal de administrador; depois, reinicie o computador e rode `wsl --update`.
3. Porque o grupo dá acesso ao socket do Docker, e quem controla o Docker consegue o mesmo poder de um administrador (root) da máquina.
4. O processo principal ignorou o SIGTERM, o prazo do `stop` acabou e o Docker enviou SIGKILL (128 + 9 = 137). Com `--init`, o `tini` repassa o sinal e o código seria 143.
5. A tag é um rótulo que pode passar a apontar para outra imagem; o digest (`sha256:...`) identifica o conteúdo exato e nunca muda.
6. Na forma exec (com colchetes e aspas duplas), o programa é o PID 1 e recebe o SIGTERM do `docker stop`. Na forma shell, o PID 1 é o `sh`, que não repassa o sinal.
7. Para aproveitar o cache de camadas: o `pip install` só é refeito quando o `requirements.txt` muda, e não a cada mudança no código.
8. Não. O `docker rm` apaga o contêiner; o volume e os dados continuam. Só o `docker volume rm` apaga o volume.
9. Dentro do contêiner, `localhost` é o próprio contêiner da API. Crie uma rede própria e use o nome do contêiner do banco (por exemplo, `dz-db`).
10. Com um token de acesso pessoal numa variável de ambiente e a opção `--password-stdin`; a senha da conta não entra no comando.

</details>

| Se você acertou... | Comece pelo |
| --- | --- |
| menos de 2 perguntas | [capítulo 1](01-por-que-conteineres-existem.md) |
| as perguntas 1 e 2 | [capítulo 3](03-instalar-no-linux-e-no-mac.md) |
| as perguntas 1 a 3 | [capítulo 4](04-ciclo-de-vida-do-conteiner-pela-linha-de-comando.md) |
| as perguntas 1 a 4 | [capítulo 5](05-docker-desktop-na-pratica-interface-linha-de.md) |
| as perguntas 1 a 5 | [capítulo 7](07-seu-primeiro-dockerfile.md) |
| as perguntas 1 a 6 | [capítulo 8](08-builds-rapidos-e-imagens-enxutas.md) |
| as perguntas 1 a 7 | [capítulo 9](09-volumes-dados-que-sobrevivem.md) |
| as perguntas 1 a 8 | [capítulo 10](10-redes-conteineres-que-conversam.md) |
| as perguntas 1 a 9 | [capítulo 11](11-publicar-a-imagem.md) |
| todas as 10 | [capítulo 12](12-projeto-final-api-com-banco-em-conteineres.md) |

O teste não cobre o capítulo 5 (Docker Desktop na prática) nem o 12 (projeto final), então passe os olhos neles mesmo assim. Mesmo começando adiante, leia o *Resumo* dos capítulos que pulou: os exemplos seguintes reaproveitam a API de tarefas e os nomes `dz-`.

> ➡️ **Próximo passo:** comece pelo capítulo que a tabela indicou.

<!-- nav:start -->
---

[Mapa do livro](../README.md) · [Próximo capítulo ▶](01-por-que-conteineres-existem.md)
<!-- nav:end -->
