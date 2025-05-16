from starlette.applications import Starlette
from starlette.requests import Request
from starlette.responses import JSONResponse
from starlette.routing import Route

from fs import FS


async def predict():
    return JSONResponse({"prediction": 1})


async def upload(request: Request):
    async with request.form(max_files=4) as form:
        try:
            scan = form["scan"]
            ext = scan.filename.split(".")[-1]
            prediction = form["prediction"]
        except ValueError as e:
            return JSONResponse({"prediction": str(e)}, status_code=400)
        except AttributeError:
            return JSONResponse({"scan": "You should submit a file"}, status_code=400)
        else:
            await FS.save(await scan.read(), prediction, ext)
    return JSONResponse({"message": "File uploaded successfully"})


routes = [
    Route("/predict", endpoint=predict, methods=["POST"]),
    Route("/upload", endpoint=upload, methods=["POST"]),
]
app = Starlette(routes=routes)
