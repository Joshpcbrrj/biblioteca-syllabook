. "$(dirname "$0")/env.sh"
cd "$R"
addlink() { sed -i "s|    <li><a href=\"receitas/pudim.md\">Pudim</a></li>|&\n    <li><a href=\"receitas/$1.md\">$2</a></li>|" index.html; }
echo "=== branch"
run git branch
run git branch sobremesas
run git branch
run cat .git/refs/heads/sobremesas
run git log --oneline -n 1
run cat .git/HEAD
echo "=== switch"
run git switch sobremesas
run cat .git/HEAD
cat > receitas/mousse-de-maracuja.md <<'EOF'
# Mousse de maracujá

- 1 lata de leite condensado
- 1 caixa de creme de leite
- 1 xícara de suco concentrado de maracujá

Bata tudo no liquidificador e leve à geladeira por 3 h.
EOF
addlink mousse-de-maracuja "Mousse de maracujá"
git add .
at 2026-11-24T09:00:00 git commit -m "Adiciona a receita de mousse de maracujá"
echo
run git log --oneline -n 3
run git switch main
run ls receitas
run git log --oneline -n 1
echo "=== erro ao trocar"
sed -i 's/<h1>Receitas da Ana<\/h1>/<h1>Receitas da Ana e da família<\/h1>/' index.html
run git status -s
run git switch sobremesas
git restore index.html
echo "=== stash"
git switch -q sobremesas
cat > receitas/torta-de-limao.md <<'EOF'
# Torta de limão

- 1 pacote de biscoito maisena
- 100 g de manteiga
EOF
addlink torta-de-limao "Torta de limão"
run git status -s
run git stash
run git status -s
run git stash pop
run git stash -u -m "torta pela metade"
run git status -s
run git stash list
run git switch main
echo "=== correcao (fast-forward)"
run git switch -c corrige-pudim
sed -i 's/por 1 h 30 min/por 1 h/' receitas/pudim.md
git add receitas/pudim.md
at 2026-11-24T10:00:00 git commit -m "Corrige o tempo de forno do pudim para 1 h"
echo
run git switch main
run git merge corrige-pudim
run git log --oneline -n 2
run git branch -d corrige-pudim
echo "=== volta e pop"
run git switch sobremesas
run git stash pop
run git stash list
cat >> receitas/torta-de-limao.md <<'EOF'
- 1 lata de leite condensado
- suco de 4 limões

Base: biscoito triturado com manteiga, 10 min no forno a 180 °C.
EOF
git add .
at 2026-11-24T11:00:00 git commit -m "Adiciona a receita de torta de limão"
echo
run git log --oneline --graph --all -n 6
echo "=== merge tres vias"
run git switch main
at 2026-11-24T11:30:00 git merge sobremesas
echo
run git log --oneline --graph -n 6
run git cat-file -p HEAD
run git branch -d sobremesas
echo "=== conflito"
run git switch -c forno-eletrico
sed -i 's/Forno: 180 °C por 45 min./Forno elétrico: 170 °C por 50 min./' receitas/bolo-de-cenoura.md
git add .
at 2026-11-24T14:00:00 git commit -m "Ajusta o bolo para forno elétrico"
echo
run git switch main
sed -i 's/Forno: 180 °C por 45 min./Forno: 180 °C por 40 min, até o palito sair limpo./' receitas/bolo-de-cenoura.md
git add .
at 2026-11-24T14:30:00 git commit -m "Volta o bolo para 40 min com teste do palito"
echo
run git log --oneline --graph --all -n 4
at 2026-11-24T15:00:00 git merge forno-eletrico
echo
run git status
run cat receitas/bolo-de-cenoura.md
run git diff
python - <<'PY'
import re
p="receitas/bolo-de-cenoura.md"
s=open(p,encoding="utf-8").read()
s=re.sub(r"<<<<<<< HEAD\n.*?>>>>>>> forno-eletrico\n","Forno a gás: 180 °C por 40 min, até o palito sair limpo.\nForno elétrico: 170 °C por 50 min.\n",s,flags=re.S)
open(p,"w",encoding="utf-8",newline="\n").write(s)
PY
git add receitas/bolo-de-cenoura.md
at 2026-11-24T15:10:00 git commit -q --no-edit
git branch -d forno-eletrico
git log --oneline -n 1
