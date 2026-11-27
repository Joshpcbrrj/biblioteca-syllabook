# meu-ambiente

Repositório que monta e confere o meu ambiente de desenvolvimento no WSL.

## Comandos

- `./verificar.sh`: confere o lado Linux (um OK ou FALHA por teste)
- `./bootstrap.sh`: instala as ferramentas; pode rodar de novo
- `./backup-projetos.sh`: backup leve de `~/projetos` em `~/backups`
- No Windows: `verificar.ps1` e `backup.ps1` (PowerShell)

## Regras

- Os scripts devem continuar idempotentes: rodar duas vezes não estraga nada.
- Os `.sh` usam fim de linha LF (veja o `.gitattributes`).
- Os `.ps1` ficam sem acentos (o PowerShell 5.1 lê sem marcação como ANSI).
- Nunca guardar senhas, tokens ou chaves neste repositório.
- Nunca rodar `wsl --shutdown` nem `wsl --unregister` sem eu pedir.
