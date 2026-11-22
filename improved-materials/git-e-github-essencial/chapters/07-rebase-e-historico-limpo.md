# 7. Rebase e histórico limpo

> 🗺️ **Neste capítulo:** integrar uma branch com `git rebase`, que reaplica os seus commits em cima da `main` e deixa o histórico em linha reta; entender quando isso é perigoso; resolver conflitos no meio de um rebase; e arrumar commits bagunçados com o rebase interativo antes de mostrá-los a alguém. · ⏱️ ~45 min

> 🔥 **Aquecimento:**
>
> 1. (Capítulo 6) Por que o merge da `corrige-pudim` foi fast-forward e o da `sobremesas` não?
> 2. (Capítulo 5) Que comando mostra para onde o `HEAD` apontou nas últimas operações, inclusive em commits que não estão mais em nenhuma branch?
>
> <details>
> <summary>Ver resposta</summary>
>
> 1. Quando a `corrige-pudim` foi juntada, a `main` não tinha andado desde a criação dela: bastava avançar o ponteiro. Na `sobremesas`, as duas branches tinham commits novos, e o Git precisou criar um commit de merge com dois pais.
> 2. `git reflog`.
>
> </details>

## De onde paramos

No capítulo 6 o `receitas` ganhou a seção de sobremesas e passou pelo primeiro conflito. O histórico agora tem duas bifurcações e dois commits de merge (o último é `433506c`, “Merge branch 'forno-eletrico'”). Está correto, mas cada pequena branch deixa uma “alça” no `git log --graph`. Este capítulo mostra outra forma de integrar trabalho, que deixa a história em linha reta.

## Rebase × merge

A Ana cria a branch `bebidas` e faz dois commits: o suco de laranja com cenoura e a limonada suíça. Enquanto isso, o Bruno faz um commit na `main` sugerindo chocolate 50% no brigadeiro:

```bash
git log --oneline --graph --all -n 4
```

```text
* 4983f3f Sugere chocolate 50% no brigadeiro
| * 172b51d Adiciona a receita de limonada suíça
| * 4f9e111 Adiciona a receita de suco de laranja com cenoura
|/  
*   433506c Merge branch 'forno-eletrico'
```

É a mesma situação da `sobremesas` no capítulo 6: as duas branches andaram. Um `git merge bebidas` na `main` criaria um terceiro commit de merge. A Ana prefere outra coisa: fazer como se tivesse começado as bebidas **depois** da sugestão do Bruno.

**O `git rebase <base>` pega os commits que só existem na branch atual e os reaplica, um por um, em cima da ponta de `<base>`.** “Rebase” quer dizer “trocar a base”: a `bebidas` saiu do `433506c` e passa a sair do `4983f3f`.

Você roda o rebase na branch que vai **mudar de lugar**, e indica a nova base:

```bash
git switch bebidas
git rebase main
```

```text
Switched to branch 'bebidas'
Successfully rebased and updated refs/heads/bebidas.
```

Preveja: os dois commits das bebidas continuam com os hashes `4f9e111` e `172b51d`?

```bash
git log --oneline --graph --all -n 4
```

```text
* 036c36f Adiciona a receita de limonada suíça
* 748e984 Adiciona a receita de suco de laranja com cenoura
* 4983f3f Sugere chocolate 50% no brigadeiro
*   433506c Merge branch 'forno-eletrico'
```

Uma linha só, e **hashes novos**. O conteúdo e as mensagens são os mesmos, mas o pai mudou. Como o hash de um commit é calculado sobre tudo o que está dentro dele, inclusive a linha `parent` (capítulo 3), outro pai dá outro hash. O rebase não move commits: ele **cria commits novos** e muda a branch para eles.

```bash
git cat-file -p HEAD
```

```text
tree 23971193f12974e621858100b167fc69ed03025e
parent 748e9847957a0f37b64025f168bac67cd7a3f5dd
author Ana Ribeiro <ana.ribeiro@example.com> 1795609800 -0300
committer Ana Ribeiro <ana.ribeiro@example.com> 1795613400 -0300

Adiciona a receita de limonada suíça
```

Repare nas duas datas: o `author` guarda quando a Ana escreveu a limonada (9h30); o `committer`, quando o commit foi recriado (10h30). É a diferença entre autor e committer do capítulo 4.

Os commits antigos não sumiram na hora. O Git guarda em `ORIG_HEAD` para onde a branch apontava antes do rebase:

```bash
git log --oneline -n 2 ORIG_HEAD
```

```text
172b51d Adiciona a receita de limonada suíça
4f9e111 Adiciona a receita de suco de laranja com cenoura
```

Agora a `bebidas` sai da ponta da `main`. Preveja: que tipo de merge acontece?

```bash
git switch main
git merge bebidas
```

```text
Switched to branch 'main'
Updating 4983f3f..036c36f
Fast-forward
 index.html                  | 2 ++
 receitas/limonada-suica.md  | 7 +++++++
 receitas/suco-de-laranja.md | 7 +++++++
 3 files changed, 16 insertions(+)
 create mode 100644 receitas/limonada-suica.md
 create mode 100644 receitas/suco-de-laranja.md
```

Fast-forward. A sequência “rebase na branch, depois merge na `main`” é a forma comum de integrar com histórico linear. A Ana apaga a branch com `git branch -d bebidas`.

![Comparação: com git merge bebidas na main, os commits 4f9e111 e 172b51d ficam, nasce um commit de merge, o graph mostra duas linhas, o conflito é resolvido uma vez e é seguro em commits já compartilhados; com git rebase main na bebidas, os commits viram 748e984 e 036c36f, não há commit de merge, o graph mostra uma linha, o conflito é resolvido commit a commit e só serve para commits que só você tem](../img/c07-merge-x-rebase.svg)

| | Merge | Rebase |
| --- | --- | --- |
| O que conta | a história como aconteceu, com as bifurcações | uma história reorganizada, em linha reta |
| Commits da branch | ficam como estão | são recriados, com hashes novos |
| Commit de merge | sim (exceto no fast-forward) | não |

Nenhum dos dois é “o certo”. Muitas equipes usam os dois: rebase para atualizar a própria branch, merge para juntá-la na `main`.

> 💡 **Analogia:** no álbum de fotos do projeto, as bebidas eram duas fotos coladas depois de uma página antiga, numa continuação paralela. O rebase **tira as duas fotos de novo**, com a mesma cena e a mesma legenda, e cola as cópias depois da última foto da `main`. Cena e legenda são o conteúdo e a mensagem; a data de revelação nova é a data do committer; o número novo de cada foto é o hash. As fotos antigas vão para a gaveta (o `ORIG_HEAD` e o reflog), de onde ainda dá para resgatá-las por um tempo. A analogia quebra num ponto: no papel, duas fotos da mesma cena seriam iguais; no Git, elas têm identidades diferentes, e isso faz toda a diferença na próxima seção.

> ⚠️ **Erro comum:** inverter os papéis e rodar `git rebase bebidas` estando na `main`. O rebase sempre move a branch **atual**. Na `main`, o comando tentaria reaplicar os commits da `main` em cima da `bebidas`, e quem mudaria de hash seriam os commits da `main`. Leia `git rebase main` como “mude a minha branch para cima da `main`”.

## A regra de ouro

Os hashes novos não fazem diferença enquanto os commits só existem no seu computador. O problema começa quando outra pessoa já tem uma cópia deles.

Imagine que a Ana tivesse enviado o `4f9e111` (o suco) para uma cópia do repositório que a equipe compartilha, e que o Bruno já tivesse copiado esse commit e trabalhado em cima dele. Se a Ana faz o rebase, o `4f9e111` é trocado pelo `748e984`. Para o Git do Bruno, são dois commits diferentes, e o suco passa a existir duas vezes na história dele.

![Diagrama de sequência entre Ana, a cópia compartilhada e Bruno: Ana envia 4f9e111; Bruno copia 4f9e111 e faz um commit em cima dele; Ana faz rebase e envia 748e984 no lugar; para o Bruno, o suco fica duplicado, com dois hashes. Abaixo: na sua branch local, ninguém mais tem os commits antigos, e ali o rebase é seguro](../img/c07-regra-de-ouro.svg)

**Regra de ouro do rebase: não faça rebase de commits que já existem fora do seu repositório e sobre os quais outras pessoas podem ter trabalhado.** Use o rebase para arrumar o **seu** trabalho local antes de compartilhar.

Na prática:

| Situação | Rebase? |
| --- | --- |
| Commits na sua branch, ainda não enviados para lugar nenhum | sim |
| A sua branch, que só você usa, para atualizá-la com a `main` | sim, se ninguém trabalha nela |
| A `main`, ou qualquer branch em que outras pessoas trabalham | não: use merge |

O capítulo 8 mostra como enviar commits para outra cópia do repositório (`git push`) e por que o Git recusa um envio depois de um rebase sem uma opção que força. Lá também aparece o `git pull --rebase`, que aplica esta mesma ideia aos commits que você ainda não enviou.

> ⚠️ **Erro comum:** achar que, como o conteúdo é o mesmo, o Git “percebe” que os commits recriados são os antigos. Ele compara hashes, não conteúdo. Para o Git, `4f9e111` e `748e984` são estranhos um para o outro.

## Conflitos no rebase

O rebase reaplica cada commit em cima da nova base. Se um desses commits mudou as mesmas linhas que a base mudou, acontece o mesmo conflito do capítulo 6, só que **no meio da lista de commits**.

A Ana cria a branch `porcoes` com dois commits: troca “4 ovos” por “3 ovos grandes” no bolo e informa que o pudim rende 8 porções. Na `main`, o Bruno muda a mesma linha dos ovos para “4 ovos em temperatura ambiente”:

```bash
git log --oneline --graph --all -n 4
```

```text
* f8d9d28 Pede ovos em temperatura ambiente no bolo
| * e42d1d6 Informa o rendimento do pudim
| * 27b05fd Troca 4 ovos por 3 ovos grandes no bolo
|/  
* 036c36f Adiciona a receita de limonada suíça
```

Preveja: em qual dos dois commits da `porcoes` o rebase vai parar?

```bash
git switch porcoes
git rebase main
```

```text
Auto-merging receitas/bolo-de-cenoura.md
CONFLICT (content): Merge conflict in receitas/bolo-de-cenoura.md
error: could not apply 27b05fd... Troca 4 ovos por 3 ovos grandes no bolo
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
hint: Disable this message with "git config set advice.mergeConflict false"
Could not apply 27b05fd... # Troca 4 ovos por 3 ovos grandes no bolo
```

No primeiro, o dos ovos. O pudim ainda nem foi tentado. O `git status` mostra onde o rebase está:

```bash
git status
```

```text
interactive rebase in progress; onto f8d9d28
Last command done (1 command done):
   pick 27b05fd # Troca 4 ovos por 3 ovos grandes no bolo
Next command to do (1 remaining command):
   pick e42d1d6 # Informa o rendimento do pudim
  (use "git rebase --edit-todo" to view and edit)
You are currently rebasing branch 'porcoes' on 'f8d9d28'.
  (fix conflicts and then run "git rebase --continue")
  (use "git rebase --skip" to skip this patch)
  (use "git rebase --abort" to check out the original branch)

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
	both modified:   receitas/bolo-de-cenoura.md

no changes added to commit (use "git add" and/or "git commit -a")
```

O Git trata o rebase como uma lista de tarefas: um `pick` feito, um por fazer. (Ele diz *interactive* mesmo sem `-i`, porque o rebase usa por dentro o mesmo mecanismo do rebase interativo, que aparece na próxima seção.) O arquivo tem os marcadores de sempre:

```bash
cat receitas/bolo-de-cenoura.md
```

```text
# Bolo de cenoura

- 3 cenouras médias
<<<<<<< HEAD
- 4 ovos em temperatura ambiente
=======
- 3 ovos grandes
>>>>>>> 27b05fd (Troca 4 ovos por 3 ovos grandes no bolo)
- 1 e 1/2 xícara de açúcar

Forno a gás: 180 °C por 40 min, até o palito sair limpo.
Forno elétrico: 170 °C por 50 min.

Dica: unte a forma com manteiga e farinha.
```

Atenção ao que cada lado significa agora. No rebase, o `HEAD` é a **nova base** (a `main`, com a mudança do Bruno), e o lado de baixo é o **seu commit** sendo reaplicado. É o contrário da intuição de “eu estou na `porcoes`”: durante o rebase, o Git está em detached HEAD (capítulo 5), construindo a branch nova commit a commit em cima da `main`.

| Marcador | No merge (cap. 6) | No rebase |
| --- | --- | --- |
| `<<<<<<< HEAD` | a sua branch atual | a nova base (`main`) |
| `>>>>>>> ...` | a branch que está chegando | o seu commit sendo reaplicado |

A Ana junta as duas ideias: `- 3 ovos grandes em temperatura ambiente`. Antes de continuar, ela confere que não sobrou marcador. E se ela esquecer o `git add`?

```bash
git rebase --continue
```

```text
receitas/bolo-de-cenoura.md: needs merge
You must edit all merge conflicts and then
mark them as resolved using git add
```

O Git recusa: o arquivo ainda está marcado como em conflito. Com o `git add`, ele segue:

```bash
git diff --check
git add receitas/bolo-de-cenoura.md
git rebase --continue
```

```text
[detached HEAD d0d0f4f] Troca 4 ovos por 3 ovos grandes no bolo
 1 file changed, 1 insertion(+), 1 deletion(-)
Successfully rebased and updated refs/heads/porcoes.
```

O `git diff --check` não mostrou nada: nenhum marcador sobrando. O `--continue` abre o editor com a mensagem do commit (salve e feche para manter), grava o commit resolvido, reaplica o do pudim, que não conflita, e termina. A palavra `detached HEAD` na saída confirma o que a tabela disse.

```bash
git log --oneline --graph -n 4
```

```text
* 9c60b28 Informa o rendimento do pudim
* d0d0f4f Troca 4 ovos por 3 ovos grandes no bolo
* f8d9d28 Pede ovos em temperatura ambiente no bolo
* 036c36f Adiciona a receita de limonada suíça
```

De volta à `main`, `git merge porcoes` é fast-forward, e a branch é apagada.

![Fluxo: git rebase main reaplica 27b05fd e depois e42d1d6; para cada commit, se não há conflito, segue para o próximo ou termina; se há, edite o arquivo e apague os marcadores, rode git add no arquivo e git rebase --continue, que grava o commit e segue. Em qualquer parada, git rebase --skip pula o commit e git rebase --abort volta a branch ao estado de antes](../img/c07-conflito-rebase.svg)

Duas saídas de emergência:

- `git rebase --abort` desiste do rebase inteiro e devolve a branch ao estado anterior. Numa cópia do repositório, no mesmo ponto do conflito:

  ```bash
  git rebase --abort
  git status -s
  git log --oneline -n 1
  ```

  ```text
  e42d1d6 Informa o rendimento do pudim
  ```

  A `porcoes` voltou ao commit original do pudim, com o hash de antes.

- `git rebase --skip` descarta o commit que está sendo reaplicado e segue para o próximo. Use quando aquele commit não faz mais sentido em cima da nova base (por exemplo, a `main` já tem a mesma correção). O trabalho dele fica fora da branch.

> ⚠️ **Erro comum:** resolver o conflito e rodar `git commit` em vez de `git rebase --continue`. O commit é gravado, mas o rebase continua parado, com o próximo `pick` esperando. Se isso acontecer, rode `git rebase --continue` em seguida. A regra é: no merge, conclua com `git commit`; no rebase, com `git rebase --continue`.

## Rebase interativo: reword, squash, fixup, drop

A Ana começa o quindim numa branch `quindim`, com pressa, e o histórico sai assim:

```bash
git log --oneline -n 5
```

```text
9026020 teste forno 250
485386e corrige acento
37b4819 Adiciona o link do quindim
9a25659 quindim
9c60b28 Informa o rendimento do pudim
```

Quatro commits para uma receita: uma mensagem sem verbo (“quindim”), uma correção de acento que só existe porque o primeiro commit saiu com `acucar`, e um teste de forno a 250 °C que não deu certo. Para quem for ler esse histórico, o que interessa é “adiciona a receita de quindim”. Como os commits ainda não saíram do computador da Ana, ela pode reescrevê-los.

**O rebase interativo (`git rebase -i <base>`) abre a lista dos commits depois de `<base>` no editor e deixa você decidir o que fazer com cada um antes de reaplicá-los.** Aqui a base é `HEAD~4` (capítulo 4): os quatro últimos commits.

```bash
git rebase -i HEAD~4
```

O editor abre com a lista, do commit **mais antigo** para o mais novo (o contrário do `git log`), seguida de instruções comentadas (aqui, só o começo delas):

```text
pick 9a25659 # quindim
pick 37b4819 # Adiciona o link do quindim
pick 485386e # corrige acento
pick 9026020 # teste forno 250

# Rebase 9c60b28..9026020 onto 9c60b28 (4 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup [-C | -c] <commit> = like "squash" but keep only the previous
#                    commit's log message, unless -C is used, in which case
#                    keep only this commit's message; -c is same as -C but
#                    opens the editor
```

Cada linha é uma tarefa. Você troca a palavra do começo:

| Palavra | O que faz com o commit |
| --- | --- |
| `pick` | mantém como está |
| `reword` | mantém e abre o editor para trocar a mensagem |
| `edit` | para nesse commit para você mudá-lo (com `git commit --amend`, capítulo 5) |
| `squash` | junta ao commit de cima e abre o editor com as duas mensagens |
| `fixup` | junta ao commit de cima e descarta a mensagem deste |
| `drop` | remove o commit |

Você também pode **mudar a ordem das linhas** para reordenar os commits. Um `fixup` precisa ficar logo abaixo do commit que ele corrige.

Preveja antes de ler: que palavra cabe em cada um dos quatro commits da Ana?

A Ana edita a lista assim, salva e fecha:

```text
reword 9a25659 # quindim
squash 37b4819 # Adiciona o link do quindim
fixup 485386e # corrige acento
drop 9026020 # teste forno 250
```

1. `reword` no primeiro: o Git para e abre o editor com a mensagem `quindim`. Ela escreve `Adiciona a receita de quindim`.
2. `squash` no link: receita e link são uma mudança só, então vão juntos.
3. `fixup` no acento: a correção entra no commit da receita, e a mensagem “corrige acento” é descartada. Ninguém precisa saber que houve um `acucar`.
4. `drop` no teste de 250 °C: o commit some, e a linha de teste junto com ele.

Por causa do `squash`, o Git abre o editor uma segunda vez, com as mensagens do grupo:

```text
# This is a combination of 3 commits.
# This is the 1st commit message:

Adiciona a receita de quindim

# This is the commit message #2:

Adiciona o link do quindim

# The commit message #3 will be skipped:

# corrige acento
```

As linhas com `#` são ignoradas. A mensagem do `fixup` (#3) já vem comentada. A Ana apaga a linha do link e deixa só `Adiciona a receita de quindim`. Ao fechar o editor, a saída termina com:

```text
Successfully rebased and updated refs/heads/quindim.
```

Preveja: quantos commits a `quindim` tem agora, e o `acucar` ainda aparece?

```bash
git log --oneline -n 3
git show --stat HEAD
cat receitas/quindim.md
```

```text
254d2d2 Adiciona a receita de quindim
9c60b28 Informa o rendimento do pudim
d0d0f4f Troca 4 ovos por 3 ovos grandes no bolo
commit 254d2d24fb4a694fcfa3663cbd4ccce93eef5b60
Author: Ana Ribeiro <ana.ribeiro@example.com>
Date:   Wed Nov 25 14:00:00 2026 -0300

    Adiciona a receita de quindim

 index.html          | 1 +
 receitas/quindim.md | 7 +++++++
 2 files changed, 8 insertions(+)
# Quindim

- 1 xícara de açúcar
- 6 gemas
- 50 g de coco ralado

Forno: 180 °C em banho-maria por 40 min.
```

Um commit só, com a receita e o link, o acento certo e nenhum rastro do teste. A `Date` é a do primeiro commit (14h): o `git log` mostra a data do autor. A Ana leva o quindim para a `main` com `git merge quindim` (fast-forward) e apaga a branch.

| Comando | O que faz |
| --- | --- |
| `git rebase <base>` | reaplica os commits da branch atual em cima de `<base>` |
| `git rebase -i HEAD~n` | abre a lista dos últimos `n` commits para editar |
| `git rebase --continue` | depois de resolver e dar `git add`, segue o rebase |
| `git rebase --skip` | descarta o commit atual e segue |
| `git rebase --abort` | desiste e volta ao estado anterior |
| `git reset --hard ORIG_HEAD` | logo depois de um rebase concluído, volta a branch para onde estava antes |

> ⚠️ **Erro comum:** apagar uma linha da lista achando que isso “mantém o commit sem mexer”. Na lista do rebase interativo, **apagar a linha é o mesmo que `drop`**: o commit some. O próprio Git avisa nas instruções da lista: `If you remove a line here THAT COMMIT WILL BE LOST.` Para manter, deixe `pick`. Se perdeu algo, o reflog (capítulo 5) ainda tem o hash antigo.

### 🔎 Para ir além: `--fixup` e `--autosquash`

Se você já sabe, na hora do commit, que ele corrige um anterior, use `git commit --fixup <hash>`. O Git cria um commit com a mensagem `fixup! <mensagem do original>`. Depois, `git rebase -i --autosquash <base>` já abre a lista com esse commit posicionado logo abaixo do original e marcado como `fixup`. Veja `git-rebase` e `git-commit` no manual.

## 🧪 Laboratório: bebidas, porções e quindim

Continue no `receitas` do capítulo 6 (último commit “Merge branch 'forno-eletrico'”, só a `main`, `git status` limpo). Os seus hashes serão diferentes dos do livro, porque as datas e os autores dos seus commits são outros; o formato das saídas é o mesmo. Confira cada passo com `git log --oneline --graph --all`.

1. Crie a branch `bebidas` com `git switch -c`, adicione o suco de laranja com cenoura (arquivo e link) num commit e a limonada suíça noutro (receitas abaixo). Volte para a `main`, acrescente a dica do chocolate 50% no fim do `brigadeiro.md` e faça o commit.
2. Confira com `git log --oneline --graph --all -n 4`: a bifurcação. Anote os hashes dos dois commits das bebidas.
3. Na `bebidas`, rode `git rebase main`. Confira: uma linha só e hashes novos; `git log --oneline -n 2 ORIG_HEAD` mostra os que você anotou. Na `main`, faça o merge (confira `Fast-forward`) e apague a branch.
4. Crie a `porcoes`: um commit trocando `- 4 ovos` por `- 3 ovos grandes` no bolo e outro acrescentando `Rende 8 porções.` no fim do pudim. Na `main`, mude a mesma linha para `- 4 ovos em temperatura ambiente` e commite.
5. Na `porcoes`, rode `git rebase main`. Confira o `CONFLICT` no primeiro commit e o `git status` com `1 remaining command`. Tente `git rebase --continue` sem `git add` e confira a recusa `needs merge`.
6. Resolva com `- 3 ovos grandes em temperatura ambiente`, rode `git diff --check` (nada deve aparecer), `git add` e `git rebase --continue`. Leve a branch para a `main` e apague-a.
7. Crie a `quindim` com quatro commits: a receita com `acucar` (mensagem `quindim`), o link, a correção do acento e uma linha de teste `Teste: forno a 250 °C por 20 min.`.
8. Rode `git rebase -i HEAD~4` com `reword`, `squash`, `fixup` e `drop`, como neste capítulo. Confira: `git log --oneline -n 2` mostra um commit só para o quindim, e `cat receitas/quindim.md` não tem a linha de teste.
9. Leve o quindim para a `main` (fast-forward) e apague a branch.

Pronto quando: `git log --oneline --graph -n 8` mostra sete commits em linha reta acima do merge do forno elétrico, `git branch` mostra só `* main` e `git status` diz `working tree clean`.

As receitas novas e o `index.html` no fim do capítulo:

<!-- project: receitas -->

**receitas/suco-de-laranja.md**

```markdown
# Suco de laranja com cenoura

- 4 laranjas
- 1 cenoura pequena
- gelo a gosto

Bata a cenoura com o suco das laranjas e coe.
```

**receitas/limonada-suica.md**

```markdown
# Limonada suíça

- 2 limões com casca
- 1 litro de água gelada
- 4 colheres de sopa de leite condensado

Bata por 10 segundos, no máximo, e coe na hora.
```

**receitas/quindim.md**

```markdown
# Quindim

- 1 xícara de açúcar
- 6 gemas
- 50 g de coco ralado

Forno: 180 °C em banho-maria por 40 min.
```

**receitas/bolo-de-cenoura.md**

```markdown
# Bolo de cenoura

- 3 cenouras médias
- 3 ovos grandes em temperatura ambiente
- 1 e 1/2 xícara de açúcar

Forno a gás: 180 °C por 40 min, até o palito sair limpo.
Forno elétrico: 170 °C por 50 min.

Dica: unte a forma com manteiga e farinha.
```

**receitas/pudim.md**

```markdown
# Pudim de leite

- 1 lata de leite condensado
- 2 medidas (da lata) de leite
- 3 ovos

Calda: 1 xícara de açúcar derretido na forma.
Forno: 180 °C em banho-maria por 1 h.

Rende 8 porções.
```

**receitas/brigadeiro.md**

```markdown
# Brigadeiro

- 1 lata de leite condensado
- 1 colher de sopa de manteiga
- 3 colheres de sopa de chocolate em pó

Fogo baixo, mexendo sem parar, até soltar do fundo da panela.
Dica: use chocolate 50% cacau.
```

**index.html**

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head><meta charset="utf-8"><title>Receitas da Ana</title></head>
<body>
  <h1>Receitas da Ana</h1>
  <!-- cada receita nova ganha um item nesta lista -->
  <ul>
    <li><a href="receitas/bolo-de-cenoura.md">Bolo de cenoura</a></li>
    <li><a href="receitas/brigadeiro.md">Brigadeiro</a></li>
    <li><a href="receitas/pudim.md">Pudim</a></li>
    <li><a href="receitas/quindim.md">Quindim</a></li>
    <li><a href="receitas/limonada-suica.md">Limonada suíça</a></li>
    <li><a href="receitas/suco-de-laranja.md">Suco de laranja</a></li>
    <li><a href="receitas/torta-de-limao.md">Torta de limão</a></li>
    <li><a href="receitas/mousse-de-maracuja.md">Mousse de maracujá</a></li>
  </ul>
</body>
</html>
```

## 🏋️ Pratique

**1. Exemplo resolvido.** A branch `salgados` saiu do commit `A` da `main` e tem dois commits, `S1` e `S2`. Depois disso, a `main` ganhou o commit `M`. A Ana roda, na `salgados`, `git rebase main`. Como fica o histórico, e o que acontece com `S1` e `S2`?

1. Os commits que só existem na `salgados` são `S1` e `S2`; a nova base é a ponta da `main`, `M`.
2. O Git reaplica `S1` em cima de `M`, criando `S1'` (mesmo conteúdo e mensagem, pai `M`, hash novo), e depois `S2` em cima de `S1'`, criando `S2'`.
3. A `salgados` passa a apontar para `S2'`. O histórico fica `A → M → S1' → S2'`, em linha reta.
4. `S1` e `S2` continuam no repositório por um tempo, sem branch (`ORIG_HEAD` aponta para `S2`), e somem na limpeza do reflog (capítulo 5).
5. Um `git merge salgados` na `main` agora é fast-forward.

**2. Complete.** O rebase parou num conflito em `receitas/pudim.md`. Preencha:

```bash
# 1. veja em que commit o rebase parou e o que falta
git ______
# 2. edite o arquivo, apague os marcadores e confira que não sobrou nenhum
git diff ______
# 3. marque como resolvido
git ___ receitas/pudim.md
# 4. siga para o próximo commit
git rebase ________
```

<details>
<summary>Ver resposta</summary>

```bash
# o add vem antes do --continue: sem ele, o Git responde "needs merge"
git status
git diff --check
git add receitas/pudim.md
git rebase --continue
```

O `git status` mostra o `Last command done` (o commit que parou) e quantos faltam. O `--check` aponta marcadores esquecidos. Erros comuns: `git commit` no passo 4 (grava o commit, mas o rebase continua parado) e pular o `git add` (o `--continue` responde `needs merge`).

</details>

**3. Sozinho.** No seu `receitas`, numa branch `cocada`, faça três commits: a receita de cocada com as mensagens `cocada`, depois `ajusta coco`, depois `link cocada` (o link no `index.html`). Com um rebase interativo, deixe um commit só, com a mensagem `Adiciona a receita de cocada`.

<details>
<summary>Ver resposta</summary>

Rode `git rebase -i HEAD~3`. Uma lista que resolve:

```text
reword <hash> # cocada
fixup <hash> # ajusta coco
fixup <hash> # link cocada
```

O `reword` abre o editor para a mensagem nova; os dois `fixup` entram no primeiro commit e têm as mensagens descartadas. Outra saída certa: `pick`, `squash`, `squash`, e reescrever a mensagem no editor que o `squash` abre.

Confira:

- `git log --oneline -n 2` mostra `Adiciona a receita de cocada` logo acima do commit anterior da branch.
- `git show --stat HEAD` lista o arquivo da cocada e o `index.html`.

Erro comum: pôr `squash` ou `fixup` na **primeira** linha. Não há commit acima dela para juntar: o Git para com `error: cannot 'squash' without a previous commit` e pede que você corrija a lista com `git rebase --edit-todo` (ou desista com `--abort`).

</details>

**4. Desafio.** Três situações. Para cada uma, diga se usaria rebase ou merge, e por quê. Depois, responda a quarta.

1. A sua branch `contato`, que só existe no seu computador, ficou para trás da `main`.
2. A `main` da equipe tem um commit de merge que você acha feio.
3. Você e uma colega trabalham na mesma branch `novo-layout`, que as duas copiam e atualizam.
4. Você acabou de terminar um rebase interativo e percebeu que apagou um commit que queria manter. Como voltar?

<details>
<summary>Ver resposta</summary>

1. Rebase (`git rebase main` na `contato`): os commits só existem com você, e o histórico fica linear.
2. Nada: a `main` é compartilhada. Reescrever o merge mudaria os hashes de todo mundo. Um histórico com merges é correto, só não é linear.
3. Merge: a colega já tem os seus commits. Um rebase criaria cópias com hashes novos, e o mesmo trabalho apareceria duas vezes para ela.
4. `git reset --hard ORIG_HEAD`, se nada mais foi feito depois do rebase. Se já houve outras operações, procure no `git reflog` a linha `rebase (start)`: o hash da linha **logo abaixo** dela é a ponta da branch antes do rebase. Use `git reset --hard <hash>` (cuidado: o `--hard` descarta mudanças não commitadas; confira o `git status` antes).

Confira sua resposta: ela usa o critério “alguém mais tem esses commits?” nos três primeiros casos, e cita `ORIG_HEAD` ou o reflog no quarto.

</details>

## 🧠 Revisão rápida

1. Por que os commits mudam de hash depois de um rebase?
2. Em que branch você roda `git rebase main`?
3. Qual é a regra de ouro do rebase?
4. No conflito durante um rebase, o que fica entre `<<<<<<< HEAD` e `=======`?
5. Qual a diferença entre `squash` e `fixup`?
6. (Capítulo 4) A que commit `HEAD~4` se refere?
7. (Capítulo 6) Depois de um rebase da branch sobre a `main`, que tipo de merge acontece na `main`?

<details>
<summary>Ver resposta</summary>

1. Porque o pai deles muda, e o pai faz parte do conteúdo de que o hash é calculado.
2. Na branch que vai mudar de base (a sua branch de trabalho).
3. Não fazer rebase de commits que já existem fora do seu repositório e em que outras pessoas podem ter trabalhado.
4. A nova base (a `main`), e não o seu commit.
5. Os dois juntam o commit ao de cima; o `squash` abre o editor com as duas mensagens, o `fixup` descarta a mensagem do commit juntado.
6. Ao commit quatro passos atrás do atual, seguindo o primeiro pai.
7. Fast-forward.

</details>

## 🤖 Estude com um tutor de IA

```text
Desenhe em texto 4 históricos curtos com duas branches (letras para os
commits), um de cada vez. Para cada um, eu digo como fica o histórico
depois de "git rebase main" na outra branch e se é seguro fazer o rebase.
Só depois da minha resposta, corrija e explique o que eu errei.
```

```text
Este é o meu git log --oneline e a lista que eu escrevi para o git rebase -i:
<log> / <lista>. Meu objetivo é <objetivo>. Diga se a lista chega ao
objetivo e qual commit ficaria errado, sem escrever a lista certa por mim.
```

> ➡️ **Próximo passo:** até aqui, todo o histórico do `receitas` vive num computador só. O capítulo 8 cria outra cópia do repositório, primeiro numa pasta (um *bare repository*) e depois no GitHub, e mostra como enviar e receber commits com `push`, `fetch` e `pull`. É lá que a regra de ouro deste capítulo passa a valer na prática.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| `git rebase <base>` | Reaplica os commits da branch atual em cima da ponta de `<base>`, em linha reta. |
| Commits recriados | Mesmo conteúdo e mensagem, outro pai e, portanto, outro hash. |
| `ORIG_HEAD` | Aponta para onde a branch estava antes do rebase; `git reset --hard ORIG_HEAD` desfaz. |
| Rebase × merge | O merge preserva a história como aconteceu; o rebase a reorganiza em linha reta. |
| Regra de ouro | Não faça rebase de commits que outras pessoas já têm. |
| Conflito no rebase | Edite, `git add`, `git rebase --continue`; `--skip` pula; `--abort` desiste. |
| `git rebase -i` | Lista os commits para `pick`, `reword`, `edit`, `squash`, `fixup` ou `drop`. |
| Apagar uma linha da lista | É o mesmo que `drop`: o commit some. |

## 📚 Fontes

- [Pro Git, 3.6 — Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) (consultado em 21/11/2026)
- [Pro Git, 7.6 — Rewriting History](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History) (consultado em 21/11/2026)
- [git-rebase](https://git-scm.com/docs/git-rebase), [git-commit](https://git-scm.com/docs/git-commit) (`--fixup`) e [git-config](https://git-scm.com/docs/git-config) (`pull.rebase`) — Git Reference Manual (Git 2.56, consultados em 21/11/2026)
- Anotações do curso “Git e GitHub Essencial para o Desenvolvedor” (Geek University, Udemy): “Rebase”: estrutura e tópicos.

> 🔁 **Revise hoje:** capítulos 4 (`HEAD~n`, autor × committer) e 6 (branches, fast-forward e conflitos de merge).
