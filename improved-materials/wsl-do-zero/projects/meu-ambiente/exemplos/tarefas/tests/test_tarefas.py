# Cada teste usa um banco temporário: o seu ~/.tarefas.db não é tocado
import pytest
from typer.testing import CliRunner

from tarefas import db
from tarefas.cli import app

runner = CliRunner()


@pytest.fixture
def conn(tmp_path):
    return db.connect(tmp_path / "t.db")


@pytest.fixture(autouse=True)
def banco_temporario(tmp_path, monkeypatch):
    monkeypatch.setenv("TAREFAS_DB", str(tmp_path / "cli.db"))


def test_empty_title_is_refused(conn):
    with pytest.raises(ValueError):
        db.add_task(conn, "   ")


def test_filter_by_priority_and_status(conn):
    a = db.add_task(conn, "a", "alta")
    db.add_task(conn, "b", "baixa")
    db.complete_task(conn, a)
    assert [t["title"] for t in db.list_tasks(conn, "alta")] == ["a"]
    assert [t["title"] for t in db.list_tasks(conn, done=False)] == ["b"]


def test_data_survives_between_runs(tmp_path):
    path = tmp_path / "x.db"
    db.add_task(db.connect(path), "fica salva")
    assert len(db.list_tasks(db.connect(path))) == 1


def test_cli_add_and_list():
    assert runner.invoke(app, ["adicionar", "estudar WSL"]).exit_code == 0
    saida = runner.invoke(app, ["listar"]).output
    assert "estudar WSL" in saida


def test_cli_empty_title_message():
    r = runner.invoke(app, ["adicionar", ""])
    assert r.exit_code == 1


def test_cli_delete_asks_confirmation():
    runner.invoke(app, ["adicionar", "x"])
    assert runner.invoke(app, ["apagar", "1"], input="n\n").exit_code != 0
    assert "x" in runner.invoke(app, ["listar"]).output
    assert runner.invoke(app, ["apagar", "1"], input="y\n").exit_code == 0
    assert runner.invoke(app, ["listar"]).output.strip() == ""
