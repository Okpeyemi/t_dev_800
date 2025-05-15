from starlette.applications import Starlette
from starlette.responses import JSONResponse
from starlette.routing import Route


async def predict(request):
    return JSONResponse({"prediction": 1})


routes = [
    Route("/predict", endpoint=predict, methods=["POST"]),
]
app = Starlette(routes=routes)
