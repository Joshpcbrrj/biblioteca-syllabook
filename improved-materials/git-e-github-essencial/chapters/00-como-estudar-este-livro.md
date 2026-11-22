# 0. Como estudar este livro

> Escrito com IA (Claude) a partir das fontes citadas em cada capítulo. Conferido em 22/11/2026. Revisão humana: não. Edição 1.0.
>
> Este livro aprimora as anotações do curso “Git e GitHub Essencial para o Desenvolvedor” (Geek University, Udemy). Do original vieram só a estrutura, os tópicos e os objetivos; o texto, os exemplos e os exercícios são novos.

## Como o livro está organizado

São 10 capítulos em três partes, cada uma aberta por uma cola de uma página (📇):

| Parte | Capítulos | O que você aprende |
| --- | --- | --- |
| 1. Primeiros passos | 1 a 3 | Por que controlar versões, instalar e configurar o Git, as três áreas e os estados dos arquivos |
| 2. O repositório no seu computador | 4 a 7 | Commits, histórico, desfazer erros, branches, stash, merge e rebase |
| 3. GitHub e trabalho em equipe | 8 a 10 | Remotos, tags, colaboração por issue, fork e pull request, e um currículo publicado com GitHub Pages |

Do capítulo 3 ao 9, um mesmo projeto cresce com você: o site `receitas` da Ana, que depois recebe ajuda do Bruno e da Carla. O capítulo 10 começa um projeto seu, o currículo online.

Cada capítulo segue o mesmo roteiro: 🔥 **Aquecimento** (uma pergunta sobre o que veio antes), explicação com comandos e saídas reais, 🧪 **Laboratório** (você repete no seu computador), 🏋️ **Pratique** (do exemplo resolvido ao desafio), 🧠 **Revisão rápida**, 🤖 **Estude com um tutor de IA** e 📌 **Resumo**. As seções 🔎 **Para ir além** são opcionais: pule na primeira leitura sem medo.

As respostas ficam escondidas logo abaixo de cada exercício, em **Ver resposta**. No EPUB, elas vão para um apêndice no fim do livro, com um link de volta para o exercício.

## Quatro técnicas que fazem diferença

1. **Responda antes de olhar.** Tentar lembrar, mesmo errando, fixa mais do que reler a resposta.
2. **Volte nos dias sugeridos.** O 🔁 **Revise hoje** no fim de cada capítulo diz o que rever; reveja também uma semana depois.
3. **Explique com as suas palavras.** Se você consegue contar para alguém o que um `reset --soft` faz, você entendeu.
4. **Misture o velho e o novo.** A revisão rápida de cada capítulo traz perguntas dos anteriores; faça todas.

## Em quanto tempo

O livro soma uns 515 min de estudo (cerca de 8 h 35 min), contando os laboratórios. Estudando todos os dias:

| Ritmo | Por dia | Termina em |
| --- | --- | --- |
| Leve | ~20 min | ~4 semanas |
| Médio | ~40 min | ~2 semanas |
| Intenso | ~90 min | ~1 semana |

Se um dia o tempo for curto, termine a seção em que está e pare num título: o capítulo seguinte sempre começa com **De onde paramos**.

## Como usar as revisões, o tutor de IA e o simulado

- **Revisão rápida:** responda de cabeça, depois confira. Errou duas ou mais? Releia o 📌 **Resumo** do capítulo e refaça o 🏋️ **Pratique**.
- **Tutor de IA:** os prompts de 🤖 transformam um chatbot (Claude, ChatGPT, Gemini…) num professor que pergunta, em vez de dar a resposta pronta. Cole o prompt, responda e peça correção. Desconfie se ele inventar uma opção de comando: confira na documentação ou no próprio terminal com `git <comando> -h`.
- **Simulado final:** faça no fim do livro, sem consultar nada. A tabela de diagnóstico no fim dele diz que capítulos rever.

> ⚠️ **Antes de começar:** os laboratórios rodam comandos que mudam arquivos. Crie as pastas do livro (`receitas`, `ana-ribeiro.github.io`) num lugar só para estudo, nunca dentro da pasta de um projeto de verdade.

## Teste de nivelamento

Nunca usou Git? Pule este teste e comece no capítulo 1. Já usa um pouco? Responda as 10 perguntas abaixo sem consultar nada e veja na tabela onde começar.

1. (Capítulo 3) Na saída do `git status -s`, o que quer dizer `?? notas.txt`?
2. (Capítulo 3) Você criou um arquivo `.env` com uma senha do banco de dados. Como impedir que ele entre num commit por engano?
3. (Capítulo 4) Qual a diferença entre `git diff` e `git diff --staged`?
4. (Capítulo 5) Um commit com erro já foi enviado ao GitHub e a equipe já baixou. Você usa `git reset` ou `git revert` para desfazê-lo? Por quê?
5. (Capítulo 5) Você rodou `git reset --hard HEAD~2` e perdeu dois commits que queria. Que comando mostra onde eles estavam?
6. (Capítulo 6) Quando um `git merge` faz *fast-forward* e quando ele cria um commit de merge?
7. (Capítulo 7) Qual é a regra de ouro do rebase?
8. (Capítulo 8) Qual a diferença entre `git fetch` e `git pull`?
9. (Capítulo 9) Você quer contribuir com um projeto open source em que não é colaborador. Qual o primeiro passo no GitHub, e para onde vai o seu `git push`?
10. (Capítulo 10) Qual deve ser o nome do repositório para publicar o seu site pessoal em `https://<seu-usuario>.github.io`?

<details>
<summary>Ver resposta</summary>

1. O arquivo é *untracked*: está na pasta, mas o Git ainda não acompanha.
2. Colocando `.env` no `.gitignore` antes do primeiro `git add`.
3. `git diff` mostra o que mudou na pasta e ainda não foi para a staging area; `git diff --staged` mostra o que está na staging area e vai entrar no próximo commit.
4. `git revert`: ele cria um commit novo que desfaz o anterior, sem reescrever o histórico que os outros já têm. O `reset` reescreve o histórico e só serve para commits que ainda estão só no seu computador.
5. `git reflog`.
6. *Fast-forward* quando a branch de destino não andou desde que a outra saiu dela: o ponteiro só avança. Commit de merge (de três vias) quando as duas branches têm commits novos.
7. Não faça rebase de commits que já estão num repositório compartilhado (que outras pessoas já baixaram).
8. `git fetch` só baixa os commits do remoto e atualiza `origin/main`; `git pull` baixa e também integra na sua branch (fetch + merge, ou + rebase).
9. Fazer um **fork**. O `git push` vai para o seu fork (`origin`), e de lá você abre um pull request para o original.
10. `<seu-usuario>.github.io`.

</details>

**Onde começar:**

| Acertou… | Comece no |
| --- | --- |
| Menos que as perguntas 1 e 2 | Capítulo 1 |
| 1 e 2 | Capítulo 4 |
| 1 a 5 | Capítulo 6 |
| 1 a 7 | Capítulo 8 |
| 1 a 9 | Capítulo 10 |
| Todas | Simulado final |

Conte só a sequência a partir da pergunta 1: se errou a 3, comece no capítulo 4, mesmo tendo acertado a 8.

> 💡 **Dica:** pulou capítulos? Faça mesmo assim o 🧪 **Laboratório** de cada um deles (sem ler o resto), para o seu projeto `receitas` chegar igual ao do livro. E se o Git ainda não estiver instalado, com nome, e-mail e acesso ao GitHub configurados, faça o capítulo 2 antes de qualquer outro.

> ➡️ **Próximo passo:** o capítulo 1 começa com um problema que você talvez já tenha vivido: a pasta cheia de cópias com nomes como `cardapio-final.txt` e `cardapio-final-2.txt`, sem saber qual é a certa.
