"""Command line: tarefas adicionar | listar | concluir | apagar."""
import os
from pathlib import Path
from typing import Optional

import typer

from tarefas import db

app = typer.Typer(help="Lista de tarefas no terminal.")


def _conn():
    # TAREFAS_DB deixa os testes usarem um arquivo temporário
    path = os.environ.get("TAREFAS_DB", Path.home() / ".tarefas.db")
    return db.connect(path)


@app.command("adicionar")
def add(titulo: str, prioridade: str = "media"):
    """Adiciona uma tarefa."""
    try:
        task_id = db.add_task(_conn(), titulo, prioridade)
    except ValueError as erro:
        typer.echo(f"Erro: {erro}", err=True)
        raise typer.Exit(1)
    typer.echo(f"Tarefa {task_id} adicionada.")


@app.command("listar")
def list_(
    prioridade: Optional[str] = None,
    pendentes: bool = False,
    concluidas: bool = False,
):
    """Lista as tarefas, com filtros por prioridade e por status."""
    done = False if pendentes else True if concluidas else None
    for t in db.list_tasks(_conn(), prioridade, done):
        mark = "x" if t["done"] else " "
        typer.echo(f"{t['id']:>3} [{mark}] {t['priority']:<5} {t['title']}")


@app.command("concluir")
def complete(task_id: int):
    """Marca uma tarefa como concluída."""
    if not db.complete_task(_conn(), task_id):
        typer.echo(f"Erro: não existe a tarefa {task_id}.", err=True)
        raise typer.Exit(1)
    typer.echo(f"Tarefa {task_id} concluída.")


@app.command("apagar")
def delete(task_id: int, sim: bool = False):
    """Apaga uma tarefa, pedindo confirmação (use --sim para pular)."""
    if not sim:
        typer.confirm(f"Apagar a tarefa {task_id}?", abort=True)
    if not db.delete_task(_conn(), task_id):
        typer.echo(f"Erro: não existe a tarefa {task_id}.", err=True)
        raise typer.Exit(1)
    typer.echo(f"Tarefa {task_id} apagada.")
