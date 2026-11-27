# 4. Arquivos entre Linux e Windows

> 🗺️ **Neste capítulo:** você entende que o WSL tem dois sistemas de arquivos, aprende os caminhos para atravessar de um lado ao outro (`/mnt/c`, `\\wsl$`, `wslpath`, `explorer.exe`), mede por que o projeto deve morar no Linux e fixa o fim de linha do `meu-ambiente` com o `.gitattributes`. · ⏱️ ~45 min

> 🔥 **Aquecimento:** (1) No WSL 2, o Linux roda sobre o quê? (2) Por que o `sudo` pede a *sua* senha, e não a do root?
>
> <details>
> <summary>Ver resposta</summary>
>
> (1) Sobre um kernel Linux de verdade, dentro de uma máquina virtual leve que o Windows gerencia (capítulo 1). (2) Porque o `sudo` confere que é você quem está pedindo o poder emprestado; o root, em geral, nem tem senha (capítulo 3).
>
> </details>

## 📇 A parte 2 numa página

![Parte 2, capítulos 4 a 6. Dois sistemas de arquivos: ext4 no disco do Linux, discos do Windows em /mnt/c, \\wsl$ mostra o Linux no Windows. Converter e abrir: wslpath -w e wslpath -u, explorer.exe . abre a pasta. Desempenho: muitos arquivos em /mnt custam caro, 2.000 arquivos: 0,1 s × 5,3 s, o projeto mora no Linux. CRLF × LF: Windows grava \r\n, bash tropeça no \r, .gitattributes fixa o fim. Quatro camadas: janela, cores e fonte: Windows, prompt e idioma: Ubuntu, teclado vem do Windows. Starship e Nerd Font: Nerd Font traz os ícones, Starship: uma linha no .bashrc, dotfiles com link simbólico. Locale: language-pack-pt, update-locale, cada camada se desfaz. PATH: lista de pastas, o primeiro programa achado vale, which -a mostra todos. Versões das linguagens: apt para o sistema, nvm, SDKMAN e uv, tudo na pasta pessoal. WSLg e bootstrap: WSLg: janelas Linux no Windows, DISPLAY aponta o caminho, bootstrap.sh é idempotente.](../img/c04-resumo-parte-2.svg)

- [Capítulo 4: Arquivos entre Linux e Windows](04-arquivos-entre-linux-e-windows.md)
- [Capítulo 5: O terminal do seu jeito](05-o-terminal-do-seu-jeito.md)
- [Capítulo 6: Ferramentas de desenvolvimento e programas com janela](06-ferramentas-de-desenvolvimento-e-programas.md)

## De onde paramos

No capítulo 3 você criou o repositório `~/meu-ambiente` dentro da sua pasta pessoal do Linux e viu o `verificar.sh` passar com 7 testes. Ali dentro tudo foi natural. Só que o seu dia a dia mistura os dois mundos: você vai querer abrir uma pasta do Linux no Explorer, ler um arquivo da sua área de trabalho do Windows e usar o VS Code do Windows num projeto do Linux. Este capítulo ensina a fazer isso sem se queimar.

## Dois sistemas de arquivos

Um computador com WSL 2 guarda arquivos em dois lugares bem diferentes. O **disco do Linux** é um arquivo gigante do Windows (um disco virtual) formatado com o sistema de arquivos **ext4**, o mesmo da maioria dos Linux. Os **discos do Windows** (`C:\`, `D:\`) continuam sendo NTFS e são só emprestados ao Linux.

Veja os dois lado a lado, no Ubuntu:

```bash
# o tamanho e o ponto de montagem de cada disco, sem os detalhes
df -h / /mnt/c /mnt/d | awk '{print $1, $2, $6}'
# o tipo de sistema de arquivos de cada montagem
mount | grep -E ' / | /mnt/(c|d) ' | sed 's/(.*//'
```

Saída:

```text
Filesystem Size Mounted
/dev/sdg 1007G /
C:\ 238G /mnt/c
D:\ 895G /mnt/d
/dev/sdg on / type ext4
C:\ on /mnt/c type 9p
D:\ on /mnt/d type 9p
```

O `/` é um disco do Linux (`ext4`, com 1007 GB de espaço máximo, que é o limite do disco virtual, não espaço ocupado). Já `/mnt/c` e `/mnt/d` são o `C:\` e o `D:\` do Windows, ligados por um protocolo chamado **9p**. Guarde esse nome: ele explica o resto do capítulo.

![Árvore do Ubuntu: /home/ana é o disco do Linux, e /mnt/c e /mnt/d são os discos do Windows](../img/c04-dois-sistemas.svg)

Cada lado tem as próprias regras:

| | Disco do Linux (`/`, `~`) | Discos do Windows (`/mnt/c`, `/mnt/d`) |
| --- | --- | --- |
| Formato | ext4 | NTFS, visto pelo Linux via 9p |
| Maiúsculas e minúsculas | `A.txt` e `a.txt` são arquivos diferentes | no teste, criar `a.txt` depois de `A.txt` só deu um arquivo |
| Permissões | donos e permissões do Linux (`rw-r--r--`) | o Linux inventa `rwxrwxrwx` para tudo |
| Velocidade com muitos arquivos pequenos | alta | baixa (veja a seção "Desempenho") |
| Quem enxerga | o Linux; o Windows por `\\wsl$` | o Windows direto; o Linux por `/mnt` |

> ⚠️ **Erro comum:** deixar o projeto em `/mnt/c/Users/...` "porque assim o Windows também vê". Funciona, mas é o caminho mais lento e o que mais gera problemas de permissão e de fim de linha. A regra do livro: **o projeto que você edita e roda no Linux mora no disco do Linux** (`~`). O Windows enxerga esse disco pelo caminho que você conhece na próxima seção.

## `/mnt/c` e `\\wsl$`: atravessando para o outro lado

Do Linux para o Windows, o caminho é `/mnt/` seguido da letra do disco em minúscula. Do Windows para o Linux, o caminho começa com `\\wsl$\` seguido do **nome da distro** (o que o `wsl -l -v` mostra). Existe também a forma `\\wsl.localhost\`, que leva ao mesmo lugar.

| De onde você parte | Para onde vai | Caminho |
| --- | --- | --- |
| Ubuntu | `D:\wz-temp\lab` (Windows) | `/mnt/d/wz-temp/lab` |
| Windows | a sua pasta pessoal do Linux | `\\wsl$\Ubuntu-26.04\home\ana` |
| Windows | o mesmo, forma nova | `\\wsl.localhost\Ubuntu-26.04\home\ana` |

Para ver o lado Windows funcionar, rodei no PowerShell (via `powershell.exe`, de dentro da distro de teste, cujo nome é `wz-teste`) uma listagem do repositório do projeto:

```powershell
Get-ChildItem '\\wsl$\wz-teste\home\ana\meu-ambiente' -Force |
  Select-Object -ExpandProperty Name
```

Saída:

```text
.git
.gitattributes
verificar.ps1
verificar.sh
README.md
```

(O `.gitattributes` só aparece na lista depois do passo da seção sobre fim de linha, mais adiante.) No seu computador, troque `wz-teste` pelo nome da sua distro, por exemplo `Ubuntu-26.04`. No Explorer, basta digitar `\\wsl$` na barra de endereço: as suas distros aparecem como pastas.

> 💡 **Analogia:** os dois sistemas de arquivos são dois bairros de uma cidade, cada um com a própria língua. O Linux é o bairro onde você mora; `/mnt/c` é o bairro vizinho, e o 9p é a ponte com um tradutor na alfândega. Cada arquivo que você pede do outro lado é uma viagem na ponte: o tradutor confere o documento, converte, devolve. Com um arquivo grande, uma viagem basta. Com 2.000 arquivos pequenos, são 2.000 viagens. A analogia falha em um ponto: a ponte é automática, ninguém precisa pedir; e por isso é fácil esquecer que ela existe.

> ⚠️ **Erro comum:** abrir a pasta do Linux no Windows pelo caminho real do disco virtual, escondido dentro de `AppData`. Use sempre `\\wsl$`, que é o caminho que o WSL mantém para isso.

## `wslpath` e `explorer.exe`: converter e abrir

Escrever caminhos à mão, trocando `\` por `/` e `C:` por `/mnt/c`, é receita para erro. O comando **`wslpath`** converte para você. Com `-w` ele devolve o caminho no formato do Windows; com `-u`, no formato do Linux.

```bash
# a minha pasta pessoal, como o Windows a enxerga
wslpath -w ~
# um caminho do Windows, como o Linux o enxerga
wslpath -u 'D:\wz-temp\lab'
# sem opção, ele converte para o outro lado, seja qual for o seu
wslpath 'C:\Windows'
```

Saída:

```text
\\wsl.localhost\wz-teste\home\ana
/mnt/d/wz-temp/lab
/mnt/c/Windows
```

Repare nas aspas simples em volta de `'D:\wz-temp\lab'`: no bash, a barra invertida é um caractere especial, e as aspas simples a mantêm como está.

O outro lado da ponte é o **`explorer.exe`**: do Ubuntu, você pode chamar programas do Windows pelo nome com `.exe` (o WSL chama isso de *interop*, interoperabilidade). Os dois mais úteis do dia a dia:

```bash
# abre a pasta atual no Explorer do Windows (o ponto é a pasta atual)
explorer.exe .
# abre um arquivo do Linux no programa que o Windows associou a ele
explorer.exe notas.pdf
```

Confirme que o comando existe para o Linux achar:

```bash
command -v explorer.exe
```

```text
/mnt/c/WINDOWS/explorer.exe
```

> ⚠️ **Não executado:** `explorer.exe .` abre uma janela no computador de quem roda e não há ninguém para ver a janela na distro de teste; só confirmei que o programa é encontrado. Ao rodar no seu PC, o Explorer abre em `\\wsl.localhost\<sua distro>\...` na pasta em que você estava. Fonte: [Trabalhar entre sistemas de arquivos](https://learn.microsoft.com/windows/wsl/filesystems).

Os dois comandos se combinam: `wslpath -w .` mostra a pasta atual no formato do Windows, que é o que você cola numa janela de "Abrir arquivo" de um programa do Windows.

> ⚠️ **Erro comum:** esquecer o ponto: `explorer.exe` sozinho abre o Explorer na pasta padrão dele, não onde você está.

## Desempenho: o projeto mora no Linux

A documentação oficial recomenda guardar os arquivos no sistema de arquivos do WSL quando você trabalha numa linha de comando Linux, e não em `/mnt/c`. Em vez de confiar, meça. O teste cria 2.000 arquivos pequenos numa pasta do Linux e depois numa pasta do Windows (`D:`), e lê todos de volta:

```bash
# time mede quanto cada trecho demorou; só o "real" interessa
mkdir -p ~/teste-linux /mnt/d/wz-temp/teste-mnt
for dir in ~/teste-linux /mnt/d/wz-temp/teste-mnt; do
  cd "$dir"
  echo "$dir"
  time (for i in $(seq 1 2000); do echo "linha $i" > "arq$i.txt"; done)
  time (cat arq*.txt | wc -l)
done 2>&1 | grep -E 'teste|real'
# limpa o que criou
rm -rf ~/teste-linux /mnt/d/wz-temp/teste-mnt
```

Saída:

```text
/home/ana/teste-linux
real	0m0.136s
real	0m0.081s
/mnt/d/wz-temp/teste-mnt
real	0m5.323s
real	0m6.256s
```

Em cada pasta, a primeira linha `real` é a criação dos 2.000 arquivos; a segunda é a leitura de todos.

![Gráfico de barras: 0,14 s para criar 2.000 arquivos no Linux contra 5,3 s no disco do Windows](../img/c04-desempenho.svg)

| Operação | `~` (ext4) | `/mnt/d` (9p) | Diferença |
| --- | --- | --- | --- |
| Criar 2.000 arquivos | 0,136 s | 5,323 s | cerca de 39 vezes |
| Ler os 2.000 arquivos | 0,081 s | 6,256 s | cerca de 77 vezes |

Os números mudam de computador para computador (e dependem do disco e do antivírus); a ordem de grandeza é o que importa. É o efeito da ponte da analogia: cada arquivo pequeno vira uma viagem. Um `git status`, um `npm install` ou um `pip install` tocam milhares de arquivos pequenos, e é onde você sente a diferença.

> ⚠️ **Erro comum:** concluir que `/mnt/c` é "ruim". Para **um arquivo grande** (um vídeo, um instalador, um PDF), a diferença quase some. O que custa caro são muitos arquivos pequenos. Use `/mnt/c` para trocar arquivos soltos com o Windows, e o disco do Linux para projetos.

### As permissões que chegam de lá

Arquivos vindos de `/mnt` chegam com o "poder total" que o Linux inventa para eles. Isso aparece no Git:

```bash
# um arquivo de texto qualquer, que está no disco do Windows
ls -l /mnt/d/wz-temp/lab/README.md | awk '{print $1, $NF}'
# copia para o disco do Linux, dentro de um repositório novo
mkdir ~/perm && cd ~/perm && git init -q
cp /mnt/d/wz-temp/lab/README.md notas.md
ls -l notas.md | awk '{print $1, $NF}'
git add notas.md && git ls-files -s | cut -c1-6
# tira o bit de executável e confere de novo
chmod 644 notas.md && git add notas.md && git ls-files -s | cut -c1-6
cd ~ && rm -rf ~/perm
```

Saída:

```text
-rwxrwxrwx README.md
-rwxr-xr-x notas.md
100755
100644
```

O `cp` levou a permissão de executável do arquivo de origem, e o Git registrou o modo `100755` (executável) para um simples texto. O `chmod 644` e um novo `git add` corrigem para `100644`. Quando um arquivo "executável" aparece sem motivo num repositório, é essa a origem.

## CRLF × LF: o fim de linha

Um arquivo de texto marca o fim de cada linha com caracteres invisíveis. O Linux usa um só, o **LF** (*line feed*, `\n`). O Windows, tradicionalmente, usa dois, o **CRLF** (`\r\n`, *carriage return* + *line feed*). Muitos editores do Windows gravam CRLF por padrão, e o problema aparece quando um `.sh` salvo assim chega ao bash.

Reproduza no `~/meu-ambiente`. O comando `sed` abaixo faz o que o editor do Windows faria: acrescenta um `\r` ao fim de cada linha. O `file` mostra o resultado, e o `git ls-files --eol` mostra o fim de linha no índice do Git (`i/`) e na pasta de trabalho (`w/`).

```bash
cd ~/meu-ambiente
# simula o salvamento com CRLF
sed -i 's/$/\r/' verificar.sh
# o file separa os atributos por vírgula; uma por linha, cabe na página
file verificar.sh | cut -d: -f2 | tr ',' '\n'
git ls-files --eol verificar.sh
bash verificar.sh 2>&1 | head -2
```

Saída (falha de propósito):

```text
 Bourne-Again shell script
 Unicode text
 UTF-8 text executable
 with CRLF line terminators
i/lf    w/crlf  attr/                 	verificar.sh
verificar.sh: line 4: $'\r': command not found
verificar.sh: line 6: syntax error near unexpected token `$'{\r''
```

O bash leu o `\r` como parte do comando. É o erro `$'\r': command not found`: sempre que você o vir, procure CRLF num arquivo que o Linux executa. Note ainda o `i/lf w/crlf`: o Git guardou LF, mas a pasta de trabalho tem CRLF.

Conserte a pasta de trabalho e peça ao Git para cuidar disso daqui em diante, com um arquivo **`.gitattributes`**, que fica no repositório e vale para quem clonar:

<!-- project: meu-ambiente -->

**.gitattributes**

```text
# o Git decide o fim de linha; scripts de shell ficam sempre com LF
* text=auto
*.sh text eol=lf
*.ps1 text eol=crlf
```

Cada linha tem um papel: `* text=auto` deixa o Git descobrir o que é texto e guardar sempre LF no repositório; `*.sh text eol=lf` obriga os scripts de shell a ficarem com LF **também na pasta de trabalho**, em qualquer sistema; `*.ps1 text eol=crlf` faz o contrário com os scripts do PowerShell, que funcionam com CRLF.

```bash
# restaura o arquivo, grava o .gitattributes e faz o commit
git checkout -- verificar.sh
cat > .gitattributes <<'EOF'
# o Git decide o fim de linha; scripts de shell ficam sempre com LF
* text=auto
*.sh text eol=lf
*.ps1 text eol=crlf
EOF
git add .gitattributes
git commit -qm "Fixa o fim de linha com .gitattributes"
git ls-files --eol
```

```text
i/lf    w/lf    attr/text=auto        	.gitattributes
i/lf    w/lf    attr/text=auto        	README.md
i/lf    w/lf    attr/text eol=crlf    	verificar.ps1
i/lf    w/lf    attr/text eol=lf      	verificar.sh
```

Agora o editor do Windows grava CRLF de novo. O Git avisa e normaliza, e basta recriar a cópia de trabalho:

```bash
sed -i 's/$/\r/' verificar.sh
# o Git avisa e guarda LF mesmo assim (o fold só quebra a linha longa do aviso)
git add verificar.sh 2>&1 | fold -s -w 78
git ls-files --eol verificar.sh
# recria o arquivo a partir do Git e roda
rm verificar.sh && git checkout -- verificar.sh
git ls-files --eol verificar.sh
```

```text
warning: in the working copy of 'verificar.sh', CRLF will be replaced by LF 
the next time Git touches it
i/lf    w/crlf  attr/text eol=lf      	verificar.sh
i/lf    w/lf    attr/text eol=lf      	verificar.sh
```

### A configuração `core.autocrlf` e o que ela não faz

Você vai achar tutoriais mandando rodar `git config --global core.autocrlf true`. É um ajuste **pessoal**, só da sua máquina, que não viaja com o repositório: quem clona sem ele volta a ter o problema. No `meu-ambiente`, o `autocrlf` está desligado (o `git config core.autocrlf` volta vazio) e quem manda é o `.gitattributes`. Prefira sempre o arquivo no repositório.

> ⚠️ **Erro comum:** consertar o sintoma com `dos2unix` ou `sed` e esquecer a causa. Sem `.gitattributes` e com um editor do Windows, o CRLF volta no próximo salvamento.

## O projeto: `verificar.sh` com 8 testes

O `meu-ambiente` ganha o `.gitattributes` (acima) e um oitavo teste no verificador: a função `lf_fixo` confere que o `.gitattributes` existe e que o próprio script não tem CRLF. Mostro o arquivo inteiro para você não precisar juntar pedaços; só mudaram o comentário e a função `lf_fixo` e a linha do novo `checa`.

**verificar.sh**

```bash
#!/usr/bin/env bash
# Confere, do lado Linux, se o ambiente está montado.
falhas=0

# roda o teste que vem depois da descrição; mostra OK ou FALHA
checa() {
  descricao=$1
  shift
  if "$@" > /dev/null 2>&1; then
    echo "OK    $descricao"
  else
    echo "FALHA $descricao"
    falhas=$((falhas + 1))
  fi
}

# o nome do kernel do WSL 2 termina assim
assinatura='microsoft-standard-WSL2'

# cada teste é uma função que devolve sucesso ou falha
eh_ubuntu() { grep -q '^ID=ubuntu' /etc/os-release; }
kernel_wsl2() { uname -r | grep -q "$assinatura"; }
proc_microsoft() { grep -qi microsoft /proc/version; }
usuario_comum() { [ "$(id -u)" -ne 0 ]; }
no_grupo_sudo() { id -nG | grep -qw sudo; }
systemd_ativo() { [ "$(ps -p 1 -o comm=)" = systemd ]; }
repo_existe() { git -C ~/meu-ambiente rev-parse --is-inside-work-tree; }
# o .gitattributes existe e este script não tem CRLF (o bash não o leria)
lf_fixo() {
  [ -f ~/meu-ambiente/.gitattributes ] && ! grep -q "$(printf '\r')" "$0"
}

checa "distribuição é o Ubuntu" eh_ubuntu
checa "kernel do WSL 2" kernel_wsl2
checa "/proc/version cita microsoft" proc_microsoft
checa "usuário comum, não root" usuario_comum
checa "usuário no grupo sudo" no_grupo_sudo
checa "systemd é o processo 1" systemd_ativo
checa "~/meu-ambiente é um repositório git" repo_existe
checa ".gitattributes presente e scripts com LF" lf_fixo

echo "---"
if [ "$falhas" -eq 0 ]; then
  echo "Tudo certo: este ambiente está montado."
else
  echo "$falhas teste(s) falharam."
  exit 1
fi
```

Rode, apague o `.gitattributes` para ver a falha, devolva e faça o commit:

```bash
bash verificar.sh | tail -4
# falha de propósito: sem o arquivo, o teste novo reclama
mv .gitattributes /tmp/ga
bash verificar.sh | grep -E "FALHA|falharam"
mv /tmp/ga .gitattributes
git add -A && git commit -qm "verificar.sh com 8 testes"
bash verificar.sh | tail -2
```

```text
OK    ~/meu-ambiente é um repositório git
OK    .gitattributes presente e scripts com LF
---
Tudo certo: este ambiente está montado.
FALHA .gitattributes presente e scripts com LF
1 teste(s) falharam.
Tudo certo: este ambiente está montado.
```

> ⚠️ **Executado** na distro de teste (Ubuntu 26.04.1, `wz-teste`) como o usuário `ana`; o lado Windows (`\\wsl$`) foi consultado via `powershell.exe` de dentro da distro. Os tempos e os tamanhos de disco são desta máquina; no seu, mudam.

## 🏋️ Pratique

**1. Exemplo resolvido.** Um colega guarda o projeto em `C:\Users\colega\app` e roda `npm install` pelo Ubuntu, em `/mnt/c/Users/colega/app`. Demora minutos. O que está acontecendo e o que fazer?

<details>
<summary>Ver resposta</summary>

O `npm install` cria milhares de arquivos pequenos, e cada um atravessa a ponte 9p do disco do Windows, que é lenta para isso. A solução é mover o projeto para o disco do Linux (por exemplo, `cp -r /mnt/c/Users/colega/app ~/app`) e rodar o `npm install` de lá. Para editar com um programa do Windows, abra `\\wsl$\<distro>\home\colega\app`. Se o colega só *consulta* o projeto de vez em quando pelo Windows, nada precisa mudar nesse acesso.

</details>

**2. Complete.** Preencha as lacunas: para saber como o Windows enxerga a pasta atual do Ubuntu, rode `___ -w .`; para abrir essa pasta no Explorer, `___ .`.

<details>
<summary>Ver resposta</summary>

`wslpath -w .` e `explorer.exe .`. Erro comum: esquecer o `.exe` (o Linux não acha `explorer`) ou o ponto no final.

</details>

**3. Faça sozinho.** No Ubuntu, crie `~/praticas4`, um arquivo `a.sh` com `echo oi`, deixe-o com CRLF usando o `sed` da seção, rode e leia o erro; depois conserte com `sed -i 's/\r$//' a.sh` e rode de novo.

<details>
<summary>Ver resposta</summary>

```bash
mkdir ~/praticas4 && cd ~/praticas4
echo 'echo oi' > a.sh
# simula o editor do Windows
sed -i 's/$/\r/' a.sh
bash a.sh | od -c | head -1
# o sed abaixo tira o \r do fim de cada linha
sed -i 's/\r$//' a.sh
bash a.sh
```

Com um `echo` só, o script não quebra: imprime `oi\r` (o `od -c` mostra o `\r` escondido antes do `\n`), e você nem percebe. Já num script com função, como o `verificar.sh`, o bash para com `syntax error near unexpected token` e `$'\r'`. Depois do `sed`, imprime só `oi`. Critérios: (1) o `\r` foi reconhecido como a causa; (2) a correção tira o `\r` só do fim da linha. Em equipe, a correção definitiva é o `.gitattributes`, não o `sed`.

</details>

**4. Desafio.** Você clona um repositório da equipe no `/mnt/c` e, no Ubuntu, o `./deploy.sh` falha com `bad interpreter: /bin/bash^M`. Explique a causa em duas frases, diga como confirmar com um comando e qual arquivo evitaria o problema para toda a equipe.

<details>
<summary>Ver resposta</summary>

O `^M` é o `\r` do CRLF colado ao nome do interpretador na primeira linha (`#!/bin/bash`): o sistema procura um programa chamado `bash\r`, que não existe. Para confirmar, `file deploy.sh` (que cita "CRLF line terminators") ou `git ls-files --eol deploy.sh`. O arquivo que evita o problema para todos é um `.gitattributes` com `*.sh text eol=lf`. Critérios: (1) liga `^M` ao CRLF; (2) usa `file` ou `--eol`; (3) propõe a correção no repositório, e não só na máquina de uma pessoa.

</details>

**Arquivos do projeto ao fim do capítulo:** em `~/meu-ambiente`, `README.md`, `.gitattributes`, `verificar.sh` (agora com 8 testes) e `verificar.ps1`, com três commits. **Comando que confere:** `bash ~/meu-ambiente/verificar.sh` termina com "Tudo certo".

## 🧠 Revisão rápida

1. Em que lugar deve morar um projeto que você edita e roda no Linux? Por quê?
2. Que caminho você digita no Explorer para ver os arquivos de uma distro?
3. O que o `wslpath -u 'D:\dados'` devolve?
4. O que significa o erro `$'\r': command not found` e como evitá-lo no repositório?
5. (Capítulo 3) Por que o `sudo` pede a sua senha, e não a do root?

<details>
<summary>Ver respostas</summary>

1. No disco do Linux (`~`): muitos arquivos pequenos são muito mais rápidos que em `/mnt/c`, e as permissões funcionam como o Linux espera.
2. `\\wsl$` (ou `\\wsl.localhost`), seguido do nome da distro.
3. `/mnt/d/dados`.
4. O arquivo tem fim de linha CRLF; evita-se com um `.gitattributes` (`*.sh text eol=lf`).
5. Porque o `sudo` confere que é você quem pede o poder emprestado, e o root em geral nem tem senha.

</details>

## 🤖 Estude com um tutor de IA

- "Faça-me 5 perguntas sobre os dois sistemas de arquivos do WSL, `wslpath` e fim de linha CRLF × LF, uma de cada vez. Espere a minha resposta antes de dar o retorno e não me dê as respostas antes."
- "Esta é a minha resposta ao exercício 4: [minha resposta]. Aponte os meus erros sem me dar a solução."

> ➡️ **Próximo passo:** no capítulo 5 você deixa o terminal com a sua cara: Windows Terminal, perfis, fonte, um prompt melhor e os arquivos de configuração (*dotfiles*) guardados no `meu-ambiente`.

## 📌 Resumo

| Item | Em uma frase |
| --- | --- |
| Dois sistemas de arquivos | ext4 no disco do Linux; os discos do Windows entram por `/mnt/c`, `/mnt/d` |
| `\\wsl$\<distro>` | O caminho do Windows para os arquivos do Linux |
| `wslpath -w` / `-u` | Converte caminhos para o formato do Windows / do Linux |
| `explorer.exe .` | Abre a pasta atual do Linux no Explorer |
| Desempenho | Muitos arquivos pequenos em `/mnt` custam dezenas de vezes mais |
| Permissões de `/mnt` | Chegam como `rwxrwxrwx`; no Git viram `100755` |
| CRLF × LF | O Windows grava `\r\n`, o Linux `\n`; o bash tropeça no `\r` |
| `.gitattributes` | Fixa o fim de linha no repositório, para todos |

## 📚 Fontes

- [Trabalhar entre sistemas de arquivos do Windows e do Linux](https://learn.microsoft.com/windows/wsl/filesystems) (conferido em 27/11/2026)
- [Configurações avançadas do WSL: automount](https://learn.microsoft.com/windows/wsl/wsl-config) (27/11/2026)
- Execuções: distro de teste Ubuntu 26.04.1 no WSL 2 (git 2.53.0), 27/11/2026.

> 🔁 **Revise hoje:** 1, 3

<!-- nav:start -->
---

[◀ Capítulo anterior](03-primeiros-passos-no-ubuntu.md) · [Mapa do livro](../README.md) · [Próximo capítulo ▶](05-o-terminal-do-seu-jeito.md)
<!-- nav:end -->
