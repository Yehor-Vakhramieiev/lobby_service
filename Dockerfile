FROM python:3.12.1-slim-bullseye AS builder

COPY pyproject.toml ./

RUN python -m pip install poetry==1.8.2 && \
    poetry export -o requirements.prod.txt --without-hashes && \
    poetry export --with=dev -o requirements.dev.txt --without-hashes


FROM python:3.12 AS dev

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /lobby_service

RUN apt update -y && \
    apt install -y python3-dev \
    gcc \
    musl-dev

ADD pyproject.toml /lobby_service

RUN pip install --upgrade pip
RUN pip install poetry

RUN poetry config virtualenvs.create false
RUN poetry install --no-root --no-interaction --no-ansi

COPY . /lobby_service

EXPOSE 8000


FROM python:3.12.1-slim-bullseye AS prod

LABEL authors="yehor-vakhramieiev"

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY --from=builder requirements.prod.txt /app

RUN apt update -y && \
    apt install -y python3 \
    gcc \
    musl-dev && \
    pip install --upgrade pip && pip install --no-cache-dir -r requirements.prod.txt

COPY /app/ /app/

EXPOSE 8000