import h5py


def read_dataset(file: str):
    stream = h5py.File(file, "r")
    return stream
