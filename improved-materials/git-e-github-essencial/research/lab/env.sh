# ambiente isolado para os laboratórios do livro
: "${SP:?defina SP com uma pasta temporária, fora do repositório}"
export HOME="$SP/home" USERPROFILE="$SP/home"
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL="$SP/home/.gitconfig"
export GIT_PAGER=cat PAGER=cat LANG=C LC_ALL=C TZ=America/Sao_Paulo
mkdir -p "$HOME"
if [ ! -f "$GIT_CONFIG_GLOBAL" ]; then
  git config --global user.name "Ana Ribeiro"
  git config --global user.email "ana.ribeiro@example.com"
  git config --global init.defaultBranch main
  git config --global core.editor true
fi
R="$SP/lab/receitas"
# commit com data fixa: at "2026-11-21T10:00:00" git commit ...
at() { local d="$1-03:00"; shift; GIT_AUTHOR_DATE="$d" GIT_COMMITTER_DATE="$d" "$@"; }
run() { echo "\$ $*"; "$@" 2>&1; echo; }
