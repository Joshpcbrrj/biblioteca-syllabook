# Guia do tema: WSL do zero

Livro 1 da trilha ferramentas-do-dev (o Git e GitHub essencial é o 2; este não depende dele). Versão de referência: WSL 3.0.5 (kernel 6.18.58.1) com Ubuntu 26.04.1 LTS; conferida em 2026-11-27.

## Prática
- Projeto que cresce: **meu-ambiente**, repositório no home do Linux (`~/meu-ambiente`). Cap. 1 cria o verificador (`verificar.sh`, lado Linux, e `verificar.ps1`, lado Windows); cap. 3 cria o repositório; cap. 4 acrescenta `.gitattributes`; cap. 5 `dotfiles/`; cap. 6 `bootstrap.sh`; cap. 8 `backup.ps1`; cap. 10 fecha restaurando tudo.
- Todo laboratório roda na distro de teste `wz-teste` (Ubuntu 26.04.1 importado da imagem oficial .wsl, sha256 conferido com o catálogo da Microsoft). O que depende do reader (fonte e perfil do Windows Terminal, login do Claude Code, comandos interativos): "não executado", com a fonte oficial.
- Autoverificação: cada capítulo termina com um comando que dá OK/FALHA (o verificador cresce).

## Segurança (valem para o autor e para o texto)
- Nunca ensinar `wsl --shutdown` sem avisar que derruba TODAS as distros e o que roda nelas (Docker Desktop incluído); ensinar `wsl --terminate <distro>` primeiro. Nunca `--unregister` sem backup (apaga o disco virtual).
- Ensinar a forma segura primeiro: `.wslconfig` com cópia antes de editar; `--unregister` só na distro de teste; `curl | bash` só com a URL oficial, depois de olhar o script.
- Credenciais fora do código e do repositório; `/mnt/c` só para o que precisa; nada como root sem motivo.

## Diagramas
Camadas (Windows → VM leve → kernel → distro), compare (WSL 1 × WSL 2; VM × WSL × dual boot), flow (diagnóstico do PC; instalação), tree (sistemas de arquivos), sequence (wsl -d → VM → distro), boxes (prompt e caminhos). Imagens reais: capturas de programas só pelo `images.py docs` (MicrosoftDocs/WSL, MicrosoftDocs/terminal, MicrosoftDocs/windows-dev-docs); sem captura livre, o passo vai em texto.

## Evitar
- Ensinar Windows e Linux pela metade: cada comando diz de que lado roda (PowerShell ou Ubuntu).
- Afirmar saída que não foi vista: a saída vem da `wz-teste`; o que muda no PC do reader é dito.
- Comandos de gerenciamento que afetam a instalação do reader (o reader tem as próprias distros): sempre pelo nome da distro.
- Repetir o que é do livro Docker do zero: Docker no WSL só aponta para ele.

## Fatos do ambiente de produção (autor)
- Windows 11 build 10.0.26300.9974; WSL 3.0.5.0; kernel 6.18.58.1-1; WSLg 1.0.79. Distros do autor: Ubuntu-26.04 e docker-desktop (intocadas). Teste: wz-teste em D:\wz-temp.
- A imagem importada com `wsl --import` entra como **root** (sem usuário comum) e já traz `[boot] systemd=true` em `/etc/wsl.conf`.
