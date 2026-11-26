# estágio 1 (build): tem compilador e arquivos de desenvolvimento
FROM python:3.14-slim AS build
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc libc6-dev libpq-dev \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /build
# o requirements.txt vem antes do código: o pip só refaz se ele mudar
COPY requirements.txt .
# instala numa pasta à parte (/install), para copiar só ela depois
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# estágio 2 (final): só o que o programa precisa para rodar
FROM python:3.14-slim
# a biblioteca de execução do PostgreSQL e o usuário comum, num RUN só
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home app
# os pacotes já prontos, direto do estágio 1
COPY --from=build /install /usr/local
WORKDIR /app
COPY app.py .

# a versão entra no build (--build-arg) e fica na imagem como variável
ARG APP_VERSAO=1.0
ENV APP_VERSAO=$APP_VERSAO PORTA=8000
USER app
EXPOSE 8000
# forma exec: o Python vira o PID 1 e recebe os sinais (capítulo 4)
CMD ["python", "app.py"]
