#!/usr/bin/env python

import logging
import os
import re
from os.path import basename
from dataclasses import dataclass
import argparse

import numpy as np
import h5py
import cv2
from tqdm import tqdm

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s"
)
logger = logging.getLogger(__name__)


@dataclass
class XRAYScan:
    file: str
    detection: int  # 0 for normal, 1 for bacteria, 2 for virus


def load(file: str) -> XRAYScan:
    filename = basename(file)
    detection = get_detection(filename)
    return XRAYScan(file, detection)


def get_detection(filename: str) -> int:
    infectious_pattern = r"person(?P<person_id>\d+)_(?P<detection>bacteria|virus)_(?P<scan_id>\d+).jpeg"  # person1_bacteria_1.jpeg
    if re.match(infectious_pattern, filename):
        detection = re.search(infectious_pattern, filename).group("detection")
        detection = 1 if detection == "bacteria" else 2
    else:
        detection = 0

    return detection


def create_dataset(files: list[str], output: str):
    features = []
    targets = []
    logger.info("Extraction of features and targets from %d files", len(files))
    for file in tqdm(files):
        scan = load(file)
        img = cv2.imread(scan.file, cv2.IMREAD_GRAYSCALE)
        features.append(cv2.resize(img, (1104, 760), interpolation=cv2.INTER_CUBIC))
        targets.append(scan.detection)

    logger.info("Saving dataset to %s", output)

    features = np.array(features)
    targets = np.array(targets)

    with h5py.File(output, "w") as stream:
        stream.create_dataset("features", data=features)
        stream.create_dataset("targets", data=targets)
    logger.info("Process completed !")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create dataset from x-ray scans")
    parser.add_argument("dir", type=str, help="Directory containing x-ray scans")
    parser.add_argument(
        "--output",
        "-o",
        type=str,
        help="Output file name",
    )

    args = parser.parse_args()
    files = os.listdir(args.dir)
    files = [os.path.join(args.dir, file) for file in files]

    create_dataset(files, args.output)
