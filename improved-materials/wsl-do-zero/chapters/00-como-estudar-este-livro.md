# 0. Como estudar este livro

> Escrito com IA (Claude) a partir das fontes citadas em cada capítulo. Conferido em 27/11/2026. Revisão humana: não. Edição 2.0.
>
> Este livro aprimora uma versão anterior, escrita em Markdown. Só a estrutura, os temas e os objetivos dela foram aproveitados: o texto, os exemplos e as saídas foram refeitos do zero.

Este livro leva você de um PC com Windows a um ambiente de desenvolvimento Linux completo dentro dele: instalado, personalizado, com o Claude Code e o Spec Kit funcionando, e com um backup que você provou que restaura. A referência é o WSL 3.0.5 (kernel 6.18.58.1) com o Ubuntu 26.04.1 LTS. Os comandos e as saídas foram executados nessas versões, e o que não pôde ser executado está marcado no capítulo como **Não executado**.

## 📇 O livro numa página

![O livro numa página: 1. O que é o WSL: Linux de verdade dentro do Windows, WSL 2 = kernel Linux numa VM leve, WSL × VM × dual boot. 2. Instalação: wsl --install -d Ubuntu-26.04, virtualização ligada no firmware, wsl -l -v mostra VERSION 2. 3. Primeiros passos: prompt: $ comum, # root, apt update ≠ apt upgrade, sudo; não trabalhe como root. 4. Arquivos entre os lados: projeto mora no ext4 do Linux, /mnt/c e \\wsl$ atravessam, CRLF × LF: .gitattributes. 5. Terminal do seu jeito: janela e fonte no Windows, Starship e locale no Ubuntu, dotfiles no repositório. 6. Ferramentas de dev: PATH: o primeiro achado vale, nvm, SDKMAN e uv, bootstrap.sh recria tudo. 7. Gerenciar o WSL: .wslconfig: todas, --shutdown, wsl.conf: uma, --terminate, --unregister apaga tudo. 8. Backup e restauração: wsl --export e --import, [user] default= no wsl.conf, prove o backup num clone. 9. Claude Code no WSL: instale como usuário, sem sudo, modos: default a plan, plugins e MCPs: leia antes. 10. Projeto final: Spec Kit: specify, plan, tasks, app de tarefas com testes, restaurar tudo em distro nova.](../img/c00-o-livro-numa-pagina.svg)

## Como o livro está organizado

- **Capítulos 1 a 3:** o que é o WSL, a instalação do Ubuntu e os primeiros passos no terminal.
- **Capítulos 4 a 6:** os arquivos entre o Linux e o Windows, o terminal do seu jeito e as ferramentas de desenvolvimento.
- **Capítulos 7 a 10:** gerenciar o WSL, backup e restauração, o Claude Code e o projeto final com o Spec Kit.

O fio condutor é o projeto **meu-ambiente**, um repositório Git que nasce no capítulo 1 e cresce em todos os capítulos: os verificadores que provam que cada etapa funcionou, os dotfiles, o `bootstrap.sh` que recria tudo do zero, o `backup.ps1` e as regras do Claude Code. No capítulo 10, você restaura o ambiente inteiro numa distro nova usando só o que está nele.

A partir do capítulo 2, cada capítulo abre com um **Aquecimento**, com perguntas de capítulos anteriores, e com **De onde paramos**, uma retomada do anterior. Todos têm um **🧪 Laboratório** (ou um projeto) e terminam com **Pratique**, **Revisão rápida**, **Estude com um tutor de IA**, **Resumo** e **Fontes**. As respostas ficam escondidas logo abaixo de cada pergunta, em **Ver resposta**; no EPUB, vão para um apêndice no fim do livro, com um link de volta ao exercício. Seções marcadas com 🔎 são opcionais. No começo de cada parte (capítulos 1, 4 e 7) há uma folha de revisão da parte, em uma imagem.

## Quatro hábitos que fazem diferença

1. **Responda antes de olhar.** Errar uma previsão e depois ver a resposta fixa mais do que ler a resposta direto.
2. **Volte nos dias sugeridos.** O fim de cada capítulo diz, em 🔁 **Revise hoje**, quais capítulos anteriores revisitar.
3. **Explique com suas palavras.** Se você não consegue dizer em voz alta por que o projeto deve morar no disco do Linux e não em `/mnt/c`, ainda não aprendeu.
4. **Misture o velho e o novo.** Ao praticar, refaça um exercício de um capítulo antigo junto com os do capítulo atual.

## Em quanto tempo

O livro soma cerca de 8 h 35 min de leitura e prática (515 min, pelos tempos de cada capítulo). Estudando todos os dias:

| Ritmo | Por dia | Termina em |
| --- | --- | --- |
| Leve | ~20 min | ~4 semanas |
| Médio | ~40 min | ~2 semanas |
| Intenso | ~90 min | ~1 semana |

As instalações e os downloads levam mais tempo na primeira vez; não se preocupe se passar do estimado.

## Antes de rodar os comandos

- **Dois terminais:** os blocos marcados como PowerShell rodam no Windows; os de Bash rodam dentro do Ubuntu. O capítulo 3 explica o prompt do Ubuntu. Se um comando der "não encontrado", confira primeiro se você está no terminal certo.
- **Requisitos:** Windows 11, ou Windows 10 versão 2004 (build 19041) ou mais nova, com conta de administrador e a virtualização ligada no firmware. O capítulo 1 traz um verificador para conferir isso.
- **Nomes dos exemplos:** o usuário do Linux é `ana` e o projeto é `meu-ambiente`. Troque `ana` pelo seu usuário. O que o livro cria só para teste leva o prefixo `teste-`.
- **Comandos que derrubam coisas:** `wsl --shutdown` para todas as distros do computador, e `wsl --unregister` **apaga** uma distro com o disco dela. Se você já tem distros com projetos rodando (o Docker Desktop, por exemplo, usa uma), nunca rode esses dois sem ler antes o capítulo 7. Ali o livro mostra o caminho seguro e as alternativas que não derrubam nada. Para praticar o que é perigoso, use a distro de teste que o capítulo 8 ensina a criar.
- **Arquivos seus:** o capítulo 7 traz um modelo de `.wslconfig` e um conferidor que testam numa pasta temporária, sem tocar no seu arquivo. Aplicar é decisão sua: faça uma cópia do arquivo atual antes de qualquer mudança.
- **Passos que dependem de você:** instalar uma fonte, escolher o perfil do Windows Terminal e mexer nas configurações do Windows não podem ser verificados pelo livro. Esses passos aparecem como **Não executado**, com a fonte oficial ao lado.
- **Versões:** a saída na sua máquina pode diferir em números e datas (versões, tamanhos, tempos). O que importa é a forma da saída, e o livro diz o que observar.

## Revisões, tutor de IA e simulado

- Do capítulo 2 em diante, o **Aquecimento** e a **Revisão rápida** trazem perguntas de capítulos anteriores. Responda de cabeça antes de abrir a resposta.
- Os prompts de **Estude com um tutor de IA** são para colar num assistente de IA. Eles pedem que o assistente pergunte e espere você responder: use-os para treinar, não para receber a resposta pronta. Confira no próprio livro qualquer comando que o assistente sugerir, e nunca cole senhas ou tokens na conversa.
- O [Simulado final](11-simulado-final.md) cobre todos os objetivos do livro. Faça-o depois do capítulo 10 e use a tabela de diagnóstico do fim para saber o que revisar. O [Glossário](glossario.md) reúne os termos.

## Teste de nivelamento

Se você nunca usou o WSL, pule o teste e comece pelo [capítulo 1](01-o-que-e-o-wsl-e-quando-usar.md). Se já usou, responda as dez perguntas sem consultar nada e confira no fim.

1. Qual a diferença entre o WSL 1 e o WSL 2 na forma de rodar os programas do Linux? *(capítulo 1)*
2. Que comando lista as suas distros e mostra se cada uma roda no WSL 2? *(capítulo 2)*
3. Você roda `apt update` no Ubuntu e recebe `Permission denied` ao tentar abrir o arquivo de trava do `dpkg`. O que faltou? *(capítulo 3)*
4. Onde um projeto com milhares de arquivos pequenos roda mais rápido: em `~/projetos` ou em `/mnt/c/projetos`? Por quê? *(capítulo 4)*
5. A fonte do terminal se instala e se escolhe no Windows ou no Ubuntu? *(capítulo 5)*
6. `which -a node` lista duas linhas: uma em `/mnt/c/...` e outra no `nvm`. Qual delas o terminal executa? *(capítulo 6)*
7. Você editou o `%UserProfile%\.wslconfig`. O que precisa fazer para valer, e o que isso causa nas outras distros? *(capítulo 7)*
8. Você restaurou um backup com `wsl --import` e a distro abre como `root`. O que explica isso e como corrigir? *(capítulo 8)*
9. Por que o instalador do Claude Code não deve rodar com `sudo`? *(capítulo 9)*
10. No Spec Kit, qual a diferença entre a spec e o plan? *(capítulo 10)*

<details>
<summary>Ver resposta</summary>

1. No WSL 1, o Windows traduz as chamadas do Linux. No WSL 2, há um kernel Linux de verdade dentro de uma máquina virtual leve, sem tradução, e o `systemd` funciona.
2. `wsl -l -v`. A coluna `VERSION` mostra 1 ou 2.
3. O `sudo`. Mexer em pacotes exige root, e o `apt` sem `sudo` não consegue travar o banco de pacotes.
4. Em `~/projetos`, no disco do Linux (ext4). Os discos do Windows entram em `/mnt` por uma ponte mais lenta, e muitos arquivos pequenos custam dezenas de vezes mais lá.
5. No Windows. A janela, as cores e a fonte são do Windows Terminal; o Ubuntu cuida só do prompt e do idioma.
6. A primeira da lista: o shell usa o primeiro programa que achar no `PATH`, e a ordem do `PATH` decide quem vence.
7. Rodar `wsl --shutdown` e abrir a distro de novo. Isso para **todas** as distros e a máquina virtual, e o que estava só na memória se perde.
8. Uma distro importada não tem o lançador que a loja instala, então abre como root. Corrija com `[user]` e `default=<usuário>` no `/etc/wsl.conf`, com o usuário já criado na distro, e reinicie com `wsl --terminate`.
9. Porque ele não precisa de privilégios: instala na sua pasta pessoal (`~/.local`), como o seu usuário. Com `sudo`, a instalação iria para a pasta do root, e o instalador recusa rodar assim.
10. A spec diz o quê e por quê, sem tecnologia; o plan diz como: linguagem, bibliotecas e estrutura.

</details>

| Se você acertou... | Comece pelo |
| --- | --- |
| menos de 2 perguntas | [capítulo 1](01-o-que-e-o-wsl-e-quando-usar.md) |
| as perguntas 1 e 2 | [capítulo 3](03-primeiros-passos-no-ubuntu.md) |
| as perguntas 1 a 3 | [capítulo 4](04-arquivos-entre-linux-e-windows.md) |
| as perguntas 1 a 4 | [capítulo 5](05-o-terminal-do-seu-jeito.md) |
| as perguntas 1 a 5 | [capítulo 6](06-ferramentas-de-desenvolvimento-e-programas.md) |
| as perguntas 1 a 6 | [capítulo 7](07-gerenciar-o-wsl.md) |
| as perguntas 1 a 7 | [capítulo 8](08-backup-e-restauracao.md) |
| as perguntas 1 a 8 | [capítulo 9](09-claude-code-no-wsl.md) |
| as perguntas 1 a 9 | [capítulo 10](10-projeto-final-um-app-com-spec-kit.md) |
| todas as 10 | [Simulado final](11-simulado-final.md), e depois o capítulo 10 |

O teste mede o que você sabe, não o que você tem instalado. Mesmo começando adiante, leia o *Resumo* dos capítulos que pulou e crie o projeto **meu-ambiente** pelos capítulos 1 e 3: os exemplos seguintes usam os verificadores, os dotfiles e o `bootstrap.sh` dele.

> ➡️ **Próximo passo:** comece pelo capítulo que a tabela indicou.

<!-- nav:start -->
---

[Mapa do livro](../README.md) · [Próximo capítulo ▶](01-o-que-e-o-wsl-e-quando-usar.md)
<!-- nav:end -->
