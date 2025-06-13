from starlette.datastructures import UploadFile

from constants import ALLOWED_DIAGNOSIS
from utils import is_image
from fs import FS
from model import Model


model = Model()


async def predict(image: UploadFile):
    if not is_image(image.filename):
        raise ValueError({"scan": "You should submit an image file"})
    return model.predict(await image.read())


async def annotate(image: UploadFile, diagnosis: str):
    if diagnosis not in ALLOWED_DIAGNOSIS:
        raise ValueError("Invalid diagnosis")
    if not is_image(image.filename):
        raise ValueError("You should submit an image for annotation")
    ext = image.filename.split(".")[-1]
    await FS.save(await image.read(), diagnosis, ext)
