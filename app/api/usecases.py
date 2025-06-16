from datetime import datetime as dt

from starlette.datastructures import UploadFile

from constants import ALLOWED_DIAGNOSIS
from utils import is_image
from fs import FS
from domain.model import Model
from domain.action import Action
from db import repository


model = Model()


async def predict(image: UploadFile):
    if not is_image(image.filename):
        raise ValueError({"scan": "You should submit an image file"})
    image_content = await image.read()
    probability = model.predict(image_content)
    diagnosis = "PNEUMONIA" if probability > 0.5 else "NORMAL"
    filepath = await FS.save(
        image_content, "inference", diagnosis, image.filename.split(".")[-1]
    )
    repository.insert_action(
        Action(
            id=repository.next_id(),
            kind="predict",
            diagnosis=diagnosis,
            image_path=filepath,
            probability=probability,
            timestamp=dt.now(),
        )
    )
    return {
        "probability": probability,
        "diagnosis": diagnosis,
        "file_path": filepath,
    }


async def annotate(image: UploadFile, diagnosis: str):
    if diagnosis not in ALLOWED_DIAGNOSIS:
        raise ValueError("Invalid diagnosis")
    if not is_image(image.filename):
        raise ValueError("You should submit an image for annotation")
    ext = image.filename.split(".")[-1]
    filepath = await FS.save(await image.read(), "annotation", diagnosis, ext)
    repository.insert_action(
        Action(
            id=repository.next_id(),
            kind="annotate",
            diagnosis=diagnosis,
            image_path=filepath,
            timestamp=dt.now(),
        )
    )


def list_actions():
    return [
        {
            "id": action.id,
            "kind": action.kind,
            "diagnosis": action.diagnosis,
            "image_path": action.image_path,
            "probability": action.probability,
            "timestamp": action.timestamp,
        }
        for action in repository.get_actions()
    ]
