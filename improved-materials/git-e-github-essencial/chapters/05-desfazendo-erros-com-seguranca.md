# 5. Desfazendo erros com segurança

> 🗺️ **Neste capítulo:** um comando para cada tipo de erro: descartar uma edição, tirar um arquivo da staging area, consertar o último commit, visitar uma versão antiga, voltar commits e desfazer um commit antigo. E como recuperar o que parecia perdido. · ⏱️ ~60 min

> 🔥 **Aquecimento:**
>
> 1. (Capítulo 4) O que `HEAD~2` quer dizer, e por que ele muda depois de um commit novo?
> 2. (Capítulo 3) Em que área fica a versão de um arquivo depois do `git add`?
>
> <details>
> <summary>Ver resposta</summary>
>
> 1. O commit dois passos antes do atual. É um nome relativo ao `HEAD`: quando o `HEAD` avança, `HEAD~2` passa a apontar outro commit.
> 2. Na staging area.
>
> </details>

## De onde paramos

No capítulo 4 o `receitas` chegou a sete commits, e você aprendeu a encontrar qualquer mudança com `git log`, `git show` e `git diff`. Agora vem a pergunta seguinte: encontrei o erro, como desfaço? O Git tem vários comandos para isso, e escolher o errado pode apagar trabalho. Por isso o capítulo segue uma regra: para cada situação, o caminho mais seguro primeiro.

![Fluxo de decisão: o que você quer desfazer? Se a mudança ainda não está num commit, git restore (ou git restore --staged, se já está na staging area). Se o commit já foi compartilhado, git revert. Se o erro está no último commit, git commit --amend. Senão, git reset, com --soft, --mixed ou --hard](../img/c05-o-que-desfazer.svg)

Volte a este diagrama sempre que precisar desfazer algo. As seções a seguir explicam cada saída dele.

## restore

### Descartar uma edição

A Ana foi mexer na receita de bolo e, sem querer, apagou duas linhas de ingredientes. O arquivo ainda não foi para a staging area:

```bash
git status -s
git diff
```

```text
 M receitas/bolo-de-cenoura.md
diff --git a/receitas/bolo-de-cenoura.md b/receitas/bolo-de-cenoura.md
index da75515..bce0ac3 100644
--- a/receitas/bolo-de-cenoura.md
+++ b/receitas/bolo-de-cenoura.md
@@ -1,7 +1,5 @@
 # Bolo de cenoura
 
-- 3 cenouras médias
-- 4 ovos
 - 1 e 1/2 xícara de açúcar
 
 Forno: 180 °C por 45 min.
```

Ela quer o arquivo exatamente como estava. **O `git restore <arquivo>` substitui o arquivo do diretório de trabalho pela versão da staging area, descartando as edições que ainda não passaram por `git add`.** Como o bolo não foi preparado, a versão da staging area é a do último commit.

```bash
git restore receitas/bolo-de-cenoura.md
git status -s
```

O `git status -s` não mostra nada: o arquivo voltou a ser igual ao último commit, e as duas linhas estão de volta.

No VS Code, o mesmo botão fica ao lado do arquivo no painel Source Control:

![Painel Source Control do VS Code com bolo-de-cenoura.md em Changes; ao lado do nome, os botões de abrir arquivo, descartar mudanças (seta curva) e adicionar (+); no editor, a receita sem as linhas das cenouras e dos ovos, com uma marca vermelha na margem onde elas estavam](../img/c05-vscode-descartar.png)

*A seta curva ao lado do arquivo (Discard Changes) faz o mesmo que `git restore`. A marca vermelha na margem do editor mostra onde havia linhas que foram apagadas. Captura do VS Code (code-server).*

> ⚠️ **Erro comum:** usar o `git restore` para “dar uma olhada” e depois querer a edição de volta. Uma mudança que nunca passou por `git add` nem por commit não está em lugar nenhum do Git: o `restore` a apaga de vez. Antes de descartar, rode `git diff` e confira o que vai embora.

### Tirar um arquivo da staging area

O `receitas` vai ganhar o pudim, que estava nos rascunhos do capítulo 3 e foi aprovado no teste. A Ana cria `receitas/pudim.md`, acrescenta o link no `index.html` e, na pressa, roda `git add .`. Só que a lista de compras dela, `lista-de-compras.txt`, estava na mesma pasta:

```bash
git add .
git status -s
```

```text
M  index.html
A  lista-de-compras.txt
A  receitas/pudim.md
```

**O `git restore --staged <arquivo>` tira o arquivo da staging area, copiando para lá a versão do último commit; o arquivo na pasta não muda.**

```bash
git restore --staged lista-de-compras.txt
git status -s
```

```text
M  index.html
A  receitas/pudim.md
?? lista-de-compras.txt
```

A lista voltou a ser *untracked*, intacta na pasta. Para um arquivo que já existia no último commit, o `--staged` o deixa como *modified*, com a edição preservada no diretório de trabalho. Se a lista nunca deve ir para o repositório, o lugar dela é o `.gitignore` do capítulo 3.

O próprio `git status` lembra esses comandos entre parênteses: `(use "git restore --staged <file>..." to unstage)` e `(use "git restore <file>..." to discard changes in working directory)`.

### Trazer a versão de um commit antigo

Com `--source`, o `restore` busca o arquivo em qualquer commit. A Ana quer conferir como era o bolo no primeiro commit:

```bash
git restore --source=9a16b95 receitas/bolo-de-cenoura.md
git diff
```

```text
diff --git a/receitas/bolo-de-cenoura.md b/receitas/bolo-de-cenoura.md
index da75515..288da0e 100644
--- a/receitas/bolo-de-cenoura.md
+++ b/receitas/bolo-de-cenoura.md
@@ -2,8 +2,6 @@
 
 - 3 cenouras médias
 - 4 ovos
-- 1 e 1/2 xícara de açúcar
+- 2 xícaras de açúcar
 
-Forno: 180 °C por 45 min.
-
-Dica: unte a forma com manteiga e farinha.
+Forno: 180 °C por 40 min.
```

O arquivo da pasta agora é o de 21/11 às 10h, e o `git status` o mostra como modificado. Se ela quisesse ficar com essa versão, faria `git add` e um commit. Como era só para conferir, um `git restore receitas/bolo-de-cenoura.md` traz a versão atual de volta.

| Comando | De onde vem a versão | O que muda |
| --- | --- | --- |
| `git restore <arq>` | staging area | o diretório de trabalho |
| `git restore --staged <arq>` | último commit (`HEAD`) | a staging area |
| `git restore --source=<commit> <arq>` | o commit indicado | o diretório de trabalho |

> 💡 O `git restore` e o `git switch` (próximas seções) existem desde o Git 2.23, de 2019. Antes, tudo isso era feito com o `git checkout` (`git checkout -- arquivo`) e com o `git reset HEAD arquivo`. Você ainda vai encontrar essas formas em tutoriais e respostas antigas; elas funcionam, mas o `checkout` faz coisas demais com um nome só, e é fácil confundir.

## commit --amend

A Ana faz o commit do pudim. Ela tinha preparado só o arquivo da receita, e escreve a mensagem rápido demais:

```bash
git commit -m "Adiciona a receita de pudm"
```

```text
[main c8eed78] Adiciona a receita de pudm
 1 file changed, 8 insertions(+)
 create mode 100644 receitas/pudim.md
```

Dois problemas: “pudm” e o link do `index.html`, que ficou de fora (`1 file changed`). Um segundo commit “Corrige o anterior” deixaria o histórico com um commit quebrado e outro de remendo.

**O `git commit --amend` substitui o último commit por um novo, com o conteúdo da staging area e a mensagem que você der.**

```bash
git add index.html
git commit --amend -m "Adiciona a receita de pudim"
git log --oneline -n 2
```

```text
[main 4ae3416] Adiciona a receita de pudim
 Date: Mon Nov 23 09:00:00 2026 -0300
 2 files changed, 9 insertions(+)
 create mode 100644 receitas/pudim.md
4ae3416 Adiciona a receita de pudim
c33ad78 Reduz o açúcar do bolo para 1 e 1/2 xícara
```

O `c8eed78` sumiu do `git log`, e no lugar dele está o `4ae3416`, com os dois arquivos e a mensagem certa. Repare no hash novo: o Git não edita commits (o conteúdo mudou, então o hash também). Ele cria outro e faz a `main` apontar para ele. A linha `Date:` mostra que a data do autor foi mantida, a do primeiro commit.

Só para corrigir a mensagem, sem mudar arquivos, rode `git commit --amend -m "nova mensagem"` com a staging area vazia. Para manter a mensagem e só incluir um arquivo esquecido, use `git commit --amend --no-edit`.

> ⚠️ **Erro comum:** usar `--amend` num commit que já foi compartilhado (enviado a um servidor, como você vai fazer no capítulo 8). Quem já tem o commit antigo passa a ter um histórico diferente do seu. Use o `--amend` só no último commit, e só enquanto ele existir apenas no seu computador.

## checkout de um commit e detached HEAD

Às vezes você quer **ver** o projeto inteiro como ele era num commit antigo, e não só um arquivo: abrir o site, rodar o programa, testar. Para isso, você pode pôr o `HEAD` direto num commit antigo:

```bash
git switch --detach 9b3de16
git status
```

```text
HEAD is now at 9b3de16 Ajusta o tempo de forno do bolo
HEAD detached at 9b3de16
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.env
	rascunhos/
	servidor.log

nothing added to commit but untracked files present (use "git add" to track)
```

Todos os arquivos rastreados voltaram a ser como em 21/11 às 10h30: o bolo tem 2 xícaras de açúcar, e o brigadeiro e o pudim não existem na pasta. Os arquivos ignorados e não rastreados (`.env`, `servidor.log`) ficam onde estão, porque o Git não cuida deles. O `.gitignore` não aparece mais porque ainda não existia naquele commit; por isso esses arquivos voltam a ser listados.

**Detached HEAD (HEAD desanexado) é o estado em que o `HEAD` aponta direto para um commit, e não para uma branch como a `main`.** Compare com o capítulo 4:

```bash
cat .git/HEAD
```

```text
9b3de16ce2245ddfb640e8901a24b788ecdc3af6
```

Antes, o arquivo dizia `ref: refs/heads/main`. Agora tem um hash. Na forma antiga, o mesmo efeito vinha do `git checkout 9b3de16`, que mostra um aviso longo:

```text
Note: switching to '9b3de16'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 9b3de16 Ajusta o tempo de forno do bolo
```

O aviso resume o que importa: você pode olhar e até fazer commits experimentais, mas eles não pertencem a nenhuma branch. Veja o que acontece. A Ana testa o forno a 200 °C nessa versão antiga e faz um commit:

```bash
git commit -am "Testa forno a 200 °C por 35 min"
git log --oneline -n 3
```

```text
[detached HEAD 9cba308] Testa forno a 200 °C por 35 min
 1 file changed, 1 insertion(+), 1 deletion(-)
9cba308 Testa forno a 200 °C por 35 min
9b3de16 Ajusta o tempo de forno do bolo
9a16b95 Cria a página inicial e a receita de bolo
```

Para voltar ao trabalho normal, ela volta para a `main`:

```bash
git switch main
```

```text
Warning: you are leaving 1 commit behind, not connected to
any of your branches:

  9cba308 Testa forno a 200 °C por 35 min

If you want to keep it by creating a new branch, this may be a good time
to do so with:

 git branch <new-branch-name> 9cba308

Switched to branch 'main'
```

O Git avisa que o `9cba308` ficou para trás, sem nenhuma branch apontando para ele. Ele não aparece no `git log` da `main`, mas também não foi apagado: a última seção deste capítulo mostra como encontrá-lo, e o capítulo 6 mostra como guardá-lo numa branch.

> ⚠️ **Erro comum:** esquecer que está em detached HEAD e trabalhar por horas ali. Os commits ficam soltos e podem se perder quando você trocar de branch. Se o `git status` começa com `HEAD detached at`, volte com `git switch main` antes de trabalhar de verdade, ou crie uma branch para o experimento (capítulo 6).

## reset --soft/--mixed/--hard

A Ana testa um fundo escuro para o site e faz um commit:

```bash
git log --oneline -n 3
```

```text
8d224df Testa fundo escuro no site
4ae3416 Adiciona a receita de pudim
c33ad78 Reduz o açúcar do bolo para 1 e 1/2 xícara
```

<!-- project: receitas -->

**estilo.css**

```css
/* teste: fundo escuro para ler à noite */
body { background: #222; color: #eee; }
```

Depois de pensar, ela não quer esse commit no histórico, pelo menos não agora. O `--amend` só substitui o último commit; para **tirá-lo** da branch, existe o `reset`.

**O `git reset <commit>` faz a branch atual (e o `HEAD`) apontar para o commit indicado; os commits que vinham depois saem do `git log`. O modo diz o que acontece com as mudanças desses commits.**

Preveja: depois de `git reset --soft HEAD~1`, o `estilo.css` aparece como `A`, como `??` ou some?

```bash
git reset --soft HEAD~1
git log --oneline -n 2
git status -s
```

```text
4ae3416 Adiciona a receita de pudim
c33ad78 Reduz o açúcar do bolo para 1 e 1/2 xícara
A  estilo.css
```

O commit saiu do histórico, mas a mudança continua **preparada**, pronta para outro commit. O `--soft` serve para refazer um ou mais commits: juntar três commits pequenos num só, por exemplo.

A Ana faz o commit de novo (agora `1a1d6ff`) e testa o modo padrão, o `--mixed`, que é o que roda quando você não diz modo nenhum:

```bash
git reset HEAD~1
git status -s
```

```text
?? estilo.css
```

O commit saiu e a mudança voltou ao diretório de trabalho, fora da staging area. Como o `estilo.css` é um arquivo novo, ele voltou a ser *untracked*; um arquivo já rastreado apareceria como ` M`. O `--mixed` serve para reorganizar: você escolhe de novo, com `git add`, o que vai em cada commit.

Por fim, ela commita outra vez (agora `38d0ae7`) e usa o modo que apaga:

```bash
git reset --hard HEAD~1
git status -s
ls
```

```text
HEAD is now at 4ae3416 Adiciona a receita de pudim
index.html
rascunhos
receitas
servidor.log
```

O commit saiu e o `estilo.css` sumiu da pasta. O `--hard` deixa staging area e diretório de trabalho iguais ao commit indicado.

| Modo | Move a branch | Staging area | Diretório de trabalho |
| --- | --- | --- | --- |
| `--soft` | sim | mantém as mudanças | mantém |
| `--mixed` (padrão) | sim | volta a ser igual ao commit | mantém as mudanças |
| `--hard` | sim | volta a ser igual ao commit | volta a ser igual ao commit (apaga as mudanças) |

![Três camadas: --soft move o HEAD e deixa as mudanças na staging area (A estilo.css); --mixed, o padrão, devolve as mudanças ao diretório de trabalho (?? estilo.css); --hard apaga as mudanças dos arquivos (estilo.css some)](../img/c05-reset-modos.svg)

> ⚠️ **Erro comum:** rodar `git reset --hard` com edições que nunca foram commitadas. Numa cópia do repositório, a Ana acrescentou uma linha de cobertura no bolo e, sem commitar, rodou `git reset --hard HEAD`:
>
> ```text
>  M receitas/bolo-de-cenoura.md
> HEAD is now at 4ae3416 Adiciona a receita de pudim
> ```
>
> A linha da cobertura sumiu e não está em lugar nenhum: o Git nunca a guardou. Commits apagados com `reset` ainda podem ser recuperados (próxima seção); edições não commitadas, não. Antes de um `--hard`, rode `git status`: se aparecer algo, commite, guarde com `git stash` (capítulo 6) ou tenha certeza de que quer jogar fora.

Assim como o `--amend`, o `reset` reescreve o histórico: os commits deixam de existir na branch. Use-o só em commits que ainda não saíram do seu computador.

## revert

Um dia depois, a família da Ana decide que o site deve voltar a se chamar “Receitas da Ana”. A mudança de título foi no `3ea07e1`, e depois dele vieram o açúcar e o pudim, que devem ficar. O `reset` não serve: voltar a `main` para antes do `3ea07e1` levaria junto os commits bons. E, se o site já estivesse publicado com outras pessoas trabalhando nele, reescrever o histórico atrapalharia todo mundo.

**O `git revert <commit>` cria um commit novo que faz o contrário do commit indicado; o commit original continua no histórico.**

```bash
git revert 3ea07e1 --no-edit
git log --oneline -n 3
```

```text
Auto-merging index.html
[main f8f33cf] Revert "Muda o título do site para Receitas de família"
 Date: Mon Nov 23 14:00:00 2026 -0300
 1 file changed, 2 insertions(+), 2 deletions(-)
f8f33cf Revert "Muda o título do site para Receitas de família"
4ae3416 Adiciona a receita de pudim
c33ad78 Reduz o açúcar do bolo para 1 e 1/2 xícara
```

O `--no-edit` aceita a mensagem padrão sem abrir o editor. Veja o que o commit novo fez:

```bash
git show HEAD
```

```text
commit f8f33cf7a1bbd30011fa1486e7ab49321b6d5025
Author: Ana Ribeiro <ana.ribeiro@example.com>
Date:   Mon Nov 23 14:00:00 2026 -0300

    Revert "Muda o título do site para Receitas de família"
    
    This reverts commit 3ea07e15cad31169ba5d29bd3578d567bc70f2f3.

diff --git a/index.html b/index.html
index 3a9637d..351cd98 100644
--- a/index.html
+++ b/index.html
@@ -1,8 +1,8 @@
 <!DOCTYPE html>
 <html lang="pt-BR">
-<head><meta charset="utf-8"><title>Receitas de família</title></head>
+<head><meta charset="utf-8"><title>Receitas da Ana</title></head>
 <body>
-  <h1>Receitas de família</h1>
+  <h1>Receitas da Ana</h1>
   <!-- cada receita nova ganha um item nesta lista -->
   <ul>
     <li><a href="receitas/bolo-de-cenoura.md">Bolo de cenoura</a></li>
```

É o diff do `3ea07e1` ao contrário: as linhas com `+` viraram `-`, e vice-versa. O link do pudim, que veio depois, continua lá. O corpo da mensagem registra qual commit foi desfeito, então quem ler o histórico entende o que aconteceu. A mensagem padrão está em inglês; se preferir, rode sem `--no-edit` e escreva a sua no editor.

Se um commit posterior tivesse mexido nas mesmas linhas, o Git não saberia sozinho como desfazer e pararia com um **conflito**. Resolver conflitos é assunto do capítulo 6; depois de resolver, o revert continua com `git revert --continue`.

![Comparação: git revert 3ea07e1 cria um commit que desfaz o outro, mantém o original no histórico, desfaz qualquer commit mesmo antigo e é seguro em commits compartilhados; git reset --hard HEAD~1 move o HEAD para trás, tira o commit do git log, desfaz do fim para trás e só serve para commits que ninguém mais tem](../img/c05-revert-x-reset.svg)

> 💡 **Analogia:** de volta ao álbum de fotos do projeto. O `reset` move o marcador (o `HEAD` do capítulo 4) para uma foto anterior e arranca as fotos seguintes do álbum; elas vão para uma gaveta (o reflog, na próxima seção), de onde ainda dá para tirá-las por um tempo. O `revert` não arranca nada: cola uma foto nova mostrando a cena como era antes da mudança, com a legenda “desfaz a foto 3ea07e1”. Quem folheia o álbum vê o erro e a correção. A analogia quebra num ponto: uma foto de verdade não “desfaz” outra; no Git, o commit de revert calcula o contrário exato das mudanças do commit original e aplica só isso, deixando o resto do projeto como está.

> ⚠️ **Erro comum:** achar que `git revert 3ea07e1` “volta o projeto para o 3ea07e1”. Ele faz o contrário: desfaz **só as mudanças daquele commit** e mantém tudo o que veio depois. Para ver ou recuperar o projeto como era num commit, use `git switch --detach` ou `git restore --source`.

## reflog

O commit do forno a 200 °C, deixado para trás no detached HEAD, e os três commits do fundo escuro apagados pelo `reset` não aparecem no `git log`. Mas o Git não os apagou de imediato.

**O reflog é o diário local do `HEAD`: cada vez que o `HEAD` se move (commit, amend, reset, switch, revert), o Git anota para onde ele foi.**

```bash
git reflog
```

```text
f8f33cf HEAD@{0}: revert: Revert "Muda o título do site para Receitas de família"
4ae3416 HEAD@{1}: reset: moving to HEAD~1
38d0ae7 HEAD@{2}: commit: Testa fundo escuro no site
4ae3416 HEAD@{3}: reset: moving to HEAD~1
1a1d6ff HEAD@{4}: commit: Testa fundo escuro no site
4ae3416 HEAD@{5}: reset: moving to HEAD~1
8d224df HEAD@{6}: commit: Testa fundo escuro no site
4ae3416 HEAD@{7}: checkout: moving from 9cba30853efe3948cfa216f3fe52af9e0b108da6 to main
9cba308 HEAD@{8}: commit: Testa forno a 200 °C por 35 min
9b3de16 HEAD@{9}: checkout: moving from main to 9b3de16
4ae3416 HEAD@{10}: commit (amend): Adiciona a receita de pudim
c8eed78 HEAD@{11}: commit: Adiciona a receita de pudm
c33ad78 HEAD@{12}: commit: Reduz o açúcar do bolo para 1 e 1/2 xícara
3ea07e1 HEAD@{13}: commit: Muda o título do site para Receitas de família
80f839b HEAD@{14}: commit: Adiciona a receita de brigadeiro
89108b9 HEAD@{15}: commit: Ignora segredos, logs e rascunhos
52fb7d1 HEAD@{16}: commit: Inclui dica de untar a forma
9b3de16 HEAD@{17}: commit: Ajusta o tempo de forno do bolo
9a16b95 HEAD@{18}: commit (initial): Cria a página inicial e a receita de bolo
```

Leia de baixo para cima: é o capítulo inteiro, passo a passo. Lá estão o `c8eed78` com “pudm”, substituído pelo amend; o `9cba308` do forno a 200 °C, feito em detached HEAD (o `switch` aparece como `checkout` no reflog); e os três commits do fundo escuro, cada um seguido do `reset` que o tirou da branch. `HEAD@{2}` quer dizer “onde o `HEAD` estava dois movimentos atrás”, e funciona como nome de commit em qualquer comando, assim como `HEAD~2`.

A Ana mudou de ideia sobre o fundo escuro. O último commit do teste foi o `38d0ae7`:

```bash
git show --stat 38d0ae7
```

```text
commit 38d0ae748b1a96aafd0f767f7dac8776c7063869
Author: Ana Ribeiro <ana.ribeiro@example.com>
Date:   Mon Nov 23 11:20:00 2026 -0300

    Testa fundo escuro no site

 estilo.css | 2 ++
 1 file changed, 2 insertions(+)
```

O commit está inteiro. Um `git reset --hard 38d0ae7` traria a `main` de volta para ele, mas apagaria o revert, que veio depois. O caminho seguro é buscar só o arquivo, com o `restore --source` que você já conhece:

```bash
git restore --source=38d0ae7 estilo.css
git status -s
```

```text
?? estilo.css
```

Ela faz `git add estilo.css` e o commit “Adiciona estilo com fundo escuro”. O trabalho “apagado” voltou para o histórico.

Duas coisas limitam o reflog:

- **É local.** Ele registra só os movimentos do `HEAD` no seu repositório; não vai junto quando você envia commits a um servidor, e cada cópia do projeto tem o seu.
- **Tem prazo.** Por padrão, as entradas expiram em 90 dias; as de commits que não estão em nenhuma branch, como o `9cba308`, em 30 dias. Depois disso, a limpeza automática do Git pode apagar esses commits de vez.

> ⚠️ **Erro comum:** achar que o reflog salva tudo. Ele guarda **commits**. Uma edição que você nunca commitou e apagou com `git restore` ou `git reset --hard` não aparece no reflog. Por isso, na dúvida, commite: um commit pode ser desfeito depois; uma edição perdida, não.

## 🧪 Laboratório: errar de propósito

Continue no `receitas` do capítulo 4 (7 commits, último `c33ad78`). Os seus hashes serão outros; use os do seu `git log` e do seu `git reflog`.

1. Apague as linhas das cenouras e dos ovos do bolo. Confira com `git diff` e desfaça com `git restore`. Confira: `git status -s` vazio.
2. Crie `receitas/pudim.md` (abaixo), o link do pudim no `index.html` e um `lista-de-compras.txt` qualquer. Rode `git add .` e depois `git restore --staged lista-de-compras.txt`. Confira: a lista aparece com `??`.
3. Tire também o `index.html` da staging area (`git restore --staged index.html`) e faça o commit “Adiciona a receita de pudm”. Confira: `1 file changed`.
4. Rode `git add index.html` e `git commit --amend -m "Adiciona a receita de pudim"`. Confira: `git log --oneline -n 2` mostra um hash novo e `2 files changed` na saída do amend. Apague a lista de compras.
5. Rode `git switch --detach` com o hash do commit “Ajusta o tempo de forno do bolo”. Confira: `git status` começa com `HEAD detached at`. Mude o forno para 200 °C por 35 min, faça um commit e volte com `git switch main`. Leia o aviso.
6. Crie o `estilo.css` deste capítulo e faça o commit “Testa fundo escuro no site”. Rode `git reset --soft HEAD~1` e confira `A  estilo.css`; commite de novo, rode `git reset HEAD~1` e confira `?? estilo.css`; commite de novo e rode `git reset --hard HEAD~1`. Confira: o `estilo.css` sumiu da pasta.
7. Rode `git revert` com o hash do commit do título. Confira: o `index.html` voltou a dizer “Receitas da Ana”, e o link do pudim continua lá.
8. Rode `git reflog`, encontre o último “Testa fundo escuro no site” e o commit do forno a 200 °C. Recupere o `estilo.css` com `git restore --source=<hash>` e faça o commit “Adiciona estilo com fundo escuro”.

**receitas/pudim.md**

```markdown
# Pudim de leite

- 1 lata de leite condensado
- 2 medidas (da lata) de leite
- 3 ovos

Calda: 1 xícara de açúcar derretido na forma.
Forno: 180 °C em banho-maria por 1 h 30 min.
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
  </ul>
</body>
</html>
```

Pronto quando: `git log --oneline -n 4` mostra, de cima para baixo, “Adiciona estilo com fundo escuro”, o `Revert "Muda o título..."`, “Adiciona a receita de pudim” e “Reduz o açúcar...”, e `git status` diz `working tree clean`.

```text
aacc41a Adiciona estilo com fundo escuro
f8f33cf Revert "Muda o título do site para Receitas de família"
4ae3416 Adiciona a receita de pudim
c33ad78 Reduz o açúcar do bolo para 1 e 1/2 xícara
```

## 🏋️ Pratique

**1. Exemplo resolvido.** A Ana acabou de commitar “Adiciona receita de feijoada” e percebe duas coisas: incluiu sem querer o `servidor.log` (que deveria estar no `.gitignore`, mas ela tinha apagado a regra) e esqueceu o link no `index.html`. Nada foi enviado a lugar nenhum. Como ela conserta?

1. O erro está no **último** commit, que **não foi compartilhado**: pelo diagrama do início do capítulo, o caminho é o `--amend`.
2. Tirar o log do próximo commit sem apagá-lo da pasta: `git rm --cached servidor.log` (capítulo 3). Isso registra na staging area que o arquivo deixa de ser rastreado.
3. Recolocar `*.log` no `.gitignore` e rodar `git add .gitignore index.html` (com o link já escrito).
4. `git commit --amend --no-edit`: o commit é substituído por um com a receita, o link e o `.gitignore`, sem o log, e com a mesma mensagem.

Confira com `git show --stat`: o `servidor.log` não aparece, e o `index.html` sim. Um `reset` também resolveria, mas o `--amend` faz tudo num passo e não arrisca nada.

**2. Complete.** Escreva o comando para cada situação:

| Situação | Comando |
| --- | --- |
| Editei o `index.html`, não gostei, quero a versão do último commit | `git ______ index.html` |
| Rodei `git add .env` sem querer | `git restore ______ .env` |
| A mensagem do último commit (não enviado) tem um erro de digitação | `git commit ______ -m "..."` |
| Um commit de três dias atrás, já enviado, quebrou o site | `git ______ <hash>` |
| Quero juntar os dois últimos commits (não enviados) num só, mantendo as mudanças preparadas | `git reset ______ HEAD~2` |

<details>
<summary>Ver resposta</summary>

| Situação | Comando |
| --- | --- |
| Descartar edição | `git restore index.html` |
| Tirar da staging area | `git restore --staged .env` |
| Corrigir mensagem | `git commit --amend -m "..."` |
| Desfazer commit compartilhado | `git revert <hash>` |
| Juntar dois commits | `git reset --soft HEAD~2`, e depois um `git commit` |

Os erros mais comuns: usar `reset` na quarta linha (o commit já foi enviado, então reescrever o histórico atrapalha quem já o tem; e o `reset` levaria junto os commits posteriores); e usar `--mixed` ou `--hard` na última (o `--mixed` também funciona, mas exige um novo `git add`; o `--hard` apagaria as mudanças).

</details>

**3. Sozinho.** No seu `receitas`, faça três commits pequenos em sequência (por exemplo, uma linha nova em cada receita). Depois, sem perder nada, transforme os três num único commit com a mensagem “Completa as receitas”. Confira com `git log --oneline -n 2` e `git show --stat`.

<details>
<summary>Ver resposta</summary>

```bash
git reset --soft HEAD~3
git status -s
git commit -m "Completa as receitas"
```

Depois do `reset --soft HEAD~3`, o `git status -s` mostra as três receitas com `M` na primeira coluna: as mudanças dos três commits ficaram preparadas. O commit novo junta tudo. Confira:

- `git log --oneline -n 2` mostra “Completa as receitas” e, abaixo, o commit que vinha antes dos três.
- `git show --stat` lista os três arquivos.
- Se você errou e usou `--hard`, as mudanças sumiram da pasta, mas os três commits estão no `git reflog`: `git reset --hard HEAD@{1}` volta para onde você estava antes do reset.

</details>

**4. Desafio.** Um colega enviou ao servidor do time o commit `b7e21aa`, que apagou a receita de brigadeiro por engano. Depois dele, outras duas pessoas já enviaram commits. Ele propõe: “Faço `git reset --hard` para antes do `b7e21aa` e pronto.” Explique o que daria errado e o que fazer no lugar.

<details>
<summary>Ver resposta</summary>

O `reset --hard` para antes do `b7e21aa` tiraria da branch também os dois commits que vieram depois, de outras pessoas, e apagaria do diretório de trabalho as mudanças deles. E, como os commits já estão no servidor, o histórico local dele deixaria de bater com o de todo mundo; para enviar, ele teria de forçar, apagando o trabalho dos colegas no servidor.

O certo é `git revert b7e21aa`: um commit novo que traz o brigadeiro de volta, sem tocar nos commits seguintes. Depois, ele envia esse commit normalmente.

Confira sua resposta: ela diz que o `reset` leva junto os commits posteriores, que reescrever um histórico compartilhado afeta os outros, e propõe o `revert`.

</details>

## 🧠 Revisão rápida

1. Qual a diferença entre `git restore index.html` e `git restore --staged index.html`?
2. Por que o hash muda depois de um `git commit --amend`?
3. O que é detached HEAD, e como você sai dele?
4. O que acontece com as mudanças em cada modo do `reset`?
5. Por que o `revert` é o caminho certo para commits compartilhados?
6. (Capítulo 4) Que comando mostra a mensagem completa e a diferença de um commit?
7. (Capítulo 2) Que nome e e-mail aparecem como committer quando você usa `--author`?

<details>
<summary>Ver resposta</summary>

1. O primeiro descarta as edições do diretório de trabalho (copia da staging area); o segundo tira o arquivo da staging area (copia do último commit) e não mexe na pasta.
2. Porque o Git não altera commits: cria um commit novo, com outro conteúdo, e portanto outro hash.
3. É quando o `HEAD` aponta direto para um commit, e não para uma branch. Sai com `git switch main` (ou outra branch).
4. `--soft`: ficam na staging area. `--mixed`: voltam ao diretório de trabalho. `--hard`: são apagadas.
5. Porque ele não reescreve o histórico: acrescenta um commit, e quem já tem os commits antigos não é afetado.
6. `git show <commit>`.
7. Os seus, configurados em `user.name` e `user.email`.

</details>

## 🤖 Estude com um tutor de IA

```text
Descreva 6 situações de erro num repositório Git (umas antes do commit,
outras depois, algumas com commits já enviados ao servidor), uma de cada
vez. Para cada uma eu digo qual comando usaria e por quê. Só corrija
depois da minha resposta, e me diga se existe um caminho mais seguro.
```

```text
Expliquei a diferença entre git reset --soft, --mixed e --hard assim:
<sua explicação>. Aponte o que está impreciso ou faltando, sem me dar
uma explicação pronta.
```

> ➡️ **Próximo passo:** você já viu a palavra “branch” algumas vezes: a `main`, o aviso do detached HEAD, o commit que ficou “sem branch”. O capítulo 6 explica o que é uma branch, como trabalhar em várias linhas ao mesmo tempo, guardar trabalho pela metade com `git stash` e juntar tudo com `git merge`, inclusive quando há conflito.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| `git restore <arq>` | Descarta edições do diretório de trabalho, copiando a versão da staging area. |
| `git restore --staged <arq>` | Tira o arquivo da staging area sem mexer na pasta. |
| `git restore --source=<commit> <arq>` | Traz para a pasta a versão do arquivo naquele commit. |
| `git commit --amend` | Substitui o último commit por um novo (hash novo); só antes de compartilhar. |
| Detached HEAD | `HEAD` apontando direto para um commit; commits feitos ali ficam sem branch. |
| `git switch --detach` | Põe o projeto inteiro na versão de um commit, para olhar ou testar. |
| `git reset` | Move a branch para outro commit; `--soft`, `--mixed` (padrão) ou `--hard`. |
| `git revert` | Cria um commit que desfaz outro; seguro em histórico compartilhado. |
| Reflog | Diário local dos movimentos do `HEAD`; recupera commits por 30 a 90 dias. |

## 📚 Fontes

- [Pro Git, 2.4 — Undoing Things](https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things) (consultado em 21/11/2026)
- [Pro Git, 7.7 — Reset Demystified](https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified) (consultado em 21/11/2026)
- [git-restore](https://git-scm.com/docs/git-restore), [git-switch](https://git-scm.com/docs/git-switch), [git-commit](https://git-scm.com/docs/git-commit), [git-reset](https://git-scm.com/docs/git-reset), [git-revert](https://git-scm.com/docs/git-revert), [git-reflog](https://git-scm.com/docs/git-reflog) e [git-gc](https://git-scm.com/docs/git-gc) (prazos `gc.reflogExpire` e `gc.reflogExpireUnreachable`) — Git Reference Manual (Git 2.56, consultados em 21/11/2026)
- [Notas de versão do Git 2.23](https://github.com/git/git/blob/v2.23.0/Documentation/RelNotes/2.23.0.txt) (`git switch` e `git restore`; consultado em 21/11/2026)
- Anotações do curso “Git e GitHub Essencial para o Desenvolvedor” (Geek University, Udemy): “Voltando no tempo com o Git”, “Desfazendo e refazendo ações no Git”, “Desfazendo ações com checkout” e “Desfazendo ações com revert e reset”: estrutura e tópicos.

> 🔁 **Revise hoje:** capítulos 2 (identidade do autor) e 4 (HEAD, `git log` e `git show`).

<!-- nav:start -->
---

[◀ Capítulo anterior](04-commits-e-historico.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](06-branches-stash-e-merge.md)
<!-- nav:end -->
