FROM python:3.13-slim
WORKDIR /app
COPY app.py .
# -u: sem buffer, as mensagens do Python chegam na hora ao docker compose logs
CMD ["python", "-u", "app.py"]
