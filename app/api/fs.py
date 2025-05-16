import os
import secrets
import string
from enum import Enum
from datetime import datetime
from pathlib import Path
from typing import Generator


class Prediction(str, Enum):
    NORMAL = "normal"
    PNEUMONIA = "pneumonia"


class FileSystem:
    def __init__(self, root: str):
        self.root = Path(root).expanduser()
        inference_dir = self.root.joinpath("inference")
        inference_dir.mkdir(exist_ok=True)
        for prediction in Prediction:
            inference_dir.joinpath(prediction).mkdir(exist_ok=True)

    async def save(self, content: bytes, prediction: str, ext: str):
        filename = self.get_unique_filename() + "." + ext
        to = self.root.joinpath("inference", Prediction(prediction), filename)
        await self.write(content, to)

    async def write(self, content: bytes, to: Path):
        with to.open("wb") as stream:
            stream.write(content)

    def read(self, path: Path) -> Generator[bytes]:
        chunk_size = 8 * 1024
        with path.open("rb") as stream:
            while chunk := stream.read(chunk_size):
                yield chunk

    def get_unique_filename(self):
        hash = "".join(secrets.choice(string.ascii_lowercase) for _ in range(24))
        timestamp = datetime.now().replace(microsecond=0).isoformat()
        return f"{hash}_{timestamp}"


FS = FileSystem(os.getenv("AHOUEFA_DIR", "/tmp"))
