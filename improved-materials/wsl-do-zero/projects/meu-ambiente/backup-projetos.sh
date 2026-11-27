#!/usr/bin/env bash
# Backup leve dos projetos: um .tar.gz sem as pastas que se reinstalam,
# mais o SHA-256. Uso: ./backup-projetos.sh [pasta-de-projetos] [destino]
set -eu
origem=${1:-$HOME/projetos}
destino=${2:-$HOME/backups}
[ -d "$origem" ] || { echo "Nao achei a pasta $origem" >&2; exit 1; }

mkdir -p "$destino"
arquivo="$destino/projetos-$(date +%F).tar.gz"
# -C entra na pasta de cima: os caminhos no pacote ficam relativos
tar -czf "$arquivo" \
  --exclude=node_modules --exclude=.venv --exclude=__pycache__ \
  -C "$(dirname "$origem")" "$(basename "$origem")"
nome=$(basename "$arquivo")
# o hash e gravado na mesma pasta, com o nome do arquivo (sem caminho)
(cd "$destino" && sha256sum "$nome" > "$nome.sha256")
echo "Criado: $arquivo ($(du -h "$arquivo" | cut -f1))"
(cd "$destino" && sha256sum -c "$nome.sha256")
