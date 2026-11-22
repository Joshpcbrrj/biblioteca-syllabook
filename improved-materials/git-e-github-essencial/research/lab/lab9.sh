. "$(dirname "$0")/env.sh"
cd "$SP/lab"
carla() { at "$1" git commit --author="Carla Souza <carla.souza@example.com>" "${@:2}"; }
echo "=== fork (copia no servidor)"
run git clone --bare receitas.git carla-fork.git
echo "=== clone da Carla"
mkdir -p carla && cd carla
run git clone ../carla-fork.git receitas
cd receitas
git remote set-url origin ../../carla-fork.git
git config user.name "Carla Souza"
git config user.email "carla.souza@example.com"
run git remote add upstream ../../receitas.git
run git remote -v
run git fetch upstream
run git branch -a
echo "=== branch da contribuicao"
run git switch -c sal-no-pao-de-queijo
sed -i 's/^- 200 g de queijo meia cura ralado$/&\n- 1 colher de chá de sal/' receitas/pao-de-queijo.md
git add .
at 2026-11-27T09:00:00 git commit -q -m "Acrescenta sal ao pão de queijo" -m "Closes #1"
run git log --oneline -n 2
run git push -u origin sal-no-pao-de-queijo
echo "=== Bruno envia algo ao original"
cd "$SP/lab/bruno/receitas"
git switch -q main && git pull -q
echo "" >> receitas/limonada-suica.md
echo "Sirva na hora, bem gelada." >> receitas/limonada-suica.md
git add . && at 2026-11-27T09:30:00 git commit -q -m "Pede para servir a limonada na hora"
run git push
echo "=== ajuste pedido na revisao"
cd "$SP/lab/carla/receitas"
sed -i 's/^- 1 colher de chá de sal$/- sal a gosto (cerca de 1 colher de chá)/' receitas/pao-de-queijo.md
git add . && at 2026-11-27T10:00:00 git commit -q -m "Deixa o sal a gosto, como pedido na revisão"
run git push
run git log --oneline -n 3
echo "=== Ana testa o PR localmente"
cd "$R"
run git switch main
run git pull
run git fetch ../carla-fork.git sal-no-pao-de-queijo:pr-1
run git log --oneline main..pr-1
run git diff main...pr-1
echo "=== tres formas de merge (em copias)"
for m in merge squash rebase; do rm -rf "$SP/lab/m-$m"; cp -r "$R" "$SP/lab/m-$m"; done
( cd "$SP/lab/m-merge" && at 2026-11-27T11:00:00 git merge -q --no-ff pr-1 -m "Merge da contribuição da Carla" && run git log --oneline --graph -n 5 )
( cd "$SP/lab/m-squash" && git merge -q --squash pr-1 && carla 2026-11-27T11:00:00 -q -m "Acrescenta sal ao pão de queijo" -m "Closes #1" && run git log --oneline --graph -n 3 )
( cd "$SP/lab/m-rebase" && git switch -q pr-1 && at 2026-11-27T11:00:00 git rebase -q main && git switch -q main && git merge -q pr-1 && run git log --oneline --graph -n 4 )
rm -rf "$SP/lab/m-merge" "$SP/lab/m-rebase"
echo "=== Ana fica com o squash"
git merge -q --squash pr-1
carla 2026-11-27T11:00:00 -m "Acrescenta sal ao pão de queijo" -m "Closes #1"
run git log -n 1
run git push
git branch -D pr-1
rm -rf "$SP/lab/m-squash"
echo "=== Carla sincroniza o fork"
cd "$SP/lab/carla/receitas"
run git switch main
run git fetch upstream
run git status -sb
run git merge upstream/main
run git push origin main
run git push origin --delete sal-no-pao-de-queijo
run git branch -d sal-no-pao-de-queijo
run git branch -D sal-no-pao-de-queijo
run git log --oneline -n 3
cd "$R"
run git status -sb
