FROM python:3.13-slim
WORKDIR /app
# versão fixa: o build de amanhã instala a mesma biblioteca
RUN pip install --no-cache-dir "psycopg[binary]==3.3.9"
COPY app.py .
CMD ["python", "-u", "app.py"]
