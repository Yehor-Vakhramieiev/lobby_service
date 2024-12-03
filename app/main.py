from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.responses import ORJSONResponse


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield


def create_app() -> FastAPI:
    app = FastAPI(
        title='lobby_service',
        docs_url='/api/docs',
        description='Lobby service to create rooms',
        debug=True,
        default_response_class=ORJSONResponse,
        lifespan=lifespan,
    )

    return app
