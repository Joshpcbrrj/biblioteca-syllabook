# 9. Colaborando no GitHub

> 🗺️ **Neste capítulo:** como o GitHub organiza o trabalho de várias pessoas no mesmo projeto: colaboradores com acesso direto, issues para registrar o que precisa ser feito, fork e pull request para quem é de fora, a revisão antes do merge e os fluxos de trabalho que as equipes combinam. A Carla, que não faz parte da equipe, manda a primeira contribuição para o `receitas`. · ⏱️ ~60 min

> 🔥 **Aquecimento:**
>
> 1. (Capítulo 8) Qual a diferença entre `git fetch` e `git pull`?
> 2. (Capítulo 7) Um site oferece três botões para juntar uma branch: “merge commit”, “squash” e “rebase”. Pelo que você viu no rebase interativo, o que “squash” deve fazer com os commits da branch?
>
> <details>
> <summary>Ver resposta</summary>
>
> 1. O `fetch` só baixa e atualiza as branches `origin/...`; o `pull` baixa e integra na branch atual.
> 2. Juntar todos em um commit só.
>
> </details>

## De onde paramos

No capítulo 8 o `receitas` ganhou um remoto. A Ana e o Bruno passaram a trocar commits por ele, com `push`, `fetch` e `pull`, e a primeira versão foi marcada com a tag `v1.0` (último commit `1597a4d`). Para isso funcionar, os dois precisavam poder enviar commits para o mesmo remoto. E quando alguém de fora quer ajudar?

> ⚠️ **Não executado neste livro:** as telas do GitHub (convidar colaborador, abrir issue, fazer fork, abrir e revisar pull request, configurar o merge) exigem uma conta e não foram usadas aqui. Os passos seguem a documentação do GitHub, consultada em 21/11/2026. Todos os comandos `git` deste capítulo foram executados, com repositórios locais no lugar do GitHub, como no capítulo 8.

## Colaboradores

O Bruno envia commits para o remoto do `receitas` desde o capítulo 8. No remoto de treino, isso funcionou porque qualquer pessoa com acesso à pasta pode escrever nela. No GitHub, não: só o dono do repositório pode enviar commits, a não ser que ele dê permissão a outras pessoas.

**Um colaborador é uma pessoa que o dono do repositório convidou e que, depois de aceitar o convite, pode enviar commits (`push`) direto para ele.** Num repositório de conta pessoal, todos os colaboradores têm o mesmo acesso: ler, enviar commits, abrir e fechar issues, abrir e fazer merge de pull requests. Convidar outras pessoas, mudar a visibilidade e apagar o repositório continuam sendo só do dono.

Para convidar o Bruno, a Ana faz assim:

1. Na página do repositório, clique em **Settings**.
2. Na barra lateral, na seção **Access**, clique em **Collaborators**. O GitHub pode pedir a sua senha de novo.
3. Clique em **Add people**, digite o usuário do Bruno e clique no nome dele na lista.
4. Clique em **Add bruno-lima to receitas** (o texto traz o usuário e o repositório).
5. O Bruno recebe um e-mail com o convite. O acesso só começa quando ele aceita.

Depois disso, para o Bruno, nada muda em relação ao capítulo 8: `git clone`, `git pull`, `git push`.

> ⚠️ **Erro comum:** convidar como colaborador qualquer pessoa que queira contribuir. Um colaborador pode enviar commits direto para a `main`, sem ninguém revisar. Convide só quem é da equipe e de confiança. Para quem é de fora, o caminho é fork e pull request (adiante), em que o dono revisa tudo antes de aceitar.

## Issues

A Carla, uma leitora do site, fez o pão de queijo do Bruno e achou estranho: a receita não leva sal. Ela não tem acesso ao repositório, e mandar um e-mail para a Ana faz a informação se perder. O GitHub tem um lugar para isso.

**Uma issue é um registro de tarefa, erro, pedido ou discussão de um projeto no GitHub: tem número, título, descrição, comentários e fica aberta até ser resolvida.** Issues são do GitHub, não do Git: não existe `git issue`. Elas ficam na aba **Issues** do repositório.

A Carla abre a issue:

1. Na página do `receitas`, clique na aba **Issues**.
2. Clique em **New issue**. (Se o projeto tiver modelos de issue, escolha um ou clique em **Open a blank issue**.)
3. Em **Title**, escreva: `Pão de queijo sem sal`.
4. Na descrição, explique o problema, como reproduzir e o que esperava:

   ```text
   A receita de pão de queijo (receitas/pao-de-queijo.md) não lista sal.
   Fiz exatamente como está e ficou sem gosto. Esperava encontrar a
   quantidade de sal na lista de ingredientes.
   ```

5. Clique em **Submit new issue**.

Como é a primeira issue do repositório, ela recebe o número **#1**. Esse número é a forma de citá-la: em qualquer comentário, commit ou pull request, `#1` vira um link para a issue.

Algumas palavras antes do número fazem mais do que citar: **fecham a issue** quando a mudança chega à branch principal do repositório (a *default branch*, normalmente a `main`). São elas, em maiúsculas ou minúsculas:

| Palavras-chave |
| --- |
| `close`, `closes`, `closed` |
| `fix`, `fixes`, `fixed` |
| `resolve`, `resolves`, `resolved` |

`Closes #1` na descrição de um pull request fecha a issue #1 quando ele for mesclado na branch principal. Se o pull request for para outra branch, as palavras são ignoradas.

Para organizar muitas issues, o GitHub oferece **labels** (rótulos como `bug` ou `good first issue`, que marca tarefas boas para quem está chegando ao projeto), **assignees** (quem vai cuidar) e **milestones** (agrupamento por versão).

> ⚠️ **Erro comum:** abrir uma issue com título “Não funciona” e nenhum detalhe. Quem vai resolver precisa saber **o que** aconteceu, **onde**, **como reproduzir** e **o que era esperado**. Um bom relato economiza uma rodada de perguntas e respostas.

## Fork e upstream

### Fazer o fork

A Carla sabe resolver a #1: é uma linha no arquivo. Mas ela não é colaboradora e não pode enviar commits para o `receitas`. Ela precisa de uma cópia em que possa escrever.

**Um fork é uma cópia de um repositório de outra pessoa, feita no próprio GitHub, que fica na sua conta e na qual você pode enviar commits à vontade.** O fork guarda a ligação com o original, o que permite propor de volta as suas mudanças.

No GitHub, a Carla:

1. Na página do `receitas` da Ana, clica em **Fork**, no canto superior direito.
2. Confere o dono (a conta dela) e o nome do repositório.
3. Clica em **Create fork**.

No laboratório deste livro, o GitHub é substituído por pastas, como no capítulo 8. Um fork é uma cópia do repositório **no servidor**, então o equivalente local é um novo bare repository clonado do original:

```bash
git clone --bare receitas.git carla-fork.git
```

```text
Cloning into bare repository 'carla-fork.git'...
done.
```

| | Fork | Clone |
| --- | --- | --- |
| Onde fica a cópia | no GitHub, na sua conta | no seu computador |
| Como se faz | botão **Fork** no site | `git clone` no terminal |
| Para quê | ter um remoto em que você pode fazer push | ter os arquivos para editar |

Para contribuir, você faz os dois: o fork primeiro, depois o clone **do seu fork**.

### Clonar o fork e cadastrar o upstream

A Carla clona o fork dela (no GitHub, o endereço que aparece no botão **Code** da página do fork). Como no capítulo 8, ela ajusta o endereço para um caminho relativo e se identifica só neste repositório:

```bash
# o fork é o origin; identidade só neste repositório
git clone ../carla-fork.git receitas
cd receitas
git remote set-url origin ../../carla-fork.git
git config user.name "Carla Souza"
git config user.email "carla.souza@example.com"
```

```text
Cloning into 'receitas'...
done.
```

O `origin` dela é o fork. Mas o projeto de verdade continua andando no `receitas` da Ana, e a Carla precisa receber essas novidades. Ela cadastra o original como um segundo remoto, chamado, por convenção, de **upstream**:

```bash
git remote add upstream ../../receitas.git
git remote -v
git fetch upstream
```

```text
origin	../../carla-fork.git (fetch)
origin	../../carla-fork.git (push)
upstream	../../receitas.git (fetch)
upstream	../../receitas.git (push)
From ../../receitas
 * [new branch]      main       -> upstream/main
 * [new branch]      tortas     -> upstream/tortas
```

No GitHub, o comando seria `git remote add upstream https://github.com/<dona-do-original>/receitas.git`.

| Remoto | O que é | A Carla pode fazer push? |
| --- | --- | --- |
| `upstream` | o repositório original, da Ana | não |
| `origin` | o fork da Carla | sim |

![Diagrama de sequência entre o receitas (upstream), o carla-fork (origin) e a Carla (local): 1, fork, cópia no servidor; 2, git clone do fork; 3, git push -u origin com a branch; 4, pull request do fork para o original; 5, git fetch upstream do original para a Carla. A Carla não tem permissão de push no receitas: tudo o que chega lá passa pelo pull request](../img/c09-fork.svg)

### Trabalhar numa branch

A Carla não mexe na `main` do fork: cada contribuição vai numa branch própria. Assim, a `main` do fork continua igual à do original, e o pull request contém só a mudança dela.

```bash
git switch -c sal-no-pao-de-queijo
```

Ela acrescenta `- 1 colher de chá de sal` depois do queijo e faz o commit citando a issue no corpo da mensagem (capítulo 4):

```bash
# o push vai para o fork (origin), onde a Carla tem permissão
git add .
git commit -m "Acrescenta sal ao pão de queijo" -m "Closes #1"
git push -u origin sal-no-pao-de-queijo
```

```text
To ../../carla-fork.git
 * [new branch]      sal-no-pao-de-queijo -> sal-no-pao-de-queijo
branch 'sal-no-pao-de-queijo' set up to track 'origin/sal-no-pao-de-queijo'.
```

O push foi para o **fork** (`origin`), onde ela tem permissão. A mudança ainda não está no `receitas` da Ana. Falta pedir.

> ⚠️ **Erro comum:** clonar o repositório original em vez do fork e só perceber no push, que é recusado por falta de permissão. Se isso acontecer, não precisa clonar de novo: renomeie o remoto (`git remote rename origin upstream`), cadastre o fork como `origin` (`git remote add origin <endereço do fork>`) e envie a branch com `git push -u origin <branch>`.

## Pull request e revisão

### Abrir o pull request

**Um pull request (PR) é um pedido, feito no GitHub, para que os commits de uma branch sejam integrados em outra; ele abre um espaço para ver as mudanças, comentar, pedir ajustes e, no fim, fazer o merge.** Como as issues, o pull request é do GitHub, não do Git. (No GitLab, o nome é *merge request*.)

Pull requests servem nos dois cenários deste capítulo: do fork para o original (a Carla) e de uma branch para a `main` no mesmo repositório (o Bruno, como colaborador, também pode trabalhar assim, em vez de enviar direto para a `main`).

A Carla abre o PR:

1. Na página do `receitas` da Ana (ou do fork), aparece uma faixa amarela avisando que a branch recebeu commits. Clique em **Compare & pull request**.
2. Confira as duas pontas: a **base** (para onde vai: o `receitas` da Ana, branch `main`) e a de origem (de onde vem: o fork da Carla, branch `sal-no-pao-de-queijo`). Se elas não aparecerem, clique em **compare across forks** e escolha nos menus.
3. Escreva um título claro e uma descrição com o que mudou, por quê e como conferir. Inclua `Closes #1`.
4. Deixe marcado **Allow edits from maintainers**, que permite à Ana fazer pequenos ajustes direto na branch da Carla.
5. Clique em **Create Pull Request**.

Uma descrição que ajuda quem vai revisar:

```text
Acrescenta sal à receita de pão de queijo.

A receita não tinha sal (ver issue). Coloquei 1 colher de chá, que é a
quantidade das receitas que conferi para 500 g de polvilho.

Como conferir: abra receitas/pao-de-queijo.md; o sal aparece logo
depois do queijo.

Closes #1
```

> 💡 **Analogia:** no álbum de fotos do projeto, o álbum da família fica na casa da avó (o remoto do capítulo 8), e só quem tem a chave cola fotos nele (os colaboradores). A Carla, uma prima que mora longe, tira uma **cópia do álbum** para ela (o fork), cola a foto nova na cópia (o push no fork) e manda um **bilhete para a avó**: “cole esta foto depois da página do pão de queijo, porque faltava o sal” (o pull request). A avó olha a foto, pode pedir outra com mais luz (a revisão) e, quando gostar, cola no álbum dela (o merge). A analogia quebra num ponto: no papel, a prima mandaria a foto pronta; no Git, o pull request aponta para a branch, e cada foto nova que a Carla colar nessa branch aparece sozinha no pedido.

### Revisar

Com o PR aberto, é a vez da Ana. No GitHub, ela:

1. Abre a aba **Files changed**, que mostra o diff do PR.
2. Para comentar uma linha, passa o mouse sobre ela e clica no **+** azul. Escreve o comentário e clica em **Start a review**.
3. Ao terminar, clica em **Review changes**, escreve um resumo e escolhe:
   - **Comment**: só comentários, sem decidir;
   - **Approve**: aprova o merge;
   - **Request changes**: pede ajustes antes do merge.
4. Clica em **Submit review**.

A Ana pede uma mudança: na casa dela, cada um põe o sal a gosto. Para atender, a Carla **não abre outro PR**: faz um commit novo na mesma branch e envia.

```bash
# mesma branch: o pull request recebe o commit novo sozinho
git add .
git commit -m "Deixa o sal a gosto, como pedido na revisão"
git push
git log --oneline -n 3
```

```text
To ../../carla-fork.git
   4c307ec..5fca973  sal-no-pao-de-queijo -> sal-no-pao-de-queijo
5fca973 Deixa o sal a gosto, como pedido na revisão
4c307ec Acrescenta sal ao pão de queijo
1597a4d Ensina a desenformar o quindim
```

O pull request acompanha a branch: o commit novo aparece nele sem nenhuma ação extra.

### Testar o PR no seu computador

Antes de aceitar, a Ana quer ver a mudança no próprio computador. No GitHub, cada pull request fica disponível no repositório original como `pull/<número>/head`, e um `fetch` o traz para uma branch local: para um PR de número 2, `git fetch origin pull/2/head:pr-2`. (Com o GitHub CLI instalado, `gh pr checkout 2` faz o mesmo.)

No laboratório, sem GitHub, a Ana busca a branch direto do fork da Carla, com a mesma forma `origem:destino`. Antes, ela atualiza a `main`, porque o Bruno enviou um commit enquanto isso:

```bash
# origem:destino traz a branch do fork como pr-1, sem mexer na main
git pull
git fetch ../carla-fork.git sal-no-pao-de-queijo:pr-1
git log --oneline main..pr-1
git diff main...pr-1
```

```text
From ../receitas
   1597a4d..bd53b05  main       -> origin/main
Updating 1597a4d..bd53b05
Fast-forward
 receitas/limonada-suica.md | 2 ++
 1 file changed, 2 insertions(+)
From ../carla-fork
 * [new branch]      sal-no-pao-de-queijo -> pr-1
5fca973 Deixa o sal a gosto, como pedido na revisão
4c307ec Acrescenta sal ao pão de queijo
diff --git a/receitas/pao-de-queijo.md b/receitas/pao-de-queijo.md
index bb3189a..5b0248a 100644
--- a/receitas/pao-de-queijo.md
+++ b/receitas/pao-de-queijo.md
@@ -4,5 +4,6 @@
 - 250 ml de leite
 - 2 ovos
 - 200 g de queijo meia cura ralado
+- sal a gosto (cerca de 1 colher de chá)
 
 Forno: 180 °C por 25 min.
```

O `main...pr-1`, com **três** pontos, mostra o que mudou na `pr-1` desde que ela saiu da `main`, ignorando o que a `main` ganhou depois (a limonada do Bruno). É essa a comparação que interessa numa revisão, e é a que a aba **Files changed** mostra. Com dois pontos (`main..pr-1`), o `diff` compararia as duas pontas e mostraria também a limonada, como se a Carla a tivesse apagado.

### Fazer o merge: três botões

Aprovado, o PR é integrado pelo botão de merge da página. O GitHub oferece três formas, e cada uma deixa um histórico diferente. Para ver a diferença, a Ana aplica o equivalente local de cada uma, em três cópias do repositório.

**Create a merge commit** (o padrão) faz um merge de três vias, mesmo que um fast-forward fosse possível (o equivalente a `git merge --no-ff`):

```text
*   bb2ae29 Merge da contribuição da Carla
|\  
| * 5fca973 Deixa o sal a gosto, como pedido na revisão
| * 4c307ec Acrescenta sal ao pão de queijo
* | bd53b05 Pede para servir a limonada na hora
|/  
* 1597a4d Ensina a desenformar o quindim
```

**Squash and merge** junta todos os commits do PR em um só, em cima da base (o equivalente a `git merge --squash` seguido de `git commit`):

```text
* 29e3a0a Acrescenta sal ao pão de queijo
* bd53b05 Pede para servir a limonada na hora
* 1597a4d Ensina a desenformar o quindim
```

**Rebase and merge** reaplica cada commit do PR em cima da base, sem commit de merge (o rebase do capítulo 7). Os commits ganham hashes novos (`4c307ec` virou `b72f5fa`):

```text
* c004c84 Deixa o sal a gosto, como pedido na revisão
* b72f5fa Acrescenta sal ao pão de queijo
* bd53b05 Pede para servir a limonada na hora
* 1597a4d Ensina a desenformar o quindim
```

| Botão | Histórico | Bom quando |
| --- | --- | --- |
| Create a merge commit | todos os commits, mais um commit de merge | você quer registrar que houve um PR e o que ele trazia |
| Squash and merge | um commit por PR | os commits do PR são passos intermediários (como “ajuste pedido na revisão”) |
| Rebase and merge | todos os commits, em linha reta | cada commit do PR faz sentido sozinho |

O dono do repositório escolhe quais botões ficam disponíveis, nas configurações do repositório.

A Ana fica com o squash: “Deixa o sal a gosto, como pedido na revisão” não interessa a quem ler o histórico depois. Ela registra a Carla como autora (`--author`, capítulo 4) e envia:

```bash
# a autoria fica com quem escreveu a mudança
git merge --squash pr-1
git commit --author="Carla Souza <carla.souza@example.com>" \
  -m "Acrescenta sal ao pão de queijo" -m "Closes #1"
git log -n 1
git push
```

```text
Automatic merge went well; stopped before committing as requested
Squash commit -- not updating HEAD
[main 29e3a0a] Acrescenta sal ao pão de queijo
 Author: Carla Souza <carla.souza@example.com>
 1 file changed, 1 insertion(+)
commit 29e3a0a38ab1feb19bde92e10e46c02df842cee9
Author: Carla Souza <carla.souza@example.com>
Date:   Fri Nov 27 11:00:00 2026 -0300

    Acrescenta sal ao pão de queijo
    
    Closes #1
To ../receitas.git
   bd53b05..29e3a0a  main -> main
```

`stopped before committing as requested`: o `--squash` prepara as mudanças na staging area e espera o `git commit`. No GitHub, o botão faz tudo de uma vez e, como o PR tinha `Closes #1` e foi para a `main`, a issue #1 é fechada. Depois do merge, a página do PR oferece um botão para apagar a branch.

> ⚠️ **Erro comum:** aceitar um PR só lendo o título. Abra a aba **Files changed** e leia o diff inteiro: um PR pode trazer, sem querer, um arquivo de configuração, um `.env` (capítulo 3) ou uma mudança fora do assunto. Na dúvida, peça mudanças.

### Manter o fork em dia

A `main` do fork da Carla parou no `1597a4d`. O original já tem a limonada do Bruno e o sal dela. Antes da próxima contribuição, ela sincroniza:

```bash
# recebe do original (upstream) e atualiza o fork (origin)
git switch main
git fetch upstream
git merge upstream/main
git push origin main
```

```text
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
From ../../receitas
   1597a4d..29e3a0a  main       -> upstream/main
Updating 1597a4d..29e3a0a
Fast-forward
 receitas/limonada-suica.md | 2 ++
 receitas/pao-de-queijo.md  | 1 +
 2 files changed, 3 insertions(+)
To ../../carla-fork.git
   1597a4d..29e3a0a  main -> main
```

Fast-forward, sem conflito, porque a Carla nunca fez commits na `main` do fork. O `git push origin main` leva a atualização para o fork no servidor. No GitHub, o botão **Sync fork** (seguido de **Update branch**), na página do fork, faz a mesma coisa no site; depois, um `git pull` atualiza o computador.

Por fim, ela apaga a branch da contribuição, primeiro no fork e depois no computador:

```bash
git push origin --delete sal-no-pao-de-queijo
git branch -d sal-no-pao-de-queijo
```

```text
To ../../carla-fork.git
 - [deleted]         sal-no-pao-de-queijo
error: the branch 'sal-no-pao-de-queijo' is not fully merged
hint: If you are sure you want to delete it, run 'git branch -D sal-no-pao-de-queijo'
hint: Disable this message with "git config set advice.forceDeleteBranch false"
```

O `-d` recusou, como no capítulo 6: os commits `4c307ec` e `5fca973` não estão em nenhuma branch, porque o squash criou um commit novo, com outro hash, para o mesmo conteúdo. Como a Carla já confirmou que a mudança chegou ao original (o `29e3a0a` está na `main`), ela apaga com `git branch -D sal-no-pao-de-queijo`.

![Comparação: o colaborador (Bruno) é convidado pelo dono, faz git push direto no receitas, tem um remoto (origin), é para gente de confiança e a revisão é opcional; no fork com pull request (Carla), não precisa de convite, o push vai para o próprio fork, há dois remotos (origin e upstream), serve para qualquer pessoa e o dono revisa tudo antes do merge](../img/c09-colaborador-x-fork.svg)

## GitHub Flow e Git Flow

### Por que combinar um fluxo

Com várias pessoas no mesmo projeto, cada uma pode trabalhar de um jeito: uma faz commit direto na `main`, outra deixa branches esquecidas, uma terceira faz merge sem revisão. **Um fluxo de trabalho (*workflow*) é o combinado da equipe sobre que branches existem, de onde elas saem, como o trabalho volta para a principal e quem revisa.** O Git não impõe nenhum; os dois mais conhecidos são o GitHub Flow e o Git Flow.

### GitHub Flow

O fluxo que a Carla seguiu sem perceber. A regra central: **a `main` está sempre pronta para ir ao ar, e todo trabalho chega a ela por uma branch curta e um pull request.**

![Fluxo do GitHub Flow em seis passos: crie uma branch (git switch -c sal-no-pao-de-queijo); faça commits e envie com git push -u origin; abra o pull request com Closes #1 na descrição; responda à revisão com commits novos na mesma branch; faça o merge (merge commit, squash ou rebase); apague a branch no GitHub e no seu computador](../img/c09-github-flow.svg)

Em comandos, para quem é colaborador (sem fork):

```bash
# 1. comece da main atualizada
git switch main
git pull
git switch -c bolo-sem-gluten
# 2. commits pequenos, enviados para o remoto
git add .
git commit -m "Adiciona a versão sem glúten do bolo de cenoura"
git push -u origin bolo-sem-gluten
# 3 a 5: pull request, revisão e merge, no GitHub
# 6. limpeza depois do merge
git switch main
git pull
git branch -d bolo-sem-gluten
```

Se o merge foi por squash ou rebase, o último comando pode recusar com `not fully merged`: os commits da branch não estão na `main` com os mesmos hashes. Confira no GitHub que o PR foi mesclado e use `-D`, como a Carla.

Para garantir a regra, o dono pode **proteger a `main`** nas configurações do repositório, exigindo pull request (e, se quiser, uma aprovação) antes de qualquer merge. Assim, nem os colaboradores conseguem enviar direto para ela.

### Git Flow

O Git Flow, proposto por Vincent Driessen em 5 de janeiro de 2010, foi pensado para programas com **versões numeradas e lançamentos planejados**. Ele usa duas branches permanentes e três tipos de branches temporárias:

| Branch | Vida | Papel |
| --- | --- | --- |
| `master` (hoje, muitas vezes `main`) | permanente | só versões lançadas, cada uma com uma tag |
| `develop` | permanente | o que vai entrar na próxima versão |
| *feature* | temporária | uma funcionalidade; sai da `develop` e volta para ela |
| `release-*` | temporária | prepara uma versão; vai para a `master` e para a `develop` |
| `hotfix-*` | temporária | correção urgente; sai da `master` e volta para as duas |

O próprio autor, numa nota de 5 de março de 2020 no início do texto original, recomenda que equipes que entregam software continuamente (como um site, que vai ao ar várias vezes por dia) adotem um fluxo mais simples, como o GitHub Flow, em vez de forçar o Git Flow.

![Comparação: o GitHub Flow tem uma branch fixa (main), uma branch curta para cada tarefa, tudo entra por pull request, serve para sites e sistemas no ar e é por onde começar; o Git Flow tem duas fixas (main e develop), branches feature, release e hotfix, cada tipo volta para um lugar, serve para programas com versões e calendário, e o próprio autor sugere o GitHub Flow para entrega contínua](../img/c09-github-flow-x-git-flow.svg)

> ⚠️ **Erro comum:** adotar o Git Flow num projeto pequeno “porque é o mais completo”. Para um site como o `receitas`, a `develop` só cria uma etapa a mais entre o trabalho pronto e o site no ar. Comece pelo GitHub Flow; ao entrar numa equipe, pergunte qual fluxo ela combinou e siga o padrão de nomes de branch.

## 🧪 Laboratório: a primeira contribuição de fora

Continue com as pastas do capítulo 8: o `receitas` da Ana, o `receitas.git` e o clone do Bruno em `bruno/receitas`. Confira cada passo com `git status -sb` e `git log --oneline --graph --all`.

1. Na pasta do `receitas.git`, crie o “fork” da Carla com `git clone --bare receitas.git carla-fork.git`.
2. Crie a pasta `carla` e, dentro dela, `git clone ../carla-fork.git receitas`. No clone, ajuste o `origin` para `../../carla-fork.git` e configure `user.name` e `user.email` da Carla sem `--global`.
3. Cadastre o original com `git remote add upstream ../../receitas.git` e rode `git fetch upstream`. Confira: `git remote -v` com quatro linhas e `git branch -a` com `remotes/upstream/main`.
4. Crie a branch `sal-no-pao-de-queijo`, acrescente `- 1 colher de chá de sal` depois do queijo, faça o commit com `-m "Acrescenta sal ao pão de queijo" -m "Closes #1"` e envie com `git push -u origin sal-no-pao-de-queijo`.
5. No clone do Bruno, acrescente uma linha em branco e `Sirva na hora, bem gelada.` no fim da limonada; commite e envie.
6. Na Carla, troque a linha do sal por `- sal a gosto (cerca de 1 colher de chá)`, commite (“Deixa o sal a gosto, como pedido na revisão”) e envie com `git push`.
7. Na Ana, rode `git pull` e traga a contribuição com `git fetch ../carla-fork.git sal-no-pao-de-queijo:pr-1`. Compare `git diff main..pr-1` com `git diff main...pr-1`: só o de dois pontos mostra a limonada sendo “apagada”.
8. Faça uma cópia da pasta `receitas` da Ana e, nela, teste `git merge --no-ff pr-1`. Confira no `--graph` o commit de merge, e apague a cópia.
9. No `receitas` da Ana, rode `git merge --squash pr-1` e o commit com `--author` da Carla. Envie com `git push` e apague a `pr-1` com `git branch -D pr-1`.
10. Na Carla, sincronize o fork (`git switch main`, `git fetch upstream`, `git merge upstream/main`, `git push origin main`) e apague a branch da contribuição, local e remota.
11. Se você tem conta no GitHub: abra uma issue no seu repositório `receitas`, crie uma branch, envie, abra um pull request com `Closes #<número>`, faça o merge e confira que a issue foi fechada.

Pronto quando: `git log --oneline -n 3` mostra o mesmo commit “Acrescenta sal ao pão de queijo” no topo, com autora Carla, nos três clones (Ana, Bruno depois de um `git pull`, Carla); e `git branch -a` da Carla não lista mais a `sal-no-pao-de-queijo`.

O pão de queijo e a limonada no fim do capítulo:

<!-- project: receitas -->

**receitas/pao-de-queijo.md**

```markdown
# Pão de queijo

- 500 g de polvilho azedo
- 250 ml de leite
- 2 ovos
- 200 g de queijo meia cura ralado
- sal a gosto (cerca de 1 colher de chá)

Forno: 180 °C por 25 min.
```

**receitas/limonada-suica.md**

```markdown
# Limonada suíça

- 2 limões com casca
- 1 litro de água gelada
- 4 colheres de sopa de leite condensado

Bata por 10 segundos, no máximo, e coe na hora.

Sirva na hora, bem gelada.
```

## 🏋️ Pratique

**1. Exemplo resolvido.** O Diego quer corrigir um erro de digitação no README de um projeto open source, `exemplo/agenda`, em que ele não é colaborador. Quais são os passos, do começo ao fim?

1. No GitHub, abre `exemplo/agenda` e clica em **Fork** → **Create fork**. Agora existe `diego/agenda`.
2. Clona **o fork**: `git clone https://github.com/diego/agenda.git` e entra na pasta.
3. Cadastra o original: `git remote add upstream https://github.com/exemplo/agenda.git`.
4. Cria a branch: `git switch -c corrige-readme`. Corrige, `git add`, `git commit -m "Corrige erro de digitação no README"`.
5. Envia para o fork: `git push -u origin corrige-readme`.
6. No GitHub, clica em **Compare & pull request**, confere base (`exemplo/agenda`, `main`) e origem (`diego/agenda`, `corrige-readme`), descreve e clica em **Create Pull Request**.
7. Se pedirem ajustes: novos commits na mesma branch e `git push`.
8. Depois do merge: sincroniza a `main` (`git fetch upstream`, `git merge upstream/main`, `git push origin main`) e apaga a branch.

**2. Complete.** A Carla vai fazer a segunda contribuição. A `main` do fork dela está atrás do original. Preencha:

```bash
git switch main
git fetch ________
git merge __________
git push ______ main
git switch __ melhora-brigadeiro
# edita, git add, git commit
git push __ origin melhora-brigadeiro
```

<details>
<summary>Ver resposta</summary>

```bash
git switch main
git fetch upstream
git merge upstream/main
git push origin main
git switch -c melhora-brigadeiro
# edita, git add, git commit
git push -u origin melhora-brigadeiro
```

A sincronização vem antes da branch nova, para que ela saia da versão mais recente do original e o PR não traga conflitos à toa. Erros comuns: `git merge origin/main` (o `origin` é o fork, que está atrasado) e `git push upstream ...` (a Carla não tem permissão no original).

</details>

**3. Sozinho.** Escreva o título e a descrição de uma issue e do pull request que a resolve, para este problema: no `index.html` do `receitas`, o link da torta de limão aponta para `receitas/torta-de-limao.md`, mas alguém renomeou o arquivo para `torta-limao.md`, e o link quebrou. Considere que a issue recebeu o número #7.

<details>
<summary>Ver resposta</summary>

Uma resposta possível:

```text
Issue — Título: Link da torta de limão quebrado na página inicial
O link "Torta de limão" do index.html leva a uma página de erro.
Como reproduzir: abra o index.html e clique em "Torta de limão".
Esperado: abrir a receita. O arquivo hoje se chama
receitas/torta-limao.md, e o link aponta para receitas/torta-de-limao.md.

PR — Título: Corrige o link da torta de limão
Atualiza o link do index.html para receitas/torta-limao.md, o nome atual
do arquivo. Como conferir: abra o index.html e clique em "Torta de limão".

Closes #7
```

Confira a sua com estes critérios:

- A issue diz o que acontece, como reproduzir e o que era esperado.
- O título do PR diz o que a mudança faz, no presente (capítulo 4).
- A descrição do PR diz como conferir.
- O PR tem uma palavra-chave seguida de `#7` (`Closes`, `Fixes` ou `Resolves`).

</details>

**4. Desafio.** Uma equipe de três pessoas mantém o site de uma padaria, que vai ao ar várias vezes por semana. Hoje todo mundo faz push direto na `main`, e na semana passada um commit pela metade derrubou o site. Proponha um fluxo de trabalho e diga o que configurar no GitHub. Depois responda: o PR de cada pessoa tem, em média, uns cinco commits do tipo “ajuste”, “agora vai”. Que botão de merge você recomendaria?

<details>
<summary>Ver resposta</summary>

GitHub Flow: cada tarefa numa branch curta, saída da `main` atualizada; pull request com descrição; pelo menos uma revisão de outra pessoa; merge; branch apagada. A `main` está sempre pronta para ir ao ar.

No GitHub: proteger a `main`, exigindo pull request (e uma aprovação) antes do merge, para que nem os colaboradores consigam enviar direto.

Botão: **Squash and merge**. Commits como “agora vai” são passos intermediários; com o squash, cada PR vira um commit com uma mensagem boa na `main`. (Outra saída certa: a pessoa arrumar os commits com rebase interativo, capítulo 7, antes do merge, e usar **Rebase and merge**.)

Confira sua resposta: ela usa um fluxo com pull request obrigatório, cita a proteção da `main` e justifica o botão pelo tipo de commit que os PRs têm. Git Flow seria uma resposta fraca aqui: o site vai ao ar várias vezes por semana, sem versões planejadas.

</details>

## 🧠 Revisão rápida

1. O que um colaborador pode fazer que uma pessoa sem convite não pode?
2. Escrever `#3` num comentário fecha a issue #3?
3. Qual a diferença entre fork e clone?
4. Na Carla, para que servem `origin` e `upstream`?
5. Como atender a um pedido de mudança num pull request já aberto?
6. O que o botão **Squash and merge** faz com os commits do PR?
7. Qual é a regra central do GitHub Flow?
8. (Capítulo 8) Por que a Carla roda `git push origin main` depois de `git merge upstream/main`?
9. (Capítulo 6) Por que o `git branch -d` recusa apagar a branch depois de um squash?

<details>
<summary>Ver resposta</summary>

1. Enviar commits (`push`) direto para o repositório.
2. Não; só cria um link. Fecha com uma palavra-chave (`Closes #3`) num PR mesclado (ou commit enviado) na branch principal.
3. O fork é uma cópia no GitHub, na sua conta; o clone é uma cópia no seu computador.
4. `origin` é o fork dela, para onde ela envia; `upstream` é o original, de onde ela recebe as novidades.
5. Com commits novos na mesma branch e `git push`; o PR se atualiza sozinho.
6. Junta todos em um só commit, em cima da base.
7. A `main` está sempre pronta para ir ao ar; todo trabalho chega a ela por branch e pull request.
8. Porque o `merge` só atualizou a `main` local; o fork, no servidor, continuaria atrasado.
9. Porque os commits da branch não estão em nenhuma outra branch: o squash criou um commit novo, com outro hash.

</details>

## 🤖 Estude com um tutor de IA

```text
Faça o papel de mantenedora de um projeto open source. Eu vou descrever,
em texto, um pull request (título, descrição e o diff). Revise como uma
mantenedora cuidadosa: aponte o que falta na descrição e no código, faça
perguntas e decida entre Comment, Approve e Request changes, explicando.
```

```text
Descreva 4 equipes diferentes (tamanho, tipo de produto, frequência de
entregas), uma de cada vez. Para cada uma, eu proponho um fluxo de trabalho
e um botão de merge. Só depois da minha resposta, diga o que eu deixei de
considerar, sem me dar a resposta pronta antes.
```

> ➡️ **Próximo passo:** você já sabe versionar, desfazer, ramificar, sincronizar e colaborar. O capítulo 10 junta tudo num projeto seu: um currículo online, escrito em Markdown, documentado com README, publicado com GitHub Pages e editado pelo VS Code.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| Colaborador | Pessoa convidada pelo dono que pode enviar commits direto para o repositório. |
| Issue | Registro numerado de tarefa, erro ou pedido no GitHub; `#n` cita, `Closes #n` fecha. |
| Fork | Cópia de um repositório alheio na sua conta do GitHub, onde você pode fazer push. |
| `upstream` | Apelido convencional do repositório original, cadastrado com `git remote add`. |
| Pull request | Pedido de integração de uma branch em outra, com espaço para revisão. |
| Revisão | Aba **Files changed**; **Comment**, **Approve** ou **Request changes**. |
| Formas de merge | Merge commit (tudo + merge), squash (um commit), rebase (linha reta, hashes novos). |
| Sincronizar o fork | `git fetch upstream`, `git merge upstream/main`, `git push origin main` (ou **Sync fork**). |
| GitHub Flow | `main` sempre pronta; branch curta e pull request para tudo. |
| Git Flow | `main` (ou `master`) e `develop` fixas, mais feature, release e hotfix. |

## 📚 Fontes

- GitHub Docs (consultados em 21/11/2026): [Inviting collaborators to a personal repository](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-access-to-your-personal-repositories/inviting-collaborators-to-a-personal-repository), [Permission levels for a personal account repository](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-user-account-settings/permission-levels-for-a-personal-account-repository), [Creating an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/creating-an-issue), [Linking a pull request to an issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue), [Fork a repository](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo), [Syncing a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork), [Creating a pull request from a fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork), [Reviewing proposed changes in a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/reviewing-proposed-changes-in-a-pull-request), [About pull request merges](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges) e [GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow)
- [Vincent Driessen, “A successful Git branching model”](https://nvie.com/posts/a-successful-git-branching-model/) (5/1/2010, nota de 5/3/2020; consultado em 21/11/2026)
- [Pro Git, 6.2 — Contributing to a Project](https://git-scm.com/book/en/v2/GitHub-Contributing-to-a-Project) (consultado em 21/11/2026)
- [git-merge](https://git-scm.com/docs/git-merge) (`--squash`, `--no-ff`), [git-diff](https://git-scm.com/docs/git-diff) (`A...B`) e [git-push](https://git-scm.com/docs/git-push) (`--delete`) — Git Reference Manual (Git 2.56, consultados em 21/11/2026)
- Anotações do curso “Git e GitHub Essencial para o Desenvolvedor” (Geek University, Udemy): “Adicionando colaboradores no meu projeto”, “O que são issues”, “Trabalhando com fork”, “Realizando e aceitando pull requests” e “Fluxos de trabalho em equipe: GitHub Flow e Git Flow”: estrutura e tópicos.

> 🔁 **Revise hoje:** capítulos 2 (credenciais), 6 (merge e `branch -d`) e 8 (remotos, `fetch` e `push`).
