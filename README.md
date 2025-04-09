# ZOIDBERG 2.0

This repo contains utils to work on zoidberg 2.0 projects

## Features

- Transform images to matrix
- Automatic extraction of target from filename

## How to use it ?

1. Clone the repo

```bash
git clone https://github.com/EpitechMscProPromo2026/T-DEV-810-COT_3.git
```

2. Install the requirements

```bash
cd T-DEV-810-COT_3
pip install -r requirements.txt
```

### Transform images to matrix

```bash
./transform.py <path_to_image_dir> -o <output_filename>
```

Images in matrix are automatically resized to 1104x760

### Read matrix from file

```python
from utils import read_dataset

>>> dataset = read_dataset('<path_to_file>')

>>> dataset["targets"]
>>> dataset["features"]
>>> dataset.close()
```

**DON'T FORGET TO CLOSE DATASET AFTER USE**
