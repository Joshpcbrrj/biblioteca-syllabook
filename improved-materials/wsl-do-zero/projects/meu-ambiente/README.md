# meu-ambiente

Verificador e montador do meu ambiente de desenvolvimento no WSL.

## Do zero a um ambiente pronto

1. Instale o WSL e o Ubuntu (PowerShell): `wsl --install`
2. No Ubuntu: `git clone <endereço do repositório> ~/meu-ambiente`
3. `cd ~/meu-ambiente && ./bootstrap.sh` (pode rodar de novo)
4. Abra um terminal novo e rode `./verificar.sh`

## O que tem aqui

| Arquivo | Para quê |
| --- | --- |
| `verificar.sh` | Confere o lado Linux (11 testes) |
| `verificar.ps1` | Confere o lado Windows (5 testes) |
| `bootstrap.sh` | Instala as ferramentas; idempotente |
| `dotfiles/` | Starship e `bashrc.meu`, ligados por `instalar.sh` |
| `windows/` | Modelo do `.wslconfig` e o conferidor dele |
| `backup.ps1` | Exporta uma distro, grava o SHA-256 e testa a restauração |
| `backup-projetos.sh` | Backup leve de `~/projetos` |
| `claude/` | Modelo do `~/.claude/settings.json` |
| `CLAUDE.md` | Contexto e regras para o Claude Code |
| `exemplos/tarefas/` | App de referência do projeto final (Typer, SQLite, pytest) |
