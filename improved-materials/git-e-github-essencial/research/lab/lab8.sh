. "$(dirname "$0")/env.sh"
cd "$SP/lab"
addlink() { sed -i "s|    <li><a href=\"receitas/pudim.md\">Pudim</a></li>|&\n    <li><a href=\"receitas/$1.md\">$2</a></li>|" index.html; }
echo "=== bare"
run git init --bare receitas.git
run ls receitas.git
echo "=== remote add e push"
cd "$R"
run git remote -v
run git remote add origin ../receitas.git
run git remote -v
run git push -u origin main
run git branch -vv
run git branch -a
run git log --oneline -n 2
echo "=== push recusado em repositorio normal"
rm -rf "$SP/lab/normal" && git init -q "$SP/lab/normal" && (cd "$SP/lab/normal" && git commit -q --allow-empty -m x)
( cd "$SP/lab" && git clone -q normal normal-clone && cd normal-clone && git commit -q --allow-empty -m y && git remote set-url origin ../normal && run git push origin main )
rm -rf "$SP/lab/normal" "$SP/lab/normal-clone"
echo "=== clone do Bruno"
mkdir -p "$SP/lab/bruno" && cd "$SP/lab/bruno"
run git clone ../receitas.git
cd receitas
git remote get-url origin | sed "s|$SP|<SP>|"
run git remote set-url origin ../../receitas.git
run git config user.name "Bruno Lima"
git config user.email "bruno.lima@example.com"
run git remote -v
run git log --oneline -n 2
run git branch -a
cat > receitas/pao-de-queijo.md <<'EOF'
# Pão de queijo

- 500 g de polvilho azedo
- 250 ml de leite
- 2 ovos
- 200 g de queijo meia cura ralado

Forno: 180 °C por 25 min.
EOF
addlink pao-de-queijo "Pão de queijo"
git add .
at 2026-11-26T09:00:00 git commit -q -m "Adiciona a receita de pão de queijo"
run git status -sb
run git push
echo "=== fetch na Ana"
cd "$R"
run git status -sb
run git fetch
run git status -sb
run git log --oneline main..origin/main
run git diff --stat main origin/main
run git merge
run git log --oneline -n 2
echo "=== divergencia"
cd "$SP/lab/bruno/receitas"
sed -i 's/Dica: use chocolate 50% cacau./Dica: chocolate 50% cacau deixa o brigadeiro menos doce./' receitas/brigadeiro.md
git add . && at 2026-11-26T10:00:00 git commit -q -m "Explica a dica do chocolate no brigadeiro"
git push -q
cd "$R"
echo "" >> receitas/quindim.md
echo "Desenforme ainda morno." >> receitas/quindim.md
git add . && at 2026-11-26T10:30:00 git commit -q -m "Ensina a desenformar o quindim"
run git push
run git pull
run git pull --rebase
run git log --oneline --graph -n 4
run git push
run git status -sb
echo "=== force-with-lease"
git switch -q -c tortas
cat > receitas/torta-de-frango.md <<'EOF'
# Torta de frango

- 2 xícaras de frango desfiado
- 3 ovos
- 1 xícara de leite

Forno: 200 °C por 40 min.
EOF
git add . && at 2026-11-26T11:00:00 git commit -q -m "torta frango"
run git push -u origin tortas
GIT_EDITOR="sed -i 1s/.*/Adiciona\ a\ receita\ de\ torta\ de\ frango/" at 2026-11-26T11:10:00 git commit -q --amend
run git log --oneline -n 1
run git push
run git push --force-with-lease
run git status -sb
git switch -q main
echo "=== tags"
at 2026-11-26T12:00:00 git tag -a v1.0 -m "Primeira versão publicada do site"
run git tag rascunho-capa
run git tag
run git cat-file -t v1.0
run git cat-file -t rascunho-capa
run git show v1.0 --stat
run git push origin v1.0
run git ls-remote --tags origin
git tag -d rascunho-capa
cd "$SP/lab/bruno/receitas"
run git fetch
run git tag
run git switch --detach v1.0
git switch -q main
run git pull
cd "$R"
run git branch -vv
