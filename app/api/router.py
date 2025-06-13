from starlette.requests import Request
from starlette.responses import JSONResponse
from starlette.routing import Route
from starlette import status

import usecases


async def predict(request: Request):
    async with request.form(max_files=1) as form:
        try:
            image = form["scan"]
            prediction = await usecases.predict(image)
            return JSONResponse(prediction)
        except ValueError as e:
            return JSONResponse(e.args[0], status_code=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            msg = "Something goes wrong"
            print(msg, e)
            return JSONResponse(msg, status_code=status.HTTP_400_BAD_REQUEST)


async def annotate(request: Request):
    async with request.form(max_files=1) as form:
        try:
            image = form["scan"]
            diagnosis = form["diagnosis"]
            await usecases.annotate(image, diagnosis)
            return JSONResponse("Annotation enregistrée")
        except AttributeError:
            return JSONResponse(
                "Données incomplète. Veuillez fournir les champs : scan et diagnosis.",
                status_code=status.HTTP_400_BAD_REQUEST,
            )
        except ValueError as e:
            return JSONResponse(e.args[0], status_code=status.HTTP_400_BAD_REQUEST)


routes = [
    Route("/api/predict", endpoint=predict, methods=["POST"]),
    Route("/api/annotate", endpoint=annotate, methods=["POST"]),
]
