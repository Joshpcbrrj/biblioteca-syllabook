. "$(dirname "$0")/env.sh"
# projeto novo, independente do receitas: o currículo da Ana
C="$SP/lab/ana-ribeiro.github.io"
rm -rf "$C" "$SP/lab/ana-ribeiro.github.io.git"
mkdir -p "$C" && cd "$C"
echo "=== init e primeiros arquivos"
run git init
cat > index.html <<'EOF'
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <!-- sem esta linha, o celular mostra a página miniaturizada -->
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Ana Ribeiro · Currículo</title>
  <link rel="stylesheet" href="estilo.css">
</head>
<body>
  <h1>Ana Ribeiro</h1>
  <p>Desenvolvedora web em formação · São Paulo, SP</p>

  <h2>Projetos</h2>
  <ul>
    <li><strong>receitas</strong>: site de receitas da família, mantido com
      Git e GitHub, com contribuições por pull request.</li>
    <li><strong>horta comunitária</strong>: página de avisos da horta do
      bairro.</li>
  </ul>

  <h2>Formação</h2>
  <ul>
    <li>Técnico em Informática, 2025</li>
  </ul>

  <h2>Contato</h2>
  <p>ana.ribeiro@example.com</p>
</body>
</html>
EOF
cat > estilo.css <<'EOF'
/* uma coluna estreita é mais fácil de ler em qualquer tela */
body {
  max-width: 40rem;
  margin: 2rem auto;
  padding: 0 1rem;
  font-family: system-ui, sans-serif;
  line-height: 1.5;
  color: #222;
}
h2 {
  border-bottom: 2px solid #2a7ae2;
}
EOF
cat > README.md <<'EOF'
# Currículo da Ana Ribeiro

Meu currículo em uma página, publicado com **GitHub Pages**.

## Como ver no seu computador

1. Clone o repositório.
2. Abra o `index.html` no navegador.

## Arquivos

| Arquivo | Para quê |
| --- | --- |
| `index.html` | o conteúdo do currículo |
| `estilo.css` | cores, fontes e margens |

## Como atualizar

- [x] Editar o `index.html`
- [x] Conferir no navegador
- [ ] Fazer commit e push: o site se atualiza sozinho
EOF
run git status -s
git add .
run at 2026-11-28T09:00:00 git commit -m "Cria o currículo em uma página"
echo "=== remoto (no lugar do GitHub) e push"
run git init --bare ../ana-ribeiro.github.io.git
run git remote add origin ../ana-ribeiro.github.io.git
run git push -u origin main
echo "=== edicao para a captura do VS Code"
sed -i 's|    <li>Técnico em Informática, 2025</li>|&\n    <li>Git e GitHub essencial (estudo individual), 2026</li>|' index.html
cat >> README.md <<'EOF'

> [!TIP]
> Antes de cada push, abra o `index.html` no navegador e confira.
EOF
git add index.html
run git status -s
echo "=== commit e push (o mesmo que Commit e Sync Changes no VS Code)"
git add README.md
run at 2026-11-28T10:00:00 git commit -m "Adiciona o curso de Git à formação"
run git push
run git log --oneline
run git status -sb
echo "=== alias para o gist"
run git config --global alias.lg "log --oneline --graph --all"
run git lg
run git config --global --get alias.lg
