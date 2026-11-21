# Guia do tema: Git e GitHub essencial

## Como este livro ensina

- Perfil `stem` (tecnologia). Cada capítulo tem um **🧪 Laboratório** no terminal, com a saída real do Git 2.56 (Windows, Git Bash). Os comandos são iguais em macOS e Linux; diferenças de sistema ficam em tabela.
- **Projeto que acompanha o livro:** o repositório `receitas`, um pequeno site de receitas (HTML + Markdown). Nasce no cap. 3, recebe commits no 4, erros "de propósito" no 5, a branch `sobremesas` no 6, rebase no 7, um remoto (bare repository e depois GitHub) no 8 e colaboração no 9. O cap. 10 é o projeto final: currículo com GitHub Pages.
- **Exemplos novos:** não reaproveitar os exemplos das anotações (trabalho_final_v2, mudança de casa, foto × Instagram).
- **Metáfora única do livro:** o **álbum de fotos do projeto**. Cada commit é uma foto datada e legendada; a staging area é a mesa onde você escolhe o que entra na próxima foto; o histórico é o álbum. Aparece no cap. 3 e é só retomada depois.
- **Como o leitor se confere sozinho:** `git status`, `git log --oneline` e `git diff` são o gabarito de cada passo; cada exercício diz qual saída esperar.
- **Prever antes de ver:** antes de cada comando novo, perguntar que status ou saída o leitor espera.

## Diagramas

- `flow`: ciclo de vida dos arquivos; "qual comando desfaz o quê" (cap. 5); fluxo do pull request.
- `layers`/`boxes`: três áreas; cadeia de commits com hashes curtos reais.
- `compare`: centralizado × distribuído, Git × GitHub, merge × rebase, fetch × pull, revert × reset.
- `sequence`: push/fetch entre local e remoto; fork → PR.
- Imagens reais (`choices.images: real`): capturas de páginas do GitHub (`images.py screenshot`) e do VS Code (pedidas ao usuário). Sem logos de terceiros.

## Segurança

- Credenciais: ensinar primeiro Git Credential Manager e SSH; `credential.helper store` só como contraexemplo; nunca token na URL; `.env` no `.gitignore` desde o cap. 3.
- `reset --hard` e `push --force`: sempre com aviso e a alternativa segura (`--force-with-lease`).

## Evitar

- `git checkout` como forma principal: ensinar `git switch` e `git restore` (Git 2.23+) e citar o `checkout` como forma antiga.
- "simplesmente", "basta", jargão sem definição; terminal em imagem (terminal é sempre texto).
