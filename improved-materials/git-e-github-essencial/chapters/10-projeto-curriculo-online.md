# 10. Projeto: currículo online

> 🗺️ **Neste capítulo:** você junta tudo num projeto seu: um currículo em uma página, versionado com Git, documentado com um README escrito em Markdown, publicado de graça com o GitHub Pages e editado pelo VS Code. No fim, aprende a compartilhar trechos soltos com gists. · ⏱️ ~60 min

> 🔥 **Aquecimento:**
>
> 1. (Capítulo 9) O que `Closes #4` faz na descrição de um pull request?
> 2. (Capítulo 8) Depois de `git remote add origin <endereço>`, qual comando envia a `main` e já deixa o rastreamento configurado?
>
> <details>
> <summary>Ver resposta</summary>
>
> 1. Fecha a issue #4 quando o pull request for mesclado na branch principal.
> 2. `git push -u origin main`.
>
> </details>

## De onde paramos

No capítulo 9 a Carla mandou a primeira contribuição de fora para o `receitas`, por fork e pull request, e a Ana fez o merge com squash. Você já sabe versionar, desfazer, ramificar, sincronizar e colaborar. Falta mostrar o seu trabalho para o mundo: um endereço que você possa pôr no LinkedIn ou mandar para uma vaga.

> ⚠️ **Não executado neste livro:** as telas do GitHub (criar o repositório, ativar o GitHub Pages, criar um gist) exigem uma conta e não foram usadas aqui. Os passos seguem a documentação do GitHub, consultada em 21/11/2026. Todos os comandos `git` foram executados, com um repositório local no lugar do GitHub, como no capítulo 8, e o currículo foi aberto num navegador, no computador.

## Markdown

### Por que existe

Você escreve Markdown desde o capítulo 3: as receitas do `receitas` são arquivos `.md`, com `#` no título e `-` nos ingredientes. Aberto num editor qualquer, o arquivo continua legível; aberto no GitHub, vira uma página com título grande e lista com marcadores. É esse o ponto: um texto que se lê bem **sem** formatação e que **ganha** formatação onde ela existe.

**Markdown é uma forma de escrever texto formatado usando só caracteres comuns (`#`, `*`, `-`, `` ` ``), que programas como o GitHub transformam em títulos, listas, links e tabelas.** Como é texto puro, o Git mostra cada mudança linha a linha no `git diff`, coisa que não acontece com um `.docx`.

No GitHub, Markdown aparece em quase tudo: arquivos `.md`, issues, pull requests, comentários e gists.

### O essencial

| Você escreve | Vira |
| --- | --- |
| `# Título`, `## Seção`, `### Subseção` | títulos de três níveis |
| `**negrito**` e `*itálico*` | **negrito** e *itálico* |
| `- item` (ou `1. item`) | lista com marcadores (ou numerada) |
| `[texto](https://exemplo.com)` | link |
| `![descrição](https://exemplo.com/foto.png)` | imagem |
| `` `git status` `` | código no meio da frase |
| uma linha em branco entre dois trechos | dois parágrafos |

Para um bloco de código, use três crases antes e depois, com o nome da linguagem logo depois das primeiras. O GitHub colore o código conforme a linguagem:

````markdown
```bash
git log --oneline
```
````

O GitHub acrescenta três recursos que você vai usar no README do currículo:

- **Tabelas**, com `|` entre as colunas e uma linha `| --- | --- |` debaixo do cabeçalho.
- **Listas de tarefas**: `- [ ]` para uma tarefa aberta e `- [x]` para uma feita. Viram caixinhas de marcar.
- **Alertas**: uma citação (`>`) cuja primeira linha é `[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]` ou `[!CAUTION]`. Viram um quadro colorido com ícone. A própria documentação recomenda usar no máximo um ou dois por página.

```markdown
> [!TIP]
> Antes de cada push, abra o `index.html` no navegador e confira.
```

> ⚠️ **Erro comum:** quebrar a linha com um Enter e esperar uma linha nova. Num arquivo `.md`, duas linhas seguidas viram um parágrafo só. Para um parágrafo novo, deixe uma linha em branco; para só pular a linha, termine a anterior com uma barra invertida (`\`) ou com dois espaços. (Em issues, pull requests e comentários, o GitHub respeita o Enter.)

## README

### Por que existe

Quem chega a um repositório quer saber, em segundos: o que é isto, como eu vejo funcionando, como eu ajudo. Se a resposta estiver espalhada pelo código, a pessoa desiste.

**O README é o arquivo de apresentação de um repositório (normalmente `README.md`), que o GitHub mostra logo abaixo da lista de arquivos.** O GitHub procura o README nesta ordem: na pasta `.github`, na raiz do repositório e na pasta `docs`. Ele também monta sozinho um sumário com os títulos do arquivo, no menu **Outline**, no canto de cima da página.

### O README do currículo

A Ana começa o projeto novo do zero, numa pasta com o nome que o GitHub Pages vai exigir (a próxima seção explica por quê), e escreve o README em Markdown, com uma tabela e uma lista de tarefas:

```markdown
# Currículo da Ana Ribeiro

Meu currículo em uma página, publicado com **GitHub Pages**.

## Como ver no seu computador

1. Clone o repositório.
2. Abra o `index.html` no navegador.

## Arquivos

| Arquivo | Para quê |
| --- | --- |
| `index.html` | o conteúdo do currículo |
| `estilo.css` | cores, fontes e margens |

## Como atualizar

- [x] Editar o `index.html`
- [x] Conferir no navegador
- [ ] Fazer commit e push: o site se atualiza sozinho
```

Um bom README responde, nesta ordem:

1. **O que é**, em uma ou duas frases.
2. **Como ver ou usar**: instalar, rodar, abrir.
3. **Como contribuir** (num projeto aberto a contribuições): o fluxo combinado (capítulo 9) e onde abrir issues.
4. **Licença**, quando o projeto puder ser reaproveitado por outras pessoas.

Com o `index.html` e o `estilo.css` (o código completo está no laboratório), ela cria o repositório e faz o primeiro commit:

```bash
mkdir ana-ribeiro.github.io
cd ana-ribeiro.github.io
git init
# (cria index.html, estilo.css e README.md)
git status -s
git add .
git commit -m "Cria o currículo em uma página"
```

```text
Initialized empty Git repository in .../ana-ribeiro.github.io/.git/
?? README.md
?? estilo.css
?? index.html
[main (root-commit) 2d3855c] Cria o currículo em uma página
 3 files changed, 63 insertions(+)
 create mode 100644 README.md
 create mode 100644 estilo.css
 create mode 100644 index.html
```

> ⚠️ **Erro comum:** um README que só repete o nome do repositório, ou com instruções que pararam de funcionar. Teste o “Como ver” de tempos em tempos, como se você nunca tivesse visto o projeto. Se um passo mudou, o README muda no mesmo commit.

### 🔎 Para ir além: o README do seu perfil

O GitHub tem um README especial, que aparece no alto da página do **seu perfil**. Para criá-lo, faça um repositório com **exatamente o mesmo nome do seu usuário** (se o usuário é `ana-ribeiro`, o repositório é `ana-ribeiro/ana-ribeiro`), **público**, com um `README.md` não vazio na raiz. Na tela de criação, marque **Public**, ligue **Add README** e clique em **Create repository**. É um bom lugar para um resumo de quem você é, com um link para o currículo.

## GitHub Pages

### Por que existe

Um currículo em HTML no seu computador só você vê. Para pôr no ar, você precisaria de um servidor, um domínio e um jeito de enviar os arquivos. O GitHub já guarda os arquivos do seu repositório; falta só servi-los como site.

**O GitHub Pages é o serviço do GitHub que publica como site os arquivos HTML, CSS e JavaScript de um repositório, num endereço `github.io`.** É hospedagem de site **estático**: o navegador recebe os arquivos como estão. Não roda código no servidor nem banco de dados, o que basta para um currículo, um portfólio ou a documentação de um projeto.

Há dois tipos de site:

| | Site de usuário | Site de projeto |
| --- | --- | --- |
| Nome do repositório | `<usuario>.github.io` (em minúsculas) | qualquer um, como `receitas` |
| Endereço | `https://<usuario>.github.io` | `https://<usuario>.github.io/receitas` |
| Quantos | um por conta | um por repositório |

O currículo é o site de usuário: o endereço mais curto, que é o seu nome. Por isso a pasta da Ana se chama `ana-ribeiro.github.io`.

### Publicar

**1. Criar o repositório e enviar.** No GitHub, crie um repositório vazio chamado `<seu-usuario>.github.io`, como no capítulo 8. No plano gratuito (GitHub Free), o repositório de um site do Pages precisa ser **público**. Depois, envie o projeto. No laboratório, um bare repository faz o papel do GitHub:

```bash
# no GitHub, o origin seria o endereço do repositório criado lá
git init --bare ../ana-ribeiro.github.io.git
git remote add origin ../ana-ribeiro.github.io.git
git push -u origin main
```

```text
Initialized empty Git repository in .../ana-ribeiro.github.io.git/
To ../ana-ribeiro.github.io.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

**2. Ativar o Pages.** Na página do repositório:

1. Clique em **Settings**.
2. Na barra lateral, na seção **Code, planning, and automation**, clique em **Pages**.
3. Em **Build and deployment**, no campo **Source**, escolha **Deploy from a branch**.
4. No menu da branch (que começa em **None**), escolha `main`; no menu da pasta, deixe **/ (root)**.
5. Clique em **Save**.

**3. Esperar e abrir.** A publicação pode levar **até 10 minutos** depois de cada push. Abra `https://<seu-usuario>.github.io`.

O Pages procura um arquivo de entrada na pasta escolhida: `index.html`, `index.md` ou `README.md`. Se o `index.html` estiver dentro de uma subpasta, o endereço principal não encontra nada.

Quando você publica a partir de uma branch, o GitHub passa os arquivos pelo **Jekyll**, um gerador de sites que, entre outras coisas, transforma arquivos `.md` em páginas. Para um site feito só de HTML e CSS, como o da Ana, ele não atrapalha. Se um dia você quiser que o GitHub publique os arquivos sem passar por ele, crie na raiz um arquivo vazio chamado `.nojekyll`.

No computador, sem o GitHub, a Ana confere o resultado abrindo o `index.html` no navegador:

![O currículo da Ana aberto no navegador: o nome Ana Ribeiro como título, a linha “Desenvolvedora web em formação · São Paulo, SP” e as seções Projetos (receitas e horta comunitária), Formação (Técnico em Informática, 2025; Git e GitHub essencial, 2026) e Contato, cada título sublinhado em azul](../img/c10-curriculo-no-navegador.png)

*O mesmo `index.html` que o GitHub Pages publica. Captura do navegador, com o site servido no próprio computador.*

![Diagrama de sequência entre a Ana (local), o repositório no GitHub, o GitHub Pages e um visitante: 1, git push da branch main para o repositório; 2, o repositório entrega ao Pages, que monta o site em até 10 minutos; 3, o visitante abre usuario.github.io; 4, o Pages devolve o index.html. A configuração em Settings, Pages é feita uma vez só; depois, cada push atualiza o site](../img/c10-publicar.svg)

> 💡 **Analogia:** no álbum de fotos do projeto, o álbum fica guardado na casa da avó (o repositório no GitHub). O GitHub Pages é um **porta-retrato na janela, virado para a rua**: ele mostra sempre a foto mais recente da `main` (o último commit), e quem passa na calçada (qualquer pessoa na internet) vê sem precisar entrar. Cada foto nova colada no álbum (o push) troca a do porta-retrato. A analogia quebra em dois pontos: a troca não é na hora (pode levar até 10 minutos), e o porta-retrato mostra a foto inteira, com todos os arquivos da pasta publicada, não só o que você escolheu destacar.

> ⚠️ **Erro comum:** pôr no currículo publicado o telefone, o endereço de casa ou o CPF. O site é público para qualquer pessoa na internet, e o histórico do Git guarda o dado mesmo depois que você o apaga do arquivo (capítulo 3). Contato por e-mail basta. Outro erro frequente: errar o nome do repositório (com maiúsculas ou outro usuário) e ganhar um site de projeto em vez do site de usuário.

## Git no VS Code

### O ciclo inteiro pelo painel

Você já viu pedaços do VS Code nos capítulos anteriores: o arquivo nas duas listas do painel **Source Control** (capítulo 3), o histórico na seção **Graph** (capítulo 4), o botão de descartar mudanças (capítulo 5) e os botões do conflito (capítulo 6). **O painel Source Control (atalho `Ctrl+Shift+G`) é a interface do VS Code para os mesmos comandos do Git que você roda no terminal: ele chama o Git instalado no seu computador, com a mesma configuração e a mesma identidade.**

A Ana acrescenta o curso de Git à formação, no `index.html`, e uma dica no README. Ela prepara só o `index.html`, clicando no **+** ao lado do arquivo, e o painel fica assim:

![VS Code com o index.html aberto e a linha 25, “Git e GitHub essencial (estudo individual), 2026”, marcada em verde na margem; no painel Source Control, a caixa de mensagem, o botão Commit, o index.html em Staged Changes e o README.md em Changes, ambos com M; na seção Graph, o commit “Cria o currículo em uma página” com as etiquetas main e origin; na barra de status, main*+](../img/c10-vscode-source-control.png)

*Cada botão do painel tem um comando por trás. Captura do VS Code (code-server).*

| No VS Code | No terminal |
| --- | --- |
| **+** ao lado do arquivo (Stage Changes) | `git add <arquivo>` |
| **−** ao lado do arquivo (Unstage Changes) | `git restore --staged <arquivo>` |
| caixa **Message** + botão **Commit** | `git commit -m "..."` |
| **Sync Changes** | `git pull` seguido de `git push` |
| nome da branch na barra de status | `git switch` |
| seção **Graph** | `git log --oneline --graph` |

Ela prepara o README também, escreve a mensagem, clica em **Commit** e depois em **Sync Changes**. O resultado é o mesmo destes comandos:

```bash
# o que os botões Commit e Sync Changes fizeram por ela
git add README.md
git commit -m "Adiciona o curso de Git à formação"
git push
git log --oneline
git status -sb
```

```text
[main 82ecf4a] Adiciona o curso de Git à formação
 2 files changed, 4 insertions(+)
To ../ana-ribeiro.github.io.git
   2d3855c..82ecf4a  main -> main
82ecf4a Adiciona o curso de Git à formação
2d3855c Cria o currículo em uma página
## main...origin/main
```

Até 10 minutos depois desse push, o curso novo aparece no site.

Para o que o painel não mostra (o `reflog`, um `rebase -i`, um `reset` com um modo específico), use o terminal integrado (**Terminal → New Terminal**): os dois mexem no mesmo repositório, e você pode alternar à vontade. Existem extensões que acrescentam recursos ao painel, como a GitLens e a Git Graph, no Marketplace do VS Code; nada neste livro depende delas.

> ⚠️ **Erro comum:** clicar em **Sync Changes** achando que ele só envia. Ele faz `pull` e depois `push`: se o remoto tiver commits novos, eles são integrados à sua branch antes do envio, e isso pode trazer um merge ou um conflito (capítulo 8); se houver conflito, o push nem acontece. Se quiser só ver o que chegou, use **More Actions** (**...**) → **Fetch** no painel, ou `git fetch` no terminal, e olhe a seção **Graph** antes de integrar.

## Gists

### Por que existe

A Ana criou um atalho para ver o histórico, que usa em todo projeto, e quer mandar para a Carla. Criar um repositório inteiro para três linhas é exagero; colar no chat perde a formatação e some na conversa.

**Um gist é um trecho de texto ou código (um ou poucos arquivos) guardado no GitHub, com endereço próprio, para compartilhar.** Gists ficam em `https://gist.github.com`. Cada gist é um repositório Git: tem histórico de versões (aba **Revisions**), pode receber fork e ser clonado.

O trecho que a Ana vai compartilhar é um *alias*, um apelido que o Git guarda na configuração (capítulo 2) para um comando mais longo:

```bash
# um apelido: "git lg" passa a rodar o comando inteiro
git config --global alias.lg "log --oneline --graph --all"
git lg
```

```text
* 82ecf4a Adiciona o curso de Git à formação
* 2d3855c Cria o currículo em uma página
```

### Criar um gist

1. Entre em `https://gist.github.com` com a sua conta.
2. Em **Gist description**, escreva para que serve: `Alias do Git para ver o histórico em uma linha por commit`.
3. Em **Filename including extension**, dê um nome com extensão: `alias-lg.md`. A extensão decide a formatação (`.md` vira Markdown; `.sh`, código colorido).
4. Cole o conteúdo.
5. Escolha a visibilidade: o botão principal é **Create secret gist**; na seta ao lado dele está **Create public gist**.

| | Gist público | Gist secreto |
| --- | --- | --- |
| Aparece no seu perfil e nas buscas | sim | não |
| Quem tem o link vê | sim | **sim** |
| Pode mudar de visibilidade | não vira secreto | pode virar público |

Para baixar um gist com o Git, use o menu **Embed** da página do gist e escolha **Clone via HTTPS** ou **Clone via SSH**; o endereço vai num `git clone`, como qualquer repositório.

![Comparação: o repositório guarda um projeto inteiro com pastas, tem issues, pull requests e Pages, é público ou privado, tem colaboradores e forks, e serve para o currículo da Ana; o gist guarda um ou poucos arquivos sem pastas, tem comentários e revisões, é público ou secreto (secreto não é privado), aceita fork e clone sem colaboradores, e serve para o alias de log da Ana](../img/c10-repositorio-x-gist.svg)

> ⚠️ **Erro comum:** achar que gist secreto é privado. Ele só não aparece em listas e buscas: qualquer pessoa com o link vê o conteúdo. Nunca ponha num gist um token, uma senha ou um `.env` (capítulo 3). Para código que ninguém mais pode ver, use um repositório privado.

## 🧪 Laboratório: o seu currículo no ar

Comece numa pasta nova, fora do `receitas`. Confira cada passo com `git status -s` e `git log --oneline`.

1. Crie a pasta `<seu-usuario>.github.io` (no seu usuário do GitHub, em minúsculas), entre nela e rode `git init`.
2. Crie os três arquivos abaixo, trocando os dados da Ana pelos seus. Sem telefone nem endereço.
3. Abra o `index.html` no navegador (duplo clique no arquivo) e confira.
4. Faça o primeiro commit. Confira: `git log --oneline` com um commit e `git status -s` vazio.
5. Treine o remoto como no capítulo 8: `git init --bare ../<seu-usuario>.github.io.git`, `git remote add origin` com esse caminho e `git push -u origin main`. Depois, troque pelo GitHub: crie o repositório vazio `<seu-usuario>.github.io`, público, e rode `git remote set-url origin https://github.com/<seu-usuario>/<seu-usuario>.github.io.git` e `git push`.
6. Ative o Pages (**Settings → Pages → Deploy from a branch → main → / (root) → Save**) e, alguns minutos depois, abra `https://<seu-usuario>.github.io`.
7. Abra a pasta no VS Code. Acrescente uma linha à formação e uma dica no README. Prepare só o `index.html` pelo **+**; confira no painel um arquivo em **Staged Changes** e outro em **Changes**, e no terminal, `M ` e ` M` no `git status -s`.
8. Prepare o README, faça o commit e o **Sync Changes** pelo painel. Confira: `git status -sb` sem `ahead`, e o site atualizado em até 10 minutos.
9. Crie o alias `lg` e um gist secreto com ele. Abra o link do gist numa janela anônima do navegador: ele aparece, porque secreto não é privado.

Pronto quando: o endereço `https://<seu-usuario>.github.io` mostra o seu currículo com a linha acrescentada no passo 7, e `git log --oneline` mostra dois commits.

Os arquivos do currículo:

<details>
<summary>Ver o código completo</summary>

<!-- project: curriculo -->

**index.html**

```html
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <!-- sem esta linha, o celular mostra a página miniaturizada -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Ana Ribeiro · Currículo</title>
  <link rel="stylesheet" href="estilo.css">
</head>
<body>
  <h1>Ana Ribeiro</h1>
  <p>Desenvolvedora web em formação · São Paulo, SP</p>

  <h2>Projetos</h2>
  <ul>
    <li><strong>receitas</strong>: site de receitas da família, mantido com
      Git e GitHub, com contribuições por pull request.</li>
    <li><strong>horta comunitária</strong>: página de avisos da horta do
      bairro.</li>
  </ul>

  <h2>Formação</h2>
  <ul>
    <li>Técnico em Informática, 2025</li>
    <li>Git e GitHub essencial (estudo individual), 2026</li>
  </ul>

  <h2>Contato</h2>
  <p>ana.ribeiro@example.com</p>
</body>
</html>
```

**estilo.css**

```css
/* uma coluna estreita é mais fácil de ler em qualquer tela */
body {
  max-width: 40rem;
  margin: 2rem auto;
  padding: 0 1rem;
  font-family: system-ui, sans-serif;
  line-height: 1.5;
  color: #222;
}
h2 {
  border-bottom: 2px solid #2a7ae2;
}
```

**README.md**

```markdown
# Currículo da Ana Ribeiro

Meu currículo em uma página, publicado com **GitHub Pages**.

## Como ver no seu computador

1. Clone o repositório.
2. Abra o `index.html` no navegador.

## Arquivos

| Arquivo | Para quê |
| --- | --- |
| `index.html` | o conteúdo do currículo |
| `estilo.css` | cores, fontes e margens |

## Como atualizar

- [x] Editar o `index.html`
- [x] Conferir no navegador
- [ ] Fazer commit e push: o site se atualiza sozinho

> [!TIP]
> Antes de cada push, abra o `index.html` no navegador e confira.
```

</details>

## 🏋️ Pratique

**1. Exemplo resolvido.** O `receitas` nunca ganhou um README. Escreva um, para quem chega ao repositório pela primeira vez.

```markdown
# Receitas da Ana

Site com as receitas da família: bolos, doces, salgados e bebidas,
cada uma num arquivo Markdown da pasta `receitas/`.

## Como ver

Abra o `index.html` no navegador e clique na receita.

## Como contribuir

1. Faça um fork e crie uma branch com o nome da receita.
2. Escreva a receita em `receitas/<nome>.md`, com título,
   ingredientes em lista e o forno no fim.
3. Acrescente o link no `index.html`.
4. Abra um pull request. Achou um erro numa receita? Abra uma issue.
```

Por que assim: a primeira frase diz o que é e onde ficam as receitas; “Como ver” tem um passo só, porque o site não precisa de instalação; “Como contribuir” segue o fluxo do capítulo 9 (fork, branch, pull request) e diz o formato esperado, para que os PRs cheguem parecidos com as receitas que já existem.

**2. Complete.** Preencha as lacunas para que o trecho vire: um título de seção, uma lista com um item em negrito, um link para `https://git-scm.com` e uma tarefa ainda não feita.

```markdown
___ Próximos estudos

_ ___GitHub Actions___, para automatizar testes
_ Rever o [manual do Git]________________________
_ ___ Ler o capítulo de rebase de novo
```

<details>
<summary>Ver resposta</summary>

```markdown
## Próximos estudos

- **GitHub Actions**, para automatizar testes
- Rever o [manual do Git](https://git-scm.com)
- [ ] Ler o capítulo de rebase de novo
```

`##` é o segundo nível, o certo para uma seção dentro do arquivo (o `#` fica para o título do documento). No link, o texto vai entre colchetes e o endereço, logo depois, entre parênteses, sem espaço no meio. Erros comuns: `[]` sem o espaço dentro da tarefa (o GitHub não reconhece `- []`) e `*negrito*`, que dá itálico.

</details>

**3. Sozinho.** A Ana quer publicar também o `receitas` como site, sem mexer no currículo. Responda: que tipo de site é esse, qual será o endereço e o que ela precisa fazer no GitHub? O que precisa existir na raiz do repositório?

<details>
<summary>Ver resposta</summary>

É um **site de projeto**, porque o repositório não se chama `ana-ribeiro.github.io`. O endereço será `https://ana-ribeiro.github.io/receitas`. No GitHub: **Settings → Pages**, **Deploy from a branch**, branch `main`, pasta **/ (root)**, **Save**. Na raiz precisa existir o arquivo de entrada, e o `receitas` já tem um `index.html` desde o capítulo 3. No plano gratuito, o repositório precisa ser público.

Erro comum: achar que é preciso renomear o repositório para `ana-ribeiro.github.io`. Esse nome é do site de usuário, e só existe um por conta; ele já é do currículo.

</details>

**4. Desafio.** O Diego vai participar de um processo seletivo. Ele tem uma conta gratuita no GitHub e planeja: (a) publicar o portfólio a partir de um repositório **privado**, para que ninguém veja o código; (b) mandar ao recrutador, por um gist **secreto**, um script de exemplo que contém o token de acesso à API da empresa onde ele trabalha hoje; (c) pôr no portfólio o telefone e o endereço completo. O que você diria a ele em cada item?

<details>
<summary>Ver resposta</summary>

- (a) No GitHub Free, o repositório de um site do Pages precisa ser público. E mesmo nos planos que aceitam repositório privado, o **site** continua público para qualquer pessoa. Um portfólio, de todo modo, existe para ser visto: deixe o código à mostra também.
- (b) Gist secreto não é privado: quem tiver o link, ou para quem o recrutador repassar, vê o token. Tire o token do script antes de qualquer envio (use uma variável de ambiente, lida de um `.env` que fica no `.gitignore`, capítulo 3) e avise a empresa para revogar um token que já tenha vazado.
- (c) Site público é lido por qualquer pessoa e por robôs que coletam dados. E-mail (ou o LinkedIn) basta; e, se o dado já foi commitado e enviado, apagar do arquivo não o tira do histórico.

Confira sua resposta: ela trata a visibilidade do site separada da do repositório, diz que “secreto” não protege segredos, propõe tirar o token do código e lembra que o histórico guarda o que foi apagado.

</details>

## 🧠 Revisão rápida

1. Num arquivo `.md`, como você faz dois parágrafos?
2. Que nome o repositório precisa ter para virar o site `https://<usuario>.github.io`?
3. Depois de um push, quanto tempo o site pode levar para mudar?
4. O botão **Sync Changes** do VS Code faz o quê?
5. Um gist secreto pode ser visto por quem?
6. (Capítulo 3) A Ana commitou e enviou o telefone dela no `index.html`. Apagar a linha num commit novo resolve?
7. (Capítulo 7) Antes de abrir um pull request, a Ana arrumou os commits da branch com `git rebase -i`. Por que ela pode fazer isso, mas não depois que outras pessoas baixaram a branch?
8. (Capítulo 9) Que botão de merge deixa um só commit por pull request na `main`?

<details>
<summary>Ver resposta</summary>

1. Com uma linha em branco entre eles.
2. `<usuario>.github.io`, com o seu usuário, em minúsculas.
3. Até 10 minutos.
4. `git pull` e depois `git push`.
5. Qualquer pessoa que tenha o link; ele só não aparece no perfil nem nas buscas.
6. Não: o telefone continua nos commits antigos, que estão no remoto. Some da página, mas fica no histórico.
7. Porque o rebase cria commits novos, com outros hashes; enquanto a branch só existe com ela, ninguém depende dos antigos (a regra de ouro).
8. **Squash and merge**.

</details>

## 🤖 Estude com um tutor de IA

```text
Vou colar o README de um projeto meu. Leia como alguém que nunca viu o
projeto e me diga, sem reescrever por mim: o que ficou sem resposta (o que
é, como ver ou usar, como contribuir), que passo parece desatualizado ou
vago, e que trecho do Markdown não vai aparecer como eu espero no GitHub.
```

```text
Faça 6 perguntas, uma de cada vez, sobre publicar um site com GitHub Pages
e compartilhar trechos com gists: nome do repositório, visibilidade,
tempo de publicação, arquivo de entrada, gist secreto × privado e Sync
Changes do VS Code. Espere a minha resposta antes de comentar e não me dê
a resposta antes de eu tentar.
```

> ➡️ **Próximo passo:** o livro termina aqui. Faça o simulado final para ver o que ficou firme e o que vale rever; depois, escolha um dos próximos caminhos abaixo.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| Markdown | Texto puro com `#`, `**`, `-` e `[]()`, que o GitHub mostra formatado. |
| Recursos do GitHub | Tabelas, listas de tarefas (`- [ ]`) e alertas (`> [!TIP]`). |
| README | Apresentação do repositório: o que é, como ver ou usar, como contribuir. |
| README do perfil | Repositório público com o nome do seu usuário e um `README.md`. |
| GitHub Pages | Publica os arquivos de um repositório como site estático em `github.io`. |
| Site de usuário | Repositório `<usuario>.github.io`, endereço `https://<usuario>.github.io`. |
| Publicar | **Settings → Pages → Deploy from a branch**; cada push atualiza em até 10 min. |
| VS Code | Painel Source Control: **+**, **Commit** e **Sync Changes** (pull + push). |
| Gist | Trecho com endereço próprio; é um repositório Git; secreto não é privado. |

## 📚 Fontes

- GitHub Docs (consultados em 21/11/2026): [What is GitHub Pages?](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages), [Creating a GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site), [Configuring a publishing source for your GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site), [Managing your profile README](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/customizing-your-profile/managing-your-profile-readme), [About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes), [Basic writing and formatting syntax](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax), [Creating gists](https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/creating-gists) e [Forking and cloning gists](https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/forking-and-cloning-gists)
- VS Code Docs (consultados em 21/11/2026): [Source Control](https://code.visualstudio.com/docs/sourcecontrol/overview), [Staging and committing](https://code.visualstudio.com/docs/sourcecontrol/staging-commits) e [Repositories and remotes](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)
- [git-config](https://git-scm.com/docs/git-config) (`alias.*`) — Git Reference Manual (Git 2.56, consultado em 21/11/2026)
- Anotações do curso “Git e GitHub Essencial para o Desenvolvedor” (Geek University, Udemy): as aulas do projeto do currículo (Pages e extensões do VS Code), de Markdown e de gists: estrutura e tópicos.

> 🔁 **Revise hoje:** capítulos 3 (`.gitignore` e dados sensíveis), 7 (regra de ouro do rebase) e 9 (pull request e botões de merge).

<!-- next-steps:start -->
## 🧭 Próximos caminhos

- **GitHub Actions (CI/CD)**: Fazer o GitHub testar e publicar o projeto sozinho a cada push e a cada pull request (workflows em YAML · testes automáticos em pull requests · deploy do GitHub Pages por Actions · segredos do repositório)
- **git bisect e git worktree**: Achar o commit que introduziu um bug e trabalhar em duas branches ao mesmo tempo sem stash (busca binária com git bisect · git bisect run com um teste · várias pastas de trabalho com git worktree)
- **Commits assinados (GPG/SSH)**: Provar que os seus commits e tags vieram mesmo de você, com o selo Verified no GitHub (assinatura com chave SSH · assinatura com GPG · git log --show-signature · exigir commits assinados na branch protegida)
- **Conventional Commits e versionamento semântico**: Padronizar as mensagens da equipe e numerar as versões de um jeito que diz o que mudou (tipos feat, fix e chore · MAJOR.MINOR.PATCH · changelog gerado do histórico · tags e releases por versão)
<!-- next-steps:end -->

<!-- nav:start -->
---

[◀ Capítulo anterior](09-colaborando-no-github.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](simulado-final.md)
<!-- nav:end -->
