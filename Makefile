DC = docker compose
D = docker
APP_DEV = docker_compose/docker-compose.dev.yml
APP = /docker_compose/docker-compose.yml
ENV = --env-file .env
APP_CONTAINER = app
FILE_POETRY_CONTAINER = /lobby_service/poetry.lock
FILE_PYPROJECT_CONTAINER = /lobby_service/pyproject.toml
LOGS = docker logs


.PHONY: app-dev app-down app-logs update-deps

app-dev:
	${DC} -f ${APP_DEV} ${ENV} up --build -d

app-down:
	${DC} -f ${APP_DEV} ${ENV} down

app-logs:
	${D} logs ${APP_CONTAINER} -f

update-deps: app-dev
	${DC} -f ${APP_DEV} cp ${APP_CONTAINER}:${FILE_POETRY_CONTAINER} . && ${DC} cp ${APP_CONTAINER}:${FILE_PYPROJECT_CONTAINER} .
