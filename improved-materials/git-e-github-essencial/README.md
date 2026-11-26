# Git e GitHub essencial

Do primeiro commit ao pull request, praticando num projeto real

Para quem programa (ou está começando) e nunca usou Git, ou usa só `add`, `commit` e `push` sem entender o que acontece. Ao fim do livro, você versiona um projeto com Git, desfaz erros sem medo, trabalha com branches, merge e rebase, sincroniza com remotos, contribui no GitHub por issue, fork e pull request e publica um currículo seu com GitHub Pages. Pré-requisito: usar o terminal no nível básico (`cd`, `ls`, `mkdir`).

## Comece aqui

- [0. Como estudar este livro](chapters/00-como-estudar-este-livro.md): como o livro funciona e em quanto tempo terminar.
- [Teste de nivelamento](chapters/00-como-estudar-este-livro.md#teste-de-nivelamento): já usa Git? Descubra em que capítulo começar.

## 📇 O livro numa página

![Cola do livro inteiro, em doze cartões: por que Git (histórico com autor e data, cópia completa em cada um, Git não é GitHub); configurar (user.name e user.email, token pelo GCM ou SSH, nunca token na URL); três áreas (pasta, staging, .git; status -s; .env no .gitignore); commits (pequenos, título no presente; log, show, diff, blame); desfazer (restore, --amend, revert no que foi enviado, reset só no local); branches (switch -c, merge fast-forward ou de três vias, conflito); rebase (linha reta, rebase -i, só em branch local); remotos (push, fetch, pull, origin/main, --force-with-lease); colaborar (issue, fork, PR, revisão, GitHub Flow); publicar (README em Markdown, GitHub Pages, gist); onde estou (status -sb, log --oneline --graph --all, reflog); segurança (segredo commitado: revogue; cuidado com --hard; revise o diff do PR)](img/c00-cola-do-livro.svg)

<!-- map:start -->
## 🗺️ Mapa do livro

- [0. Como estudar este livro](chapters/00-como-estudar-este-livro.md)
- [1. Por que controlar versões](chapters/01-por-que-controlar-versoes.md) · ⏱️ ~30 min
- [2. Instalação, identidade e credenciais](chapters/02-instalacao-identidade-e-credenciais.md) · ⏱️ ~45 min
- [3. Como o Git pensa](chapters/03-como-o-git-pensa.md) · ⏱️ ~45 min
- [4. Commits e histórico](chapters/04-commits-e-historico.md) · ⏱️ ~50 min
- [5. Desfazendo erros com segurança](chapters/05-desfazendo-erros-com-seguranca.md) · ⏱️ ~60 min
- [6. Branches, stash e merge](chapters/06-branches-stash-e-merge.md) · ⏱️ ~60 min
- [7. Rebase e histórico limpo](chapters/07-rebase-e-historico-limpo.md) · ⏱️ ~45 min
- [8. Repositórios remotos](chapters/08-repositorios-remotos.md) · ⏱️ ~60 min
- [9. Colaborando no GitHub](chapters/09-colaborando-no-github.md) · ⏱️ ~60 min
- [10. Projeto: currículo online](chapters/10-projeto-curriculo-online.md) · ⏱️ ~60 min
- [Simulado final](chapters/simulado-final.md)
- [Glossário](chapters/glossario.md)
<!-- map:end -->

## Sobre este livro

> Escrito com IA (Claude) a partir das fontes citadas em cada capítulo. Conferido em 22/11/2026. Revisão humana: não. Edição 1.0.
>
> Este livro aprimora as anotações do curso “Git e GitHub Essencial para o Desenvolvedor” (Geek University, Udemy). Do original vieram só a estrutura, os tópicos e os objetivos; o texto, os exemplos e os exercícios são novos.

Versão de referência: Git 2.5x e a interface do GitHub de 2026. Fontes principais: [Pro Git](https://git-scm.com/book/pt-br/v2), o [Git Reference Manual](https://git-scm.com/docs) e o [GitHub Docs](https://docs.github.com/pt).

## Errata

Achou um erro, um comando que não funciona como o livro diz ou uma tela do GitHub que mudou? [Abra uma issue](https://github.com/Joshpcbrrj/biblioteca-syllabook/issues/new) dizendo o capítulo, o trecho e o que você viu. As correções entram na próxima edição.

<!-- credit:start -->
📘 *Criado pela skill Claude Syllabook - Joshpcbrrj* · [github.com/Joshpcbrrj/syllabook](https://github.com/Joshpcbrrj/syllabook)
<!-- credit:end -->
