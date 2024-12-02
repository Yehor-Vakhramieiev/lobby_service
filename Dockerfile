FROM python:3.12.1-slim-bullseye AS builder

COPY pyproject.toml ./

RUN python -m pip install poetry==1.8.2 && \
    poetry export -o requirements.prod.txt --without-hashes && \
    poetry export --with=dev -o requirements.dev.txt --without-hashes && \
    pip install --upgrade pip


FROM python:3.12.1-slim-bullseye AS base

LABEL authors="yehor-vakhramieiev"

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt update -y && \
    apt install -y python3-dev \
    gcc \
    musl-dev


FROM base AS dev

COPY --from=builder requirements.dev.txt /app

RUN pip install --no-cache-dir -r requirements.dev.txt

COPY /app/ /app/

EXPOSE 8000


FROM base AS prod

COPY --from=builder requirements.prod.txt /app

RUN pip install --no-cache-dir -r requirements.prod.txt

COPY /app/ /app/

EXPOSE 8000