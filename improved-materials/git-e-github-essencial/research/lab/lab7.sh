. "$(dirname "$0")/env.sh"
cd "$R"
addlink() { sed -i "s|    <li><a href=\"receitas/pudim.md\">Pudim</a></li>|&\n    <li><a href=\"receitas/$1.md\">$2</a></li>|" index.html; }
bruno() { at "$1" git commit --author="Bruno Lima <bruno.lima@example.com>" "${@:2}"; }
echo "=== bebidas"
git switch -q -c bebidas
cat > receitas/suco-de-laranja.md <<'EOF'
# Suco de laranja com cenoura

- 4 laranjas
- 1 cenoura pequena
- gelo a gosto

Bata a cenoura com o suco das laranjas e coe.
EOF
addlink suco-de-laranja "Suco de laranja"
git add .
at 2026-11-25T09:00:00 git commit -q -m "Adiciona a receita de suco de laranja com cenoura"
cat > receitas/limonada-suica.md <<'EOF'
# Limonada suíça

- 2 limões com casca
- 1 litro de água gelada
- 4 colheres de sopa de leite condensado

Bata por 10 segundos, no máximo, e coe na hora.
EOF
addlink limonada-suica "Limonada suíça"
git add .
at 2026-11-25T09:30:00 git commit -q -m "Adiciona a receita de limonada suíça"
git switch -q main
echo "Dica: use chocolate 50% cacau." >> receitas/brigadeiro.md
git add .
bruno 2026-11-25T10:00:00 -q -m "Sugere chocolate 50% no brigadeiro"
run git log --oneline --graph --all -n 4
echo "=== rebase"
run git switch bebidas
at 2026-11-25T10:30:00 git rebase main 2>&1; echo
run git log --oneline --graph --all -n 4
run git log --oneline -n 2 ORIG_HEAD
run git cat-file -p HEAD
run git switch main
run git merge bebidas
run git branch -d bebidas
run git log --oneline --graph -n 4
echo "=== conflito no rebase"
git switch -q -c porcoes
sed -i 's/^- 4 ovos$/- 3 ovos grandes/' receitas/bolo-de-cenoura.md
git add .
at 2026-11-25T11:00:00 git commit -q -m "Troca 4 ovos por 3 ovos grandes no bolo"
echo "" >> receitas/pudim.md
echo "Rende 8 porções." >> receitas/pudim.md
git add .
at 2026-11-25T11:10:00 git commit -q -m "Informa o rendimento do pudim"
git switch -q main
sed -i 's/^- 4 ovos$/- 4 ovos em temperatura ambiente/' receitas/bolo-de-cenoura.md
git add .
bruno 2026-11-25T11:30:00 -q -m "Pede ovos em temperatura ambiente no bolo"
run git log --oneline --graph --all -n 4
git switch -q porcoes
at 2026-11-25T12:00:00 git rebase main 2>&1; echo
run git status
run cat receitas/bolo-de-cenoura.md
# copia para mostrar o --abort
rm -rf "$SP/lab/abort" && cp -r "$R" "$SP/lab/abort"
( cd "$SP/lab/abort" && run git rebase --abort && run git status -s && run git log --oneline -n 1 )
echo "--- continue sem add"
GIT_EDITOR=true at 2026-11-25T12:00:00 git rebase --continue 2>&1; echo
sed -i '/^<<<<<<< /d;/^=======$/d;/^>>>>>>> /d;/^- 4 ovos em temperatura ambiente$/d;s/^- 3 ovos grandes$/- 3 ovos grandes em temperatura ambiente/' receitas/bolo-de-cenoura.md
run cat receitas/bolo-de-cenoura.md
run git diff --check
git add receitas/bolo-de-cenoura.md
GIT_EDITOR=true at 2026-11-25T12:00:00 git rebase --continue 2>&1; echo
run git log --oneline --graph -n 4
git switch -q main
run git merge porcoes
git branch -d porcoes
echo "=== rebase -i"
git switch -q -c quindim
cat > receitas/quindim.md <<'EOF'
# Quindim

- 1 xícara de acucar
- 6 gemas
- 50 g de coco ralado

Forno: 180 °C em banho-maria por 40 min.
EOF
git add .
at 2026-11-25T14:00:00 git commit -q -m "quindim"
addlink quindim "Quindim"
git add .
at 2026-11-25T14:10:00 git commit -q -m "Adiciona o link do quindim"
sed -i 's/de acucar/de açúcar/' receitas/quindim.md
git add .
at 2026-11-25T14:20:00 git commit -q -m "corrige acento"
echo "Teste: forno a 250 °C por 20 min." >> receitas/quindim.md
git add .
at 2026-11-25T14:30:00 git commit -q -m "teste forno 250"
run git log --oneline -n 5
# editor da lista: guarda a lista original e escreve a nova
cat > "$SP/seq.sh" <<'EOF'
cp "$1" "$SP/todo-original.txt"
sed -i -e '1s/^pick/reword/' -e '2s/^pick/squash/' -e '3s/^pick/fixup/' -e '4s/^pick/drop/' "$1"
cp "$1" "$SP/todo-editada.txt"
EOF
# editor das mensagens: guarda o que o Git mostrou e escreve a mensagem final
cat > "$SP/msg.sh" <<'EOF'
n=$(( $(ls "$SP"/msg-*.txt 2>/dev/null | wc -l) + 1 ))
cp "$1" "$SP/msg-$n.txt"
printf 'Adiciona a receita de quindim\n' > "$1"
EOF
rm -f "$SP"/msg-*.txt
GIT_SEQUENCE_EDITOR="bash $SP/seq.sh" GIT_EDITOR="bash $SP/msg.sh" at 2026-11-25T15:00:00 git rebase -i HEAD~4 2>&1; echo
echo "--- lista original"; cat "$SP/todo-original.txt"
echo "--- lista editada"; cat "$SP/todo-editada.txt"
for f in "$SP"/msg-*.txt; do echo "--- $f"; cat "$f"; done
run git log --oneline -n 3
run git show --stat HEAD
run cat receitas/quindim.md
git switch -q main
run git merge quindim
git branch -d quindim
run git log --oneline --graph -n 8
run git status
