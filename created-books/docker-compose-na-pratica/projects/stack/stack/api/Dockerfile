# estágio comum: Python, a biblioteca do banco e o código
FROM python:3.13-slim AS base
WORKDIR /app
# versão fixa: o build de amanhã instala a mesma biblioteca
RUN pip install --no-cache-dir "psycopg[binary]==3.3.9"
COPY app.py .

# desenvolvimento: o modo de desenvolvimento do Python mostra avisos extras
FROM base AS dev
CMD ["python", "-X", "dev", "-u", "app.py"]

# produção: o programa roda sem ser root
FROM base AS prod
RUN useradd --system --no-create-home app
USER app
CMD ["python", "-u", "app.py"]
