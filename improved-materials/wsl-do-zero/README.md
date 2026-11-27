![Capa do livro WSL do zero](cover.png)

# WSL do zero

Linux no Windows para programar

Para quem usa Windows e quer um ambiente de desenvolvimento Linux, sem máquina virtual nem dual boot. Ao terminar, você vai ter montado, personalizado, protegido com backup e restaurado um ambiente completo no WSL, com o Claude Code e o Spec Kit, e vai ter provado que ele volta do zero. Referência: WSL 3.0.5 (kernel 6.18.58.1) com o Ubuntu 26.04.1 LTS.

## Comece aqui

- [Como estudar este livro](chapters/00-como-estudar-este-livro.md): organização, ritmos e hábitos de estudo.
- [Teste de nivelamento](chapters/00-como-estudar-este-livro.md#teste-de-nivelamento): descubra por qual capítulo começar, se você já usou o WSL.

## 📇 O livro numa página

![O livro numa página: 1. O que é o WSL: Linux de verdade dentro do Windows, WSL 2 = kernel Linux numa VM leve, WSL × VM × dual boot. 2. Instalação: wsl --install -d Ubuntu-26.04, virtualização ligada no firmware, wsl -l -v mostra VERSION 2. 3. Primeiros passos: prompt: $ comum, # root, apt update ≠ apt upgrade, sudo; não trabalhe como root. 4. Arquivos entre os lados: projeto mora no ext4 do Linux, /mnt/c e \\wsl$ atravessam, CRLF × LF: .gitattributes. 5. Terminal do seu jeito: janela e fonte no Windows, Starship e locale no Ubuntu, dotfiles no repositório. 6. Ferramentas de dev: PATH: o primeiro achado vale, nvm, SDKMAN e uv, bootstrap.sh recria tudo. 7. Gerenciar o WSL: .wslconfig: todas, --shutdown, wsl.conf: uma, --terminate, --unregister apaga tudo. 8. Backup e restauração: wsl --export e --import, [user] default= no wsl.conf, prove o backup num clone. 9. Claude Code no WSL: instale como usuário, sem sudo, modos: default a plan, plugins e MCPs: leia antes. 10. Projeto final: Spec Kit: specify, plan, tasks, app de tarefas com testes, restaurar tudo em distro nova.](img/c00-o-livro-numa-pagina.svg)

## Sobre este livro

> Escrito com IA (Claude) a partir das fontes citadas em cada capítulo. Conferido em 27/11/2026. Revisão humana: não. Edição 2.0.

Este livro aprimora uma versão anterior, escrita em Markdown. Só a estrutura, os temas e os objetivos dela foram aproveitados: o texto, os exemplos e as saídas foram refeitos do zero.

## Erratas

Nenhuma errata registrada até agora. Achou um erro? Anote o capítulo, o trecho e o que você esperava ver, e envie ao autor.

<!-- map:start -->
<!-- map:end -->
