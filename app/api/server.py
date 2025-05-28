from mimetypes import guess_type

from starlette.applications import Starlette
from starlette.requests import Request
from starlette.responses import JSONResponse
from starlette.routing import Route

from fs import FS
from model import Model

model = Model()


async def predict(request: Request):
    async with request.form(max_files=1) as form:
        try:
            mimetype, _ = guess_type(form["scan"].filename)
            if not mimetype or mimetype.split("/")[0] != "image":
                return JSONResponse(
                    {"scan": "You should submit an image file"}, status_code=400
                )
            scan = await form["scan"].read()
            return JSONResponse(model.predict(scan))
        except Exception as e:
            print(e)
            return JSONResponse({"scan": "You should submit a file"}, status_code=400)


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
