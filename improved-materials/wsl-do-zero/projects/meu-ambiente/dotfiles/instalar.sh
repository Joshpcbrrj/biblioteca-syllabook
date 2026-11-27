#!/usr/bin/env bash
# Liga os arquivos de dotfiles/ aos lugares onde os programas os leem.
set -eu
aqui=$(cd "$(dirname "$0")" && pwd)
mkdir -p ~/.config

# guarda uma configuração que já existia, antes de trocá-la por um link
if [ -f ~/.config/starship.toml ] && [ ! -L ~/.config/starship.toml ]; then
  mv ~/.config/starship.toml ~/.config/starship.toml.bak
fi
# -s: link simbólico; -f: troca o link antigo; -n: trata link como arquivo
ln -sfn "$aqui/starship.toml" ~/.config/starship.toml

# acrescenta uma linha ao ~/.bashrc, só se ela ainda não estiver lá
carga='~/meu-ambiente/dotfiles/bashrc.meu'
linha="[ -f $carga ] && . $carga"
grep -qxF "$linha" ~/.bashrc || echo "$linha" >> ~/.bashrc
echo "dotfiles ligados"
