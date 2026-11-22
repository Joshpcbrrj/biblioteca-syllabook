. "$(dirname "$0")/env.sh"
cd "$R"
cat > receitas/brigadeiro.md <<'EOF'
# Brigadeiro

- 1 lata de leite condensado
- 1 colher de sopa de manteiga
- 3 colheres de sopa de chocolate em pó

Fogo baixo, mexendo sem parar, até soltar do fundo da panela.
EOF
sed -i 's|    <li><a href="receitas/bolo-de-cenoura.md">Bolo de cenoura</a></li>|&\n    <li><a href="receitas/brigadeiro.md">Brigadeiro</a></li>|' index.html
echo "=== A: status antes"
run git status -s
echo "=== A: erro -am numa cópia"
rm -rf "$SP/lab/copia"; cp -r "$R" "$SP/lab/copia"
( cd "$SP/lab/copia"; at 2026-11-22T09:00:00 git commit -am "Adiciona a receita de brigadeiro"; echo; git status -s )
echo "=== A: commit certo"
run git add index.html receitas/brigadeiro.md
run git status -s
at 2026-11-22T09:00:00 git commit --author="Bruno Lima <bruno.lima@example.com>" -m "Adiciona a receita de brigadeiro"
echo
echo "=== B: título"
sed -i 's/Receitas da Ana/Receitas de família/g' index.html
git add index.html
at 2026-11-22T09:40:00 git commit -m "Muda o título do site para Receitas de família"
echo
echo "=== C: açúcar, diffs"
sed -i 's/- 2 xícaras de açúcar/- 1 e 1\/2 xícara de açúcar/' receitas/bolo-de-cenoura.md
run git diff
run git add receitas/bolo-de-cenoura.md
run git diff
run git diff --staged
at 2026-11-22T18:00:00 git commit -m "Reduz o açúcar do bolo para 1 e 1/2 xícara" -m "No teste de domingo o bolo ficou doce demais. Com meia xícara a menos
a massa continua macia."
echo
echo "=== logs"
run git log
run git log --oneline
run git log --oneline -n 2
run git log --stat -n 2
run git log -p -n 1
run git log --oneline --author=Bruno
run git log --oneline --since=2026-11-22
run git log --oneline --since="2026-11-21 10:45" --until="2026-11-22 09:30"
run git log --oneline --grep=bolo
run git log --oneline --grep=bolo -i
run git log --oneline -- receitas/bolo-de-cenoura.md
run git log --format="%h %an %ar %s" -n 3
run git log --format="%h %an, %ad: %s" --date=short
echo "=== show/diff/blame"
run git show
run git show --stat HEAD~2
run git show HEAD~1:index.html
run git diff HEAD~2 HEAD
run git diff HEAD~3 --stat
run git blame receitas/bolo-de-cenoura.md
run git blame -L 5,7 receitas/bolo-de-cenoura.md
run git blame index.html
echo "=== HEAD"
run cat .git/HEAD
run cat .git/refs/heads/main
run git rev-parse HEAD
run git rev-parse --short HEAD HEAD~1 HEAD~2 HEAD^ HEAD^^
run git log --oneline HEAD~2
run git log --oneline -n 1 HEAD~6
run git rev-parse HEAD~7
run git status
