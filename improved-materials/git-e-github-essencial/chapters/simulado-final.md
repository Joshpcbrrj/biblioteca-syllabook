# Simulado final

> 🗺️ **Como fazer:** 26 perguntas sobre o livro inteiro, misturadas. Responda todas no papel ou num arquivo, sem consultar nada, e só depois abra as respostas. Conte os acertos e use a tabela de diagnóstico no fim. · ⏱️ ~60 min

## Perguntas

**1.** Num sistema centralizado, como o SVN, e num distribuído, como o Git, onde fica o histórico completo do projeto?

**2.** Verdadeiro ou falso: “sem uma conta no GitHub não dá para usar o Git”. Explique.

**3.** No repositório `horta-comunitaria`, a Ana tem `user.email` configurado no nível global (`ana@exemplo.com`) e no nível local (`horta@exemplo.com`). Com que e-mail sai o próximo commit nesse repositório? Que comando mostra de que arquivo veio o valor?

**4.** O Diego roda `git push` para o GitHub, digita a senha da conta dele e o push é recusado. Por quê? Cite duas formas certas de se autenticar.

**5.** Preveja a saída. O `index.html` já está no repositório, sem modificação. Você roda:

```bash
# edita o index.html
git add index.html
# edita o index.html de novo
git status -s
```

O que aparece, e o que cada coluna quer dizer?

**6.** O `.gitignore` do projeto tem a linha `*.log`. Você quer ignorar todos os `.log`, menos o `importante.log`. Que linha você acrescenta? E que comando confirma qual regra está valendo para um arquivo?

**7.** Reescreva este commit para seguir as boas práticas do capítulo 4. Ele foi feito com `git commit -am "arrumei umas coisas, mudei o css e o bolo e o titulo"` e mexeu em três assuntos diferentes.

**8.** Que comando mostra quem mudou por último a linha 12 do `index.html`, e em que commit?

**9.** O histórico da `main` é `A ← B ← C ← D`, com o `HEAD` na `main` em `D`. Que commit é `HEAD~2`?

**10.** Ligue cada situação ao comando certo: `git restore <arquivo>`, `git restore --staged <arquivo>`, `git commit --amend`, `git revert <commit>`.

- a) Você deu `git add` num arquivo que não devia ir para este commit.
- b) Esqueceu um arquivo no último commit, que ainda não foi enviado.
- c) Um commit com erro já está no remoto e a equipe já baixou.
- d) Quer jogar fora uma edição ainda não commitada.

**11.** Você roda `git reset --soft HEAD~1`, `git reset --mixed HEAD~1` e `git reset --hard HEAD~1` (cada um a partir do mesmo estado). Para onde vão as mudanças do commit desfeito em cada caso?

**12.** Depois de `git switch --detach 9b3de16`, você faz um commit. Que nome tem o estado em que o repositório está, e o que você faz para não perder esse commit ao voltar para a `main`?

**13.** Você rodou `git reset --hard HEAD~3` por engano e sumiram três commits. Como recuperá-los?

**14.** Você está na `main` com edições não commitadas e um arquivo novo, e precisa trocar para a branch `corrige-link` agora, sem commitar. Que comando guarda tudo, inclusive o arquivo novo? Como você traz de volta depois?

**15.** A `main` está em `C`. A branch `sobremesas` saiu de `C` e tem `D` e `E`. Ninguém mexeu na `main` desde então. O `git merge sobremesas`, rodado na `main`, faz *fast-forward* ou merge de três vias? E se a `main` tivesse ganhado um commit `F` antes?

**16.** Ponha em ordem os passos para resolver um conflito de merge:

- a) `git commit`
- b) abrir o arquivo e escolher o texto final
- c) `git add <arquivo>`
- d) apagar os marcadores `<<<<<<<`, `=======` e `>>>>>>>`

**17.** No meio de um `git rebase`, aparece um conflito. Você resolve o arquivo e roda `git add`. Qual o próximo comando, e qual comando você **não** deve usar aqui?

**18.** No `git rebase -i HEAD~3`, qual a diferença entre `squash` e `fixup`?

**19.** Você fez rebase da branch `tortas`, que já estava no remoto, e quer enviá-la de novo. Por que o `git push` simples é recusado, e que opção é mais segura que `--force`?

**20.** O `git push` responde `! [rejected] main -> main (fetch first)`. O que aconteceu e o que fazer?

**21.** O `git status -sb` mostra `## main...origin/main [ahead 1, behind 2]`. O que isso quer dizer?

**22.** Crie uma tag anotada `v1.1` com a mensagem “Versão com sobremesas” e envie só ela ao remoto.

**23.** Ponha em ordem os passos para contribuir com um projeto em que você não é colaborador:

- a) `git push -u origin minha-correcao`
- b) **Fork** no GitHub
- c) abrir o pull request
- d) `git clone` do seu fork
- e) `git switch -c minha-correcao`, editar e commitar

**24.** A Ana publicou o currículo no repositório `ana-ribeiro.github.io`, ligou o Pages em **Settings → Pages → Deploy from a branch** com a `main` e, dois minutos depois do push, o site ainda mostra a versão antiga. Cite duas causas possíveis. E: ela pode guardar um token de acesso num gist secreto, já que “ninguém vê”?

**25.** Na descrição de um pull request para a `main`, você escreve `Closes #4`. Quando a issue #4 é fechada? E qual botão de merge transforma todos os commits do PR em um só commit na `main`?

**26.** Escreva em Markdown o começo de um README para o `receitas`: um título, uma frase dizendo o que o projeto é, uma lista com duas receitas e um link para `https://ana-ribeiro.github.io`.

## Respostas

<details>
<summary>Ver resposta</summary>

1. No centralizado, só no servidor; cada pessoa tem apenas a versão em que trabalha. No distribuído, cada cópia (cada clone) tem o histórico completo. [Capítulo 1](01-por-que-controlar-versoes.md)
2. Falso. O Git é um programa que roda no seu computador e funciona sem internet; o GitHub é um serviço que hospeda repositórios Git (como o GitLab e o Bitbucket). [Capítulo 1](01-por-que-controlar-versoes.md)
3. Com `horta@exemplo.com`: o nível mais próximo do repositório vence. `git config --show-origin user.email`. [Capítulo 2](02-instalacao-identidade-e-credenciais.md)
4. O GitHub não aceita a senha da conta no Git desde 13 de agosto de 2021. Formas certas: o Git Credential Manager (login pelo navegador; ou um token de acesso pessoal no lugar da senha) ou uma chave SSH. [Capítulo 2](02-instalacao-identidade-e-credenciais.md)
5. `MM index.html`. A coluna da esquerda é a staging area (a primeira edição, preparada); a da direita é a pasta (a segunda edição, ainda não preparada). Um `git commit` agora levaria só a primeira. [Capítulo 3](03-como-o-git-pensa.md)
6. `!importante.log`, numa linha abaixo de `*.log`. Para conferir: `git check-ignore -v <arquivo>`, que mostra o arquivo `.gitignore`, a linha e a regra. [Capítulo 3](03-como-o-git-pensa.md)
7. Três commits, um por assunto, com `git add` de cada arquivo e uma mensagem no presente, de até 50 caracteres no título. Por exemplo: “Corrige o título da página inicial”, “Ajusta as cores do estilo.css” e “Atualiza o tempo de forno do bolo”, cada um com um corpo dizendo o porquê, se não for óbvio. Cuidado também com o `-a`: ele não pega arquivos novos. [Capítulo 4](04-commits-e-historico.md)
8. `git blame -L 12,12 index.html`. [Capítulo 4](04-commits-e-historico.md)
9. `B`: dois commits antes do `HEAD`. [Capítulo 4](04-commits-e-historico.md)
10. a) `git restore --staged <arquivo>`; b) `git add <arquivo>` e `git commit --amend`; c) `git revert <commit>`; d) `git restore <arquivo>`. [Capítulo 5](05-desfazendo-erros-com-seguranca.md)
11. `--soft`: voltam para a staging area, prontas para um novo commit. `--mixed` (o padrão): voltam para a pasta, como modificações não preparadas. `--hard`: somem da pasta e da staging area (só o reflog ainda aponta o commit). [Capítulo 5](05-desfazendo-erros-com-seguranca.md)
12. *Detached HEAD*: o `HEAD` aponta para um commit, não para uma branch. Para guardar o commit, crie uma branch nele (`git switch -c <nome>` ainda ali, ou `git branch <nome> <hash>` depois). [Capítulos 5](05-desfazendo-erros-com-seguranca.md) e [6](06-branches-stash-e-merge.md)
13. `git reflog` para achar o hash de onde a `main` estava antes do reset, e então `git reset --hard <hash>` (ou criar uma branch nele). [Capítulo 5](05-desfazendo-erros-com-seguranca.md)
14. `git stash -u` (o `-u` inclui os arquivos não rastreados). Depois, de volta à `main`: `git stash pop`. [Capítulo 6](06-branches-stash-e-merge.md)
15. *Fast-forward*: a `main` só avança o ponteiro até `E`. Com o `F`, as duas andaram e o Git faz um merge de três vias, com um commit de dois pais. [Capítulo 6](06-branches-stash-e-merge.md)
16. b, d, c, a. [Capítulo 6](06-branches-stash-e-merge.md)
17. `git rebase --continue`. Não use `git commit`: o próprio rebase recria o commit. (Para desistir, `git rebase --abort`.) [Capítulo 7](07-rebase-e-historico-limpo.md)
18. Os dois juntam o commit ao de cima. O `squash` abre o editor para você combinar as mensagens; o `fixup` descarta a mensagem do commit que está sendo juntado. [Capítulo 7](07-rebase-e-historico-limpo.md)
19. O rebase criou commits novos, com outros hashes, e o remoto tem os antigos: o push não é um avanço simples. `git push --force-with-lease`, que só sobrescreve se o remoto ainda estiver onde você o viu pela última vez. Só faça isso numa branch em que só você trabalha. [Capítulos 7](07-rebase-e-historico-limpo.md) e [8](08-repositorios-remotos.md)
20. O remoto tem commits que você ainda não tem (alguém enviou antes). Integre primeiro com `git pull` (merge ou rebase), resolva se houver conflito e então rode `git push`. Nunca `git push --force` para “resolver”. [Capítulo 8](08-repositorios-remotos.md)
21. A sua `main` tem 1 commit que a `origin/main` não tem, e a `origin/main` tem 2 que a sua não tem: as duas andaram. `git pull` e depois `git push`. [Capítulo 8](08-repositorios-remotos.md)
22. `git tag -a v1.1 -m "Versão com sobremesas"` e `git push origin v1.1`. [Capítulo 8](08-repositorios-remotos.md)
23. b, d, e, a, c. [Capítulo 9](09-colaborando-no-github.md)
24. Causas: a publicação pode levar até 10 minutos depois do push; o repositório é privado numa conta GitHub Free (o Pages exige público); o nome do repositório não bate exatamente com o usuário, em minúsculas. Sobre o gist: não. Gist secreto não é privado; quem tiver o link vê. Token, senha e `.env` nunca vão para um gist. [Capítulo 10](10-projeto-curriculo-online.md)
25. Quando o PR for mesclado na branch principal; antes disso, nada fecha (e num PR para outra branch a palavra é ignorada). O botão é **Squash and merge**. [Capítulo 9](09-colaborando-no-github.md)
26. Uma resposta possível:

    ```markdown
    # Receitas da Ana

    Site com as receitas da família, feito para aprender Git.

    - Bolo de cenoura
    - Brigadeiro

    Veja também o [meu currículo](https://ana-ribeiro.github.io).
    ```

    Confira: `#` e um espaço no título, uma linha em branco antes da lista, `-` e um espaço em cada item, e o link no formato `[texto](endereço)`. [Capítulo 10](10-projeto-curriculo-online.md)

</details>

## Diagnóstico

| Se você errou… | Reveja |
| --- | --- |
| 1, 2 | capítulo 1 |
| 3, 4 | capítulo 2 |
| 5, 6 | capítulo 3 |
| 7, 8, 9 | capítulo 4 |
| 10, 11, 12, 13 | capítulo 5 |
| 14, 15, 16 | capítulo 6 |
| 17, 18, 19 | capítulo 7 |
| 19, 20, 21, 22 | capítulo 8 |
| 23, 25 | capítulo 9 |
| 24, 26 | capítulo 10 |

Acertou 22 ou mais? Você domina o essencial do Git e do GitHub. Menos que isso: reveja os capítulos da tabela, refaça o 🏋️ **Pratique** deles e repita só as perguntas que errou, daqui a uns dias.

<!-- nav:start -->
---

[◀ Capítulo anterior](10-projeto-curriculo-online.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](glossario.md)
<!-- nav:end -->
