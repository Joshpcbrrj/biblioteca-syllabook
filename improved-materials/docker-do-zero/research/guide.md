# Guia do tema: Docker do zero

## Como este livro ensina

- Perfil `stem` (tecnologia). Cada capítulo tem um **🧪 Laboratório** com a saída real do Docker Engine 29.9.3 e do Docker Desktop 4.99 (Windows 11, WSL 2, terminal Git Bash), rodado com as imagens oficiais. Os comandos valem em Linux e macOS; diferenças de sistema ficam em tabela.
- **Projeto que acompanha o livro:** a **API de tarefas** (Python, só biblioteca padrão), nascida no cap. 1 como uma página servida num contêiner, empacotada no cap. 7, enxugada no 8, ligada ao PostgreSQL 18 nos caps. 9 e 10, publicada no 11 e entregue na versão 1.1 com banco no cap. 12. O cap. 12 deixa a prévia do `compose.yaml` que o livro seguinte (Docker Compose na prática) retoma.
- **Metáfora única do livro:** a **cozinha com receita** — a imagem é a receita pronta e fechada; o contêiner é a cozinha em funcionamento feita a partir dela; os dados que precisam sobreviver ficam na **despensa** (volume), fora da cozinha. Aparece no cap. 1 e volta só nos caps. 6, 9 e 11. Não reaproveitar as analogias do original (praça de alimentação, fôrma de gelo, campeonato, aeroporto).
- **Como o leitor se confere sozinho:** cada passo diz que saída esperar (`docker ps`, `docker logs`, `curl`, `docker inspect --format`). Antes de comandos novos, uma pergunta de previsão.
- **Reler o original, não copiá-lo:** o original é a versão anterior do próprio autor; ainda assim o livro é reescrito do zero, com os dados atualizados (versões, saídas) e sem trechos reaproveitados.

## Diagramas

- `compare`: contêiner × VM; imagem × contêiner; volume × bind × tmpfs; rede padrão × rede própria.
- `flow`: estados do contêiner; do `docker run` ao processo; build → push → pull; cache de camadas.
- `layers`/`boxes`: camadas da imagem; multi-stage.
- `sequence`: CLI → API → Engine → containerd/runc.
- Imagens reais (`choices.images: real`): capturas do Docker Desktop (pedidas ao usuário, nunca desenhadas) e de páginas web do Docker Hub quando não exigirem login. Terminal é sempre texto.

## Segurança e cuidados

- Esta máquina tem **outros contêineres do autor rodando** (portas 3000 e 3001, volumes seus): nunca usar `docker system prune`, `volume prune` ou `rm -f` sem nome; nomear tudo com prefixo `dz-` e remover só o que o laboratório criou.
- Segredos: token de acesso pessoal, `--password-stdin`, nunca a senha da conta; nunca publicar segredo na imagem (`ENV`, `ARG`, `COPY .env`).
- `docker` group no Linux = poder de root; `-p` ignora regras do ufw/firewalld.
- Contêiner não é fronteira de segurança forte como VM.
- Laboratórios de instalação (caps. 2 e 3) não são executados na máquina do autor (Docker já está instalado): validar o que dá em contêiner descartável (repositório apt, grupo `docker`) e marcar o resto "não executado" com o motivo.

## Evitar

- "simplesmente", "basta", jargão sem definição.
- `docker-compose` (v1) e `docker run` com `--link`; `latest` como versão de produção; `:latest` sem avisar.
- Versões fixadas na prosa sem data: dizer "na versão de referência (Engine 29.9, Desktop 4.99)". Atenção: a versão atual do Desktop em 2026-11-26 é a 4.100.1; a de referência do livro fica 4.99 (a que roda aqui).
