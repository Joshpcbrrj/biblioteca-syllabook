. "$(dirname "$0")/env.sh"
cd "$R"
echo "=== restore"
sed -i '/4 ovos/d; /cenouras/d' receitas/bolo-de-cenoura.md
run git status -s
run git diff
run git restore receitas/bolo-de-cenoura.md
run git status -s
echo "=== restore --staged"
printf 'leite condensado\nchocolate em pó\n' > lista-de-compras.txt
sed -i 's|    <li><a href="receitas/brigadeiro.md">Brigadeiro</a></li>|&\n    <li><a href="receitas/pudim.md">Pudim</a></li>|' index.html
cat > receitas/pudim.md <<'EOF'
# Pudim de leite

- 1 lata de leite condensado
- 2 medidas (da lata) de leite
- 3 ovos

Calda: 1 xícara de açúcar derretido na forma.
Forno: 180 °C em banho-maria por 1 h 30 min.
EOF
run git add .
run git status -s
run git restore --staged lista-de-compras.txt
run git status -s
echo "=== amend"
git restore --staged index.html
run git status -s
at 2026-11-23T09:00:00 git commit -m "Adiciona a receita de pudm"
echo
run git log --oneline -n 2
run git add index.html
GIT_COMMITTER_DATE="2026-11-23T09:05:00-03:00" git commit --amend -m "Adiciona a receita de pudim"
echo
run git log --oneline -n 2
run git show --stat -s --format="%h %s%n autor: %ad%n commit: %cd" HEAD
rm lista-de-compras.txt
echo "=== restore --source"
run git restore --source=9a16b95 receitas/bolo-de-cenoura.md
run git status -s
run git diff
run git restore receitas/bolo-de-cenoura.md
run git status -s
echo "=== checkout antigo (cópia)"
rm -rf "$SP/lab/copia5"; cp -r "$R" "$SP/lab/copia5"
( cd "$SP/lab/copia5"; git checkout 9b3de16 2>&1 )
echo
echo "=== detached"
run git switch --detach 9b3de16
run git status
run cat receitas/bolo-de-cenoura.md
run cat .git/HEAD
sed -i 's/180 °C por 45 min/200 °C por 35 min/' receitas/bolo-de-cenoura.md
git add receitas/bolo-de-cenoura.md
at 2026-11-23T10:00:00 git commit -m "Testa forno a 200 °C por 35 min"
echo
run git log --oneline -n 3
run git switch main
run git log --oneline -n 3
echo "=== reset"
cat > estilo.css <<'EOF'
/* teste: fundo escuro para ler à noite */
body { background: #222; color: #eee; }
EOF
git add estilo.css
at 2026-11-23T11:00:00 git commit -m "Testa fundo escuro no site"
echo
run git log --oneline -n 3
run git reset --soft HEAD~1
run git log --oneline -n 2
run git status -s
at 2026-11-23T11:10:00 git commit -q -m "Testa fundo escuro no site"
run git log --oneline -n 2
run git reset HEAD~1
run git status -s
git add estilo.css
at 2026-11-23T11:20:00 git commit -q -m "Testa fundo escuro no site"
run git log --oneline -n 2
run git reset --hard HEAD~1
run git status -s
run ls
run git log --oneline -n 2
echo "=== revert"
run git log --oneline -n 1 3ea07e1
at 2026-11-23T14:00:00 git revert 3ea07e1 --no-edit
echo
run git log --oneline -n 3
run git show HEAD
run git log -n 1
echo "=== reflog"
run git reflog
run git reflog -n 3 --date=iso
run git show --stat
git restore --source=38d0ae7 estilo.css
git add estilo.css
at 2026-11-23T15:00:00 git commit -q -m "Adiciona estilo com fundo escuro"
git log --oneline -n 1
