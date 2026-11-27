#!/usr/bin/env bash
# Prepara um Ubuntu novo para o meu-ambiente. Pode rodar de novo: pula o que
# já está instalado.
set -eu
aqui=$(cd "$(dirname "$0")" && pwd)

passo() { echo "==> $1"; }

passo "pacotes do apt"
sudo apt-get update -qq
sudo apt-get install -y -qq git curl unzip zip

passo "nvm e Node.js (versão LTS)"
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  # baixa para um arquivo e roda; PROFILE=/dev/null: não mexe no ~/.bashrc
  curl -fsSL -o /tmp/nvm-install.sh \
    https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh
  PROFILE=/dev/null bash /tmp/nvm-install.sh > /dev/null
fi
. "$NVM_DIR/nvm.sh"
nvm install --lts > /dev/null 2>&1
echo "node $(node --version)"

passo "SDKMAN e Java"
export SDKMAN_DIR="$HOME/.sdkman"
if [ ! -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  # ?rcupdate=false: o instalador não edita o ~/.bashrc
  curl -fsSL "https://get.sdkman.io?rcupdate=false" -o /tmp/sdkman-install.sh
  bash /tmp/sdkman-install.sh > /dev/null 2>&1
  # responde "sim" sozinho às perguntas do sdk
  sed -i 's/sdkman_auto_answer=false/sdkman_auto_answer=true/' \
    "$SDKMAN_DIR/etc/config"
fi
# o init do SDKMAN usa variáveis que podem não existir: sai do modo -u
set +u
. "$SDKMAN_DIR/bin/sdkman-init.sh"
if [ ! -d "$SDKMAN_DIR/candidates/java/current" ]; then
  sdk install java > /dev/null 2>&1
fi
echo "java $(sdk current java | sed 's/.*: //')"
set -u

passo "uv (Python)"
if [ ! -x "$HOME/.local/bin/uv" ]; then
  curl -LsSf https://astral.sh/uv/install.sh -o /tmp/uv-install.sh
  UV_NO_MODIFY_PATH=1 sh /tmp/uv-install.sh > /dev/null 2>&1
fi
echo "$("$HOME/.local/bin/uv" --version)"

passo "dotfiles"
bash "$aqui/dotfiles/instalar.sh"
echo "bootstrap concluído"
