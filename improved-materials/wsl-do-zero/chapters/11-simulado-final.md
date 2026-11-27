# 11. Simulado final

> 🗺️ **Neste capítulo:** 29 perguntas que cobrem todos os objetivos do livro, misturando capítulos e tipos de questão. Responda todas antes de abrir qualquer resposta, anote seus erros e use a tabela de diagnóstico do fim. · ⏱️ ~60 min

Deixe o terminal fechado na primeira passada: o objetivo é saber o que você já tem de cabeça. Depois, se quiser, confira no terminal as questões em que ficou em dúvida, mas só rodando comandos de leitura. Nada aqui pede `wsl --shutdown` nem `wsl --unregister`.

## Perguntas

**1.** Explique em duas frases a diferença entre o WSL 1 e o WSL 2.

<details>
<summary>Ver resposta</summary>

O WSL 1 traduz as chamadas do Linux para o Windows, sem kernel Linux de verdade e sem `systemd`. O WSL 2 roda um kernel Linux completo numa máquina virtual leve, com `systemd`, e é o padrão. Revise no [capítulo 1](01-o-que-e-o-wsl-e-quando-usar.md).

</details>

**2.** Verdadeiro ou falso: o `3.0.5` que o `wsl --version` mostra é a versão da arquitetura, ou seja, quer dizer que a distro roda no WSL 3. Justifique.

<details>
<summary>Ver resposta</summary>

Falso. O `3.0.5` é a versão do pacote do WSL (o programa que gerencia tudo). A arquitetura da distro, 1 ou 2, aparece na coluna `VERSION` do `wsl -l -v`, e as distros atuais rodam no WSL 2. Revise no [capítulo 1](01-o-que-e-o-wsl-e-quando-usar.md).

</details>

**3.** Qual a diferença entre uma máquina virtual e um dual boot, e onde o WSL se encaixa?

<details>
<summary>Ver resposta</summary>

Na VM, um sistema inteiro roda numa janela, dentro do outro. No dual boot, dois sistemas dividem o disco e só um roda por vez, com reinício para trocar. O WSL dá um Linux de verdade dentro do Windows, sem montar VM e sem reiniciar. Revise no [capítulo 1](01-o-que-e-o-wsl-e-quando-usar.md).

</details>

**4.** O `wsl --install` termina com o erro `0x80370102`. Qual é a causa mais provável e o que fazer?

<details>
<summary>Ver resposta</summary>

A virtualização está desligada no firmware (BIOS/UEFI), ou a Plataforma de Máquina Virtual do Windows não está ativa. Ligue a virtualização no firmware e rode o `verificar.ps1` para conferir. Revise no [capítulo 2](02-instalacao-do-wsl-e-do-ubuntu.md).

</details>

**5.** Escreva o comando que instala o Ubuntu 26.04 junto com o WSL e diga o que costuma ser preciso depois, na primeira vez.

<details>
<summary>Ver resposta</summary>

`wsl --install -d Ubuntu-26.04`, num PowerShell de administrador. Na primeira instalação o Windows pede reinício; na volta, o Ubuntu termina de se instalar e pede o usuário e a senha do Linux. Revise no [capítulo 2](02-instalacao-do-wsl-e-do-ubuntu.md).

</details>

**6.** O `wsl -l -v` mostra `VERSION 1` ao lado do seu Ubuntu. O que isso quer dizer e como converter?

<details>
<summary>Ver resposta</summary>

A distro está na arquitetura WSL 1, que não tem `systemd`. Converta com `wsl --set-version <distro> 2`. Revise no [capítulo 2](02-instalacao-do-wsl-e-do-ubuntu.md).

</details>

**7.** Qual a diferença entre `apt update` e `apt upgrade`? Qual dos dois deve vir primeiro?

<details>
<summary>Ver resposta</summary>

O `update` só renova a lista de pacotes disponíveis; o `upgrade` atualiza o que já está instalado. O `update` vem primeiro, porque o `upgrade` usa a lista que ele renovou. Os dois precisam de `sudo`. Revise no [capítulo 3](03-primeiros-passos-no-ubuntu.md).

</details>

**8.** Você trabalhou como `root` e criou um arquivo. Depois, o seu usuário comum não consegue editá-lo. Por quê, e o que se faz para evitar?

<details>
<summary>Ver resposta</summary>

O que o root cria pertence ao root. Para evitar, trabalhe com o seu usuário e use `sudo` só no comando que precisa de privilégio. Revise no [capítulo 3](03-primeiros-passos-no-ubuntu.md).

</details>

**9.** Que comando mostra se o `systemd` é o processo 1 da sua distro, e que linha do `/etc/wsl.conf` o liga?

<details>
<summary>Ver resposta</summary>

`ps -p 1 -o comm=` deve responder `systemd`. A configuração é `systemd=true` na seção `[boot]` do `/etc/wsl.conf`, e a distro precisa ser reiniciada (`wsl --terminate <distro>`, no PowerShell). Revise no [capítulo 3](03-primeiros-passos-no-ubuntu.md).

</details>

**10.** Como você abre, no Explorer do Windows, os arquivos do Linux, e como acessa o `C:` do Windows de dentro do Ubuntu?

<details>
<summary>Ver resposta</summary>

Do Windows, pelo caminho `\\wsl$\<distro>` (por exemplo, `\\wsl$\Ubuntu-26.04\home\ana`). Do Ubuntu, o `C:` fica em `/mnt/c`. O `explorer.exe .` abre a pasta atual do Linux no Explorer. Revise no [capítulo 4](04-arquivos-entre-linux-e-windows.md).

</details>

**11.** Seu projeto tem milhares de arquivos pequenos e está em `/mnt/c/projetos`. Por que o `git status` demora, e o que você faz?

<details>
<summary>Ver resposta</summary>

Os discos do Windows entram no Linux por uma ponte (o protocolo 9p) bem mais lenta que o ext4, e muitos arquivos pequenos custam dezenas de vezes mais lá. Na medição do livro, 2.000 arquivos levaram cerca de 0,14 s no `~` e 5,3 s em `/mnt/d`. Mova o projeto para o disco do Linux, por exemplo `~/projetos`. Revise no [capítulo 4](04-arquivos-entre-linux-e-windows.md).

</details>

**12.** Um `.sh` editado no Windows dá o erro `$'\r': command not found`. Qual a causa e que linha do `.gitattributes` evita o problema?

<details>
<summary>Ver resposta</summary>

O Windows grava as quebras de linha como CRLF (`\r\n`) e o bash lê o `\r` como parte do comando. A linha `*.sh text eol=lf` obriga os scripts de shell a ficarem com LF, em qualquer sistema. Revise no [capítulo 4](04-arquivos-entre-linux-e-windows.md).

</details>

**13.** Você quer mudar a cor do fundo e a fonte do terminal. O que você mexe no Windows e o que mexe no Ubuntu?

<details>
<summary>Ver resposta</summary>

Cores e fonte são do Windows Terminal: o esquema de cores e a fonte (uma Nerd Font, instalada no Windows) ficam no perfil. O prompt e o idioma são do Ubuntu. O teclado também vem do Windows. Revise no [capítulo 5](05-o-terminal-do-seu-jeito.md).

</details>

**14.** Como o Starship passa a gerar o seu prompt, e por que os dotfiles ficam no repositório com um link simbólico?

<details>
<summary>Ver resposta</summary>

Uma linha no `~/.bashrc`, `eval "$(starship init bash)"`, entrega o prompt ao Starship. Os arquivos de configuração ficam versionados no `meu-ambiente`, e um link simbólico os liga ao `~`: assim o Git guarda o histórico e uma instalação nova recupera tudo. Revise no [capítulo 5](05-o-terminal-do-seu-jeito.md).

</details>

**15.** Quando usar o `apt` e quando usar o nvm, o SDKMAN ou o uv?

<details>
<summary>Ver resposta</summary>

O `apt` instala programas do sistema. Para as linguagens, os gerenciadores de versão deixam você ter várias versões, na sua pasta pessoal e sem `sudo`: nvm para o Node.js, SDKMAN para o Java e o uv para o Python. Revise no [capítulo 6](06-ferramentas-de-desenvolvimento-e-programas.md).

</details>

**16.** `which -a npm` mostra o `npm` do Windows antes do `npm` do nvm. Qual roda, e por quê?

<details>
<summary>Ver resposta</summary>

O do Windows, o primeiro da lista. O shell percorre o `PATH` na ordem e usa o primeiro programa que achar. Para o do nvm vencer, a pasta dele precisa vir antes no `PATH`. Revise no [capítulo 6](06-ferramentas-de-desenvolvimento-e-programas.md).

</details>

**17.** O que significa dizer que o `bootstrap.sh` é idempotente, e por que isso importa?

<details>
<summary>Ver resposta</summary>

Rodá-lo duas vezes dá o mesmo resultado: cada bloco confere se o trabalho já está feito antes de repetir. Isso permite rodar o script do zero numa distro nova e de novo em uma que já está pronta, sem estragar nada. Revise no [capítulo 6](06-ferramentas-de-desenvolvimento-e-programas.md).

</details>

**18.** Você quer limitar a memória do WSL a 8 GB para todas as distros. Em que arquivo e em que seção você escreve?

<details>
<summary>Ver resposta</summary>

No `.wslconfig`, na sua pasta de usuário do Windows (`%UserProfile%`), na seção `[wsl2]`: `memory=8GB`. O arquivo vale para todas as distros; o `wsl.conf` de dentro de cada distro cuida só dela. Revise no [capítulo 7](07-gerenciar-o-wsl.md).

</details>

**19.** Você mudou o `wsl.conf` da sua distro. Basta `wsl --shutdown`? Compare com o `wsl --terminate`.

<details>
<summary>Ver resposta</summary>

Basta o `wsl --terminate <distro>`, que para só aquela distro (o apartamento). O `wsl --shutdown` derruba **todas** as distros e a máquina virtual (o prédio), e só é necessário para o `.wslconfig`. Se outras distros têm projetos rodando, evite o `--shutdown`. Revise no [capítulo 7](07-gerenciar-o-wsl.md).

</details>

**20.** O que muda no Ubuntu com `appendWindowsPath=false` no `wsl.conf`?

<details>
<summary>Ver resposta</summary>

O `PATH` do Windows deixa de ser acrescentado ao do Ubuntu. No experimento do livro, o `PATH` foi de 51 entradas (42 do Windows) para 9, e programas do Windows como o `cmd.exe` e o `explorer.exe` deixaram de ser achados. Revise no [capítulo 7](07-gerenciar-o-wsl.md).

</details>

**21.** Na ordem certa, o que você faz para exportar a distro `Ubuntu-26.04` para um arquivo?

<details>
<summary>Ver resposta</summary>

Pare a distro com `wsl --terminate Ubuntu-26.04` e rode `wsl --export Ubuntu-26.04 <pasta>\ubuntu.tar`. Depois, guarde o SHA-256 do arquivo para conferir a cópia. Revise no [capítulo 8](08-backup-e-restauracao.md).

</details>

**22.** Você restaurou o backup com `wsl --import` e a distro abre como `root`. Como faz para abrir com o seu usuário?

<details>
<summary>Ver resposta</summary>

Uma distro importada não tem o lançador que a loja instala, então abre como root. No `/etc/wsl.conf`, escreva `[user]` e `default=<usuário>` (o usuário precisa existir na distro), e rode `wsl --terminate`. Sem o usuário, aparece o erro `getpwnam failed` e a distro abre como root do mesmo jeito. Revise no [capítulo 8](08-backup-e-restauracao.md).

</details>

**23.** Para provar o backup, por que restaurar num clone `teste-...`, e como você descarta o clone sem risco?

<details>
<summary>Ver resposta</summary>

O clone usa o mesmo `.tar` com outro nome, então prova que o backup restaura sem tocar na distro de verdade. Para descartar, use o `wsl --unregister` **só com o nome exato do clone** (`teste-...`): ele apaga a distro e o disco dela. Confira o nome com `wsl -l -v` antes. Revise no [capítulo 8](08-backup-e-restauracao.md).

</details>

**24.** Como instalar o Claude Code no WSL, e por que não usar `sudo`?

<details>
<summary>Ver resposta</summary>

Com o instalador oficial, como o seu usuário: ele instala em `~/.local` e confere o SHA-256. Antes de rodar um `curl | bash`, leia o script. O `sudo` é desnecessário e o instalador recusa; com root, o Claude Code ficaria na pasta do root, com permissão sobre o sistema inteiro. O `claude doctor` confere a instalação sem abrir sessão. Revise no [capítulo 9](09-claude-code-no-wsl.md).

</details>

**25.** O que muda entre os modos `default`, `acceptEdits` e `plan`? Como alternar?

<details>
<summary>Ver resposta</summary>

No `default`, o Claude pergunta antes de agir. No `acceptEdits`, ele edita arquivos sem perguntar. No `plan`, ele lê e propõe um plano, sem editar. O Shift+Tab alterna entre os modos, e `permissions.defaultMode` no `settings.json` fixa o inicial. Revise no [capítulo 9](09-claude-code-no-wsl.md).

</details>

**26.** Antes de ligar um plugin ou um MCP, o que você confere? E o que explicou a falha do MCP do Docling no livro?

<details>
<summary>Ver resposta</summary>

Leia o que ele traz: um plugin pode ter hooks (comandos que rodam sozinhos) e MCPs. Um MCP é um programa à parte, com ferramentas próprias. O Docling falhou porque o `uvx`, do `uv`, não estava instalado na distro de teste, e o motivo apareceu no campo `Issue`. Revise no [capítulo 9](09-claude-code-no-wsl.md).

</details>

**27.** Na ordem do Spec Kit, que perguntas cada passo responde: `specify`, `plan`, `tasks` e `implement`?

<details>
<summary>Ver resposta</summary>

A spec diz o quê e por quê, sem tecnologia. O plan diz como: linguagem, bibliotecas e estrutura. As tarefas quebram o plan em fases, na ordem. O implement escreve o código, uma fase por vez, com `uv run pytest` e um commit ao fim de cada uma. Revise no [capítulo 10](10-projeto-final-um-app-com-spec-kit.md).

</details>

**28.** Você rodou `specify init` e logo depois o `git status`. O que aparece, e por quê?

<details>
<summary>Ver resposta</summary>

`not a git repository`. O `specify init` cria o `.specify/` e os comandos em `.claude/skills/`, mas não cria o repositório: você faz o `git init`. Os comandos têm hífen: `/speckit-specify`, e não `/speckit.specify`. Revise no [capítulo 10](10-projeto-final-um-app-com-spec-kit.md).

</details>

**29.** Seu PC foi formatado. Descreva, em ordem, como você restaura o ambiente completo e como prova que deu certo.

<details>
<summary>Ver resposta</summary>

Instale o WSL e importe a distro do backup (ou instale uma distro nova), crie o usuário, faça o `git clone` do `meu-ambiente`, rode o `bootstrap.sh` e depois o `verificar.sh`. Se o verificador acusar uma lacuna, o `bootstrap.sh` ganha o passo que faltava, como aconteceu com o Claude Code no capítulo 10. O ambiente está provado quando todos os testes passam. Revise no [capítulo 10](10-projeto-final-um-app-com-spec-kit.md).

</details>

## Diagnóstico

| Se você errou... | Revise |
| --- | --- |
| as perguntas 1, 2 e 3 | [capítulo 1](01-o-que-e-o-wsl-e-quando-usar.md) |
| as perguntas 4, 5 e 6 | [capítulo 2](02-instalacao-do-wsl-e-do-ubuntu.md) |
| as perguntas 7, 8 e 9 | [capítulo 3](03-primeiros-passos-no-ubuntu.md) |
| as perguntas 10, 11 e 12 | [capítulo 4](04-arquivos-entre-linux-e-windows.md) |
| as perguntas 13 e 14 | [capítulo 5](05-o-terminal-do-seu-jeito.md) |
| as perguntas 15, 16 e 17 | [capítulo 6](06-ferramentas-de-desenvolvimento-e-programas.md) |
| as perguntas 18, 19 e 20 | [capítulo 7](07-gerenciar-o-wsl.md) |
| as perguntas 21, 22 e 23 | [capítulo 8](08-backup-e-restauracao.md) |
| as perguntas 24, 25 e 26 | [capítulo 9](09-claude-code-no-wsl.md) |
| as perguntas 27, 28 e 29 | [capítulo 10](10-projeto-final-um-app-com-spec-kit.md) |

Acertou 23 ou mais? Você domina o que o livro propôs. Entre 16 e 22, revise os capítulos da tabela e refaça só as perguntas que errou daqui a três dias. Menos de 16, refaça o *Pratique* dos capítulos indicados antes de tentar de novo.

> ➡️ **Próximo passo:** o [Glossário](glossario.md) reúne os termos do livro, e a seção *Próximos caminhos*, no fim do capítulo 10, sugere o que estudar a seguir.

<!-- nav:start -->
---

[◀ Capítulo anterior](10-projeto-final-um-app-com-spec-kit.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](glossario.md)
<!-- nav:end -->
