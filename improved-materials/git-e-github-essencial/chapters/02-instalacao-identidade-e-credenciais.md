# 2. Instalação, identidade e credenciais

> 🗺️ **Neste capítulo:** instalar o Git, dizer a ele quem você é e preparar o acesso ao GitHub sem senha, com Git Credential Manager ou SSH. · ⏱️ ~45 min

> 🔥 **Aquecimento:** você está sem internet. Dá para registrar um commit com o Git? E para enviá-lo ao GitHub?
>
> <details>
> <summary>Ver resposta</summary>
>
> Registrar, sim: o commit é do Git e fica no seu computador. Enviar, não: o GitHub é um serviço na internet (capítulo 1).
>
> </details>

## De onde paramos

No capítulo 1 você leu o histórico de um cardápio e viu que cada commit guarda autor, data e mensagem. Agora vai instalar o Git e configurar justamente o **autor**: o nome e o e-mail que vão em cada commit seu. No fim, prepara o acesso ao GitHub, que vai ser usado a partir do capítulo 8.

## Instalar no Windows, macOS e Linux

Os comandos deste livro foram testados no Git 2.56. Qualquer versão a partir da 2.23 roda todos eles; versões mais antigas não têm os comandos `git switch` e `git restore`, que aparecem a partir do capítulo 5.

| Sistema | Como instalar |
| --- | --- |
| Windows | Baixe o instalador em [git-scm.com/install/windows](https://git-scm.com/install/windows) e avance com as opções padrão. Ele instala o **Git Bash** (um terminal com os comandos do Linux) e o **Git Credential Manager**, que você vai usar no fim do capítulo. |
| macOS | Com o [Homebrew](https://brew.sh): `brew install git`. Sem ele, rode `git --version` no Terminal e o sistema oferece instalar as ferramentas de linha de comando da Apple, que trazem o Git. |
| Linux (Debian, Ubuntu) | `sudo apt-get install git` (em outras distribuições, use o gerenciador de pacotes dela). |

No Windows, use o **Git Bash** para seguir o livro: os comandos de terminal dos laboratórios (`ls`, `cat`, `mkdir`) são os mesmos do macOS e do Linux.

Abra o terminal e confira:

```bash
git --version
```

```text
git version 2.56.0.windows.2
```

O número da sua versão pode ser outro. Se aparecer `command not found` (ou “não é reconhecido como um comando”), feche e abra o terminal de novo; se continuar, a instalação não terminou.

## git config: system, global e local

O Git guarda as preferências em arquivos de configuração, e o comando que lê e grava esses arquivos é o `git config`. Antes de configurar qualquer coisa, entenda **onde** cada configuração fica, porque isso decide para quais projetos ela vale.

**O Git tem três níveis de configuração, e quando o mesmo item aparece em mais de um, vale o mais próximo do repositório.**

| Nível | Opção | Arquivo | Vale para |
| --- | --- | --- | --- |
| system | `--system` | `etc/gitconfig`, na pasta de instalação do Git | todos os usuários do computador |
| global | `--global` | `.gitconfig`, na sua pasta de usuário | todos os seus repositórios |
| local | nenhuma (é o padrão) | `.git/config`, dentro do repositório | só aquele repositório |

![Três camadas de configuração: local no topo (só este repositório), global no meio (todos os seus repositórios) e system na base (todos os usuários); o Git lê de baixo para cima e o último valor lido vence](../img/c02-niveis-de-config.svg)

Você vai usar o `--global` quase sempre e o local quando um projeto precisar de algo diferente. O `--system` fica para quem administra o computador.

### Sua identidade

O primeiro item a configurar é a identidade. **A identidade do autor é o par nome e e-mail que o Git grava dentro de cada commit.** Sem ela, o Git se recusa a commitar.

Preveja: num Git recém-instalado, o que `git config --global user.name` mostra?

```bash
git config --global user.name
echo $?
```

```text
1
```

Não mostra nada. O `echo $?` exibe o código de saída do comando anterior: `1` quer dizer que o item não existe. Configure os dois valores (com o seu nome e o seu e-mail):

```bash
git config --global user.name "Ana Ribeiro"
git config --global user.email "ana.ribeiro@example.com"
```

Escolha um **e-mail cadastrado na sua conta do GitHub**: o site usa esse endereço para saber que o commit é seu; um commit com um e-mail que não está cadastrado na sua conta não fica ligado ao seu perfil e não entra no seu gráfico de contribuições.

> 💡 Se você não quer o seu e-mail visível nos commits públicos, o GitHub oferece um endereço que só serve para isso, no formato `ID+usuario@users.noreply.github.com`. Ele aparece em **Settings → Emails** na sua conta.

### Duas configurações úteis

```bash
# repositórios novos começam com a branch "main", o nome que o GitHub usa
git config --global init.defaultBranch main
```

A *branch* principal é a linha de trabalho que o repositório tem ao nascer (o capítulo 6 explica branches). Desde outubro de 2020, o GitHub chama essa branch de `main` em repositórios novos; alinhar o nome evita confusão quando você conectar os dois.

```bash
# o VS Code vira o editor das mensagens de commit; --wait faz o Git esperar
git config --global core.editor "code --wait"
```

Quando você roda `git commit` sem mensagem, o Git abre esse editor para você escrever. O `--wait` é essencial: sem ele, o comando `code` abre o VS Code e termina na hora, o Git encontra a mensagem vazia e cancela. Simulando um editor que fecha na hora (o comando `true`), o resultado é este:

```bash
git -c core.editor=true commit
```

```text
Aborting commit due to empty commit message.
```

Se você não usa o VS Code, troque por `"notepad"` (Windows), `"nano"` ou `"vim"`.

### Conferir o que está valendo

```bash
git config --global --list
```

```text
user.name=Ana Ribeiro
user.email=ana.ribeiro@example.com
init.defaultbranch=main
```

O Git mostra os nomes dos itens em minúsculas (`init.defaultbranch`), mas aceita qualquer combinação de maiúsculas ao gravar. O arquivo por trás disso é texto puro, e você pode abri-lo no editor:

```text
[user]
	name = Ana Ribeiro
	email = ana.ribeiro@example.com
[init]
	defaultBranch = main
```

### Uma identidade só para um projeto

A Ana é voluntária numa horta comunitária e quer que os commits do site da horta saiam com o e-mail da horta, sem mudar os outros projetos. Dentro do repositório (`git init` cria um; o capítulo 3 detalha), ela grava o e-mail **sem** `--global`:

```bash
mkdir horta-comunitaria
cd horta-comunitaria
git init
# sem --global: grava no .git/config, só para a horta
git config user.email "ana@hortacomunitaria.example"
```

```text
Initialized empty Git repository in C:/Users/ana/horta-comunitaria/.git/
```

Preveja: agora existem dois e-mails configurados. Qual deles vale dentro da pasta `horta-comunitaria`?

```bash
git config --show-origin user.email
```

```text
file:.git/config	ana@hortacomunitaria.example
```

Vale o local. O `--show-origin` mostra de qual arquivo veio o valor, o que resolve a dúvida “de onde o Git tirou isso?”. Para ver todos os valores e a ordem em que o Git os leu:

```bash
git config --show-origin --get-all user.email
```

```text
file:C:/Users/ana/.gitconfig	ana.ribeiro@example.com
file:.git/config	ana@hortacomunitaria.example
```

O global foi lido primeiro, o local depois, e o último vence. (O caminho do `.gitconfig` muda conforme o seu usuário e o seu sistema.) Para voltar a usar o e-mail global nesse projeto, apague o local:

```bash
git config --unset user.email
git config --show-origin user.email
```

```text
file:C:/Users/ana/.gitconfig	ana.ribeiro@example.com
```

> ⚠️ **Erro comum:** rodar `git config user.email ...` fora de um repositório achando que configurou tudo. Sem `--global`, o comando grava no repositório da pasta atual; fora de um repositório, o Git responde `fatal: not in a git directory` e não grava nada. Na dúvida, confira com `--show-origin`.

## Identidade × credenciais

Configurar `user.name` não faz login em lugar nenhum. Qualquer pessoa pode escrever o seu nome no próprio Git, e o Git aceita sem conferir. O que impede alguém de enviar commits para o **seu** repositório no GitHub é outra coisa: a credencial.

**Credencial é a prova que você apresenta ao servidor para mostrar que tem permissão de acesso**, por exemplo para enviar commits (`git push`) ou baixar um repositório privado.

![Comparação: a identidade (user.name e user.email) vai dentro de cada commit e ninguém confere; a credencial (token, login no navegador ou chave SSH) é apresentada ao servidor, que recusa se for inválida](../img/c02-identidade-credenciais.svg)

| | Identidade | Credencial |
| --- | --- | --- |
| O que é | nome e e-mail | token, login pelo navegador ou chave SSH |
| Onde fica | dentro de cada commit | guardada no seu computador, apresentada ao servidor |
| Quem confere | ninguém | o servidor, que recusa se for inválida |
| Quando você precisa | para commitar | para enviar e baixar repositórios privados |

Desde 13 de agosto de 2021, o GitHub **não aceita a senha da conta** para operações Git. Sobram três caminhos, e você vai escolher um deles nas próximas seções:

- **Git Credential Manager:** faz o login pelo navegador e guarda a credencial no cofre do sistema. É o mais simples.
- **SSH:** um par de chaves; a pública fica cadastrada no GitHub.
- **Token de acesso pessoal** (*personal access token*, PAT): uma senha longa gerada no GitHub, digitada no lugar da senha da conta. Com o Credential Manager, você não precisa criar um: o login pelo navegador faz esse papel.

> ⚠️ **Erro comum:** colocar o token dentro do endereço do repositório, como `https://ana:TOKEN@github.com/...`, receita que aparece em tutoriais antigos. O endereço fica gravado em texto puro no `.git/config`, e qualquer programa ou pessoa com acesso à pasta lê o token.

## Git Credential Manager e SSH

### Git Credential Manager

O Git não guarda credenciais sozinho: ele delega isso a um **credential helper** (ajudante de credenciais), escolhido pela configuração `credential.helper`. O **Git Credential Manager** (GCM) é um desses ajudantes. Ele vem com o Git para Windows e também roda no macOS e no Linux (nesses dois, instale à parte pelo [repositório do projeto](https://github.com/git-ecosystem/git-credential-manager)).

No Windows, confira se ele já está ativo:

```bash
git config --show-origin --get credential.helper
```

```text
file:C:/Program Files/Git/etc/gitconfig	manager
```

O valor `manager` é o GCM, configurado pelo instalador no nível **system**. Não há mais nada a fazer: no primeiro `git push` para o GitHub (capítulo 8), ele abre o navegador, você entra na sua conta, autoriza, e a credencial vai para o cofre do Windows. Depois disso, o Git não pergunta mais.

Os outros ajudantes que você vai encontrar por aí:

| Ajudante | Onde guarda | Quando usar |
| --- | --- | --- |
| `manager` | cofre do sistema operacional | o recomendado |
| `osxkeychain` | Chaveiro do macOS | macOS sem o GCM |
| `cache` | memória, por 900 segundos (15 min) por padrão | Linux e macOS, quando você não quer nada gravado no disco |
| `store` | arquivo `~/.git-credentials`, **em texto puro** | evite: quem lê o arquivo lê o token |

### SSH

Com SSH, a autenticação usa um **par de chaves**: uma **privada**, que fica só no seu computador, e uma **pública**, que você cadastra no GitHub. A cada conexão, o GitHub manda um desafio, o seu computador responde assinando com a chave privada, e o GitHub confere a assinatura com a chave pública.

![Sequência SSH entre seu computador e o GitHub: cadastro da chave pública uma vez; pedido de conexão; desafio; resposta assinada com a chave privada; acesso liberado](../img/c02-ssh.svg)

> 💡 **Analogia:** pense no cartão de assinatura que o banco guarda quando você abre uma conta. O cartão no banco é a **chave pública**: serve para conferir, não para assinar. A sua mão é a **chave privada**: só ela produz a assinatura. O cheque é a **resposta ao desafio**, conferida contra o cartão. A analogia quebra num ponto importante: uma assinatura no papel pode ser copiada por quem a vê, e a assinatura digital, não, porque muda a cada desafio e não revela a chave privada.

**1. Gerar o par de chaves** (troque pelo seu e-mail):

```bash
ssh-keygen -t ed25519 -C "ana.ribeiro@example.com"
```

O comando pergunta onde salvar (tecle Enter para aceitar o padrão) e pede duas vezes uma **frase-senha** (*passphrase*), que protege a chave privada caso alguém copie o arquivo. No Git Bash, a saída é parecida com esta:

```text
Generating public/private ed25519 key pair.
Enter file in which to save the key (/c/Users/ana/.ssh/id_ed25519):
Created directory '/c/Users/ana/.ssh'.
Your identification has been saved in /c/Users/ana/.ssh/id_ed25519
Your public key has been saved in /c/Users/ana/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:S/34Q2WiMYSNEI4CHbznNIxfyYRUQFGt9Jw9YHlbCVg ana.ribeiro@example.com
```

A linha `Created directory` só aparece se a pasta `.ssh` ainda não existia. Os dois arquivos criados são a chave privada (`id_ed25519`, sem extensão) e a pública (`id_ed25519.pub`). A impressão digital (*fingerprint*) é diferente a cada chave gerada.

**2. Cadastrar a chave pública no GitHub.** Mostre o conteúdo do arquivo `.pub`:

```bash
cat ~/.ssh/id_ed25519.pub
```

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHuo... ana.ribeiro@example.com
```

Copie a linha inteira e cole em **Settings → SSH and GPG keys → New SSH key**, na sua conta do GitHub.

**3. Testar a conexão:**

```bash
ssh -T git@github.com
```

Na primeira vez, o SSH pergunta se você confia no servidor; responda `yes`. A resposta esperada, segundo a documentação do GitHub, é:

```text
Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```

com o seu usuário no lugar de `USERNAME`. A frase “does not provide shell access” é normal: o GitHub aceita a chave para operações Git, mas não abre um terminal no servidor.

> ⚠️ **Erro comum:** cadastrar no GitHub o arquivo **sem** `.pub`. Essa é a chave privada, e ela nunca deve sair do seu computador. Se isso aconteceu, apague a chave no GitHub, gere um par novo e cadastre o `.pub`.

### Qual escolher?

| Situação | Escolha |
| --- | --- |
| Windows ou macOS, primeiro contato com o GitHub | Git Credential Manager: já vem pronto (no Windows) e o login é pelo navegador |
| Linux, ou vários computadores e servidores | SSH: uma chave por máquina, sem token para renovar |
| Rede que bloqueia a porta do SSH | Git Credential Manager (usa HTTPS) |

As duas formas são seguras. Escolha uma agora; a outra pode ficar para depois.

## 🧪 Laboratório: deixe o seu Git pronto

1. Rode `git --version` e anote a versão.
2. Configure `user.name`, `user.email` (o da sua conta do GitHub) e `init.defaultBranch` com `--global`.
3. Configure o `core.editor` com o editor que você usa.
4. Rode `git config --global --list` e confira os quatro itens.
5. No Windows, rode `git config --show-origin --get credential.helper` e confira se aparece `manager`.
6. Se escolheu SSH: gere a chave, cadastre a pública no GitHub e teste com `ssh -T git@github.com`.

Pronto quando: o passo 4 mostra os seus dados e o passo 5 (ou o 6) dá o resultado esperado.

## 🏋️ Pratique

**1. Exemplo resolvido.** O Bruno trabalha numa empresa e mantém projetos pessoais no mesmo computador. Ele quer o e-mail pessoal em tudo, exceto no repositório `portal-rh`, que deve usar `bruno@empresa.example`. Que comandos ele roda?

```bash
# vale para todos os repositórios dele
git config --global user.email "bruno.pessoal@example.com"
# só dentro do portal-rh: o local vence o global
cd portal-rh
git config user.email "bruno@empresa.example"
git config --show-origin user.email
```

```text
file:.git/config	bruno@empresa.example
```

O global define o padrão; o local, sem opção, sobrepõe só naquele repositório. O `--show-origin` confirma que o valor veio do `.git/config`.

**2. Complete.** A Carla quer ver todos os e-mails configurados e de que arquivo cada um vem. Complete o comando:

```bash
git config ______________ --get-all user.email
```

<details>
<summary>Ver resposta</summary>

```bash
git config --show-origin --get-all user.email
```

O `--get-all` lista todos os valores (de todos os níveis) e o `--show-origin` acrescenta o arquivo de cada um. Sem o `--get-all`, aparece só o valor que está valendo.

</details>

**3. Sozinho.** O Diego rodou estes comandos e depois fez um commit dentro do repositório `jogo`. Com que e-mail o commit saiu? E com que nome?

```bash
git config --global user.name "Diego"
git config --global user.email "diego@casa.example"
# já dentro do repositório jogo
cd jogo
git config user.email "diego@estudio.example"
```

<details>
<summary>Ver resposta</summary>

E-mail `diego@estudio.example` (o local vence o global) e nome `Diego` (não há nome local, então vale o global). Um erro comum é achar que a configuração local substitui o bloco inteiro de identidade: cada item é decidido separadamente.

</details>

**4. Desafio.** Um colega mostra o `.git/config` de um projeto com esta linha e pergunta se está tudo certo:

```text
url = https://lucas:ghp_8fK2xQ...@github.com/lucas/loja.git
```

Explique o problema e diga o que ele deve fazer, em três passos.

<details>
<summary>Ver resposta</summary>

O token (`ghp_...`) está em texto puro no endereço do repositório: qualquer pessoa ou programa com acesso à pasta pode lê-lo e usá-lo para agir em nome do Lucas.

1. Revogar o token no GitHub (**Settings → Developer settings → Personal access tokens**), porque ele pode já ter vazado.
2. Trocar o endereço por um sem credencial: `git remote set-url origin https://github.com/lucas/loja.git` (o comando `git remote` é do capítulo 8).
3. Usar o Git Credential Manager ou SSH para autenticar.

Confira sua resposta: ela explica **por que** é perigoso (texto puro, qualquer um lê), manda revogar (não só apagar a linha) e indica um jeito seguro de autenticar.

</details>

## 🧠 Revisão rápida

1. Em que arquivo fica uma configuração feita sem `--global`?
2. Por que configurar `user.name` não prova quem você é para o GitHub?
3. Qual ajudante de credenciais grava o token em texto puro?
4. Das duas chaves SSH, qual vai para o GitHub?
5. (Capítulo 1) Em qual modelo de controle de versão o histórico fica em cada cópia?

<details>
<summary>Ver resposta</summary>

1. No `.git/config` do repositório.
2. Porque o Git aceita qualquer nome sem conferir; quem prova o acesso é a credencial.
3. O `store`, no arquivo `~/.git-credentials`.
4. A pública, o arquivo `.pub`.
5. No distribuído.

</details>

## 🤖 Estude com um tutor de IA

```text
Faça 5 perguntas sobre os níveis de configuração do Git (system, global e
local) e sobre identidade × credenciais, uma de cada vez. Espere minha
resposta antes de comentar e não me dê as respostas antes.
```

```text
Esta é minha resposta ao exercício 4 do capítulo sobre credenciais do Git:
<sua resposta>. Aponte meus erros sem me dar a solução.
```

> ➡️ **Próximo passo:** com o Git configurado, o capítulo 3 cria o primeiro repositório de verdade e mostra como o Git enxerga os seus arquivos: as três áreas e os estados por onde cada arquivo passa.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| `git config` | Lê e grava as configurações do Git. |
| Níveis | system (computador), global (seu usuário) e local (repositório); o mais próximo do repositório vence. |
| `--show-origin` | Mostra de qual arquivo veio cada valor. |
| Identidade | Nome e e-mail gravados em cada commit; ninguém confere. |
| Credencial | Prova de acesso que o servidor confere; o GitHub não aceita a senha da conta desde 13/08/2021. |
| Git Credential Manager | Ajudante que faz login pelo navegador e guarda a credencial no cofre do sistema. |
| SSH | Par de chaves: a privada fica no computador, a pública vai para o GitHub. |

## 📚 Fontes

- [Instalação do Git: Windows, macOS e Linux](https://git-scm.com/install/windows) (consultado em 21/11/2026)
- [git-config — Git Reference Manual](https://git-scm.com/docs/git-config) e [git-credential-cache](https://git-scm.com/docs/git-credential-cache) (Git 2.56, consultados em 21/11/2026)
- [Token authentication requirements for Git operations — GitHub Blog](https://github.blog/security/application-security/token-authentication-requirements-for-git-operations/) (consultado em 21/11/2026)
- [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager) (consultado em 21/11/2026)
- [Gerar uma chave SSH](https://docs.github.com/pt/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) e [Testar a conexão SSH](https://docs.github.com/pt/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection) — GitHub Docs (consultados em 21/11/2026)
- [Definir o endereço de e-mail do commit — GitHub Docs](https://docs.github.com/pt/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address) (consultado em 21/11/2026)
- Anotações do curso “Git e GitHub Essencial para o Desenvolvedor” (Geek University, Udemy), aulas 1.4 e 1.5: estrutura e tópicos.

<!-- nav:start -->
---

[◀ Capítulo anterior](01-por-que-controlar-versoes.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](03-como-o-git-pensa.md)
<!-- nav:end -->
