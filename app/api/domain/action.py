from datetime import datetime as dt
from dataclasses import dataclass


@dataclass
class Action:
    id: str
    kind: str
    diagnosis: str
    image_path: str
    timestamp: dt
    probability: float | None = None
