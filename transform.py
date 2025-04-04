import re
from os.path import basename
from dataclasses import dataclass

import numpy as np
import cv2


@dataclass
class XRAYScan:
    file: str
    detection: int  # 0 for normal, 1 for bacteria, 2 for virus


def load(file: str) -> XRAYScan:
    filename = basename(file)

    infectious_pattern = r"person(?P<person_id>\d+)_(?P<detection>bacteria|virus)_(?P<scan_id>\d+).jpeg"  # person1_bacteria_1.jpeg
    if re.match(infectious_pattern, filename):
        detection = re.search(infectious_pattern, filename).group("detection")
        scan = XRAYScan(file, 1 if detection == "bacteria" else 2)
    else:
        scan = XRAYScan(file, 0)

    return scan


def create_dataset(files: list[str]):
    features = []
    targets = []
    for file in files:
        scan = load(file)
        img = cv2.imread(scan.file, cv2.IMREAD_GRAYSCALE)
        features.append(cv2.resize(img, (1104, 760), interpolation=cv2.INTER_CUBIC))
        targets.append(scan.detection)

    np.savez_compressed(
        "datasets/processed/zoidberg.npz",
        features=features,
        targets=targets,
    )


def display_shapes(files: list[str]):
    for file in files:
        img = cv2.imread(file, cv2.IMREAD_GRAYSCALE)
        print(f"{file}: {img.shape}")
