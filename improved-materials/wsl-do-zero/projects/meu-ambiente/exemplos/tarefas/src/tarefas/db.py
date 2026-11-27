"""Storage for the tasks: one SQLite file, standard library only."""
import sqlite3  # vem com o Python: nenhuma dependência extra
from datetime import date

PRIORITIES = ("alta", "media", "baixa")


def connect(path):
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute(
        "CREATE TABLE IF NOT EXISTS tasks ("
        " id INTEGER PRIMARY KEY AUTOINCREMENT,"
        " title TEXT NOT NULL,"
        " priority TEXT NOT NULL,"
        " created TEXT NOT NULL,"
        " done INTEGER NOT NULL DEFAULT 0)"
    )
    return conn


def add_task(conn, title, priority="media"):
    title = title.strip()
    if not title:
        raise ValueError("O título não pode ser vazio.")
    if priority not in PRIORITIES:
        raise ValueError(f"Prioridade inválida: {priority}.")
    cur = conn.execute(
        "INSERT INTO tasks (title, priority, created) VALUES (?, ?, ?)",
        (title, priority, date.today().isoformat()),
    )
    conn.commit()
    return cur.lastrowid


def list_tasks(conn, priority=None, done=None):
    sql, args = "SELECT * FROM tasks WHERE 1=1", []
    if priority:
        sql += " AND priority = ?"
        args.append(priority)
    if done is not None:
        sql += " AND done = ?"
        args.append(int(done))
    return conn.execute(sql + " ORDER BY id", args).fetchall()


def complete_task(conn, task_id):
    cur = conn.execute("UPDATE tasks SET done = 1 WHERE id = ?", (task_id,))
    conn.commit()
    return cur.rowcount == 1


def delete_task(conn, task_id):
    cur = conn.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
    conn.commit()
    return cur.rowcount == 1
