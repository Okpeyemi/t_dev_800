from starlette.applications import Starlette

from router import routes

app = Starlette(routes=routes)
