from starlette.applications import Starlette

from db import repository
from router import routes


async def lifespan(app):
    repository.create_tables()
    yield
    print("Application shutdown: closing database connection.")


app = Starlette(routes=routes, lifespan=lifespan)
