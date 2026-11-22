. "$(dirname "$0")/env.sh"
rm -rf "$SP/lab"; mkdir -p "$R"; cd "$R"
git init -q
cat > index.html <<'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head><meta charset="utf-8"><title>Receitas da Ana</title></head>
<body>
  <h1>Receitas da Ana</h1>
  <!-- cada receita nova ganha um item nesta lista -->
  <ul>
    <li><a href="receitas/bolo-de-cenoura.md">Bolo de cenoura</a></li>
  </ul>
</body>
</html>
EOF
mkdir receitas
cat > receitas/bolo-de-cenoura.md <<'EOF'
# Bolo de cenoura

- 3 cenouras médias
- 4 ovos
- 2 xícaras de açúcar

Forno: 180 °C por 40 min.
EOF
git add index.html receitas
at 2026-11-21T10:00:00 git commit -q -m "Cria a página inicial e a receita de bolo"
sed -i 's/40 min/45 min/' receitas/bolo-de-cenoura.md
git add receitas/bolo-de-cenoura.md
at 2026-11-21T10:30:00 git commit -q -m "Ajusta o tempo de forno do bolo"
printf '\nDica: unte a forma com manteiga e farinha.\n' >> receitas/bolo-de-cenoura.md
git add receitas/bolo-de-cenoura.md
at 2026-11-21T11:00:00 git commit -q -m "Inclui dica de untar a forma"
printf 'CHAVE_API=troque-esta-chave\n' > .env
echo "servidor iniciado" > servidor.log
mkdir rascunhos
echo "# Pudim" > rascunhos/pudim.md
echo "# Torta de limão" > rascunhos/publicar.md
cat > .gitignore <<'EOF'
# segredos: nunca vão para o histórico
.env

# gerados ao rodar o site
*.log

# ideias ainda não testadas
rascunhos/*
!rascunhos/publicar.md
EOF
git add .gitignore rascunhos
at 2026-11-21T11:30:00 git commit -q -m "Ignora segredos, logs e rascunhos"
git log --oneline
git status -s
