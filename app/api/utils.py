from mimetypes import guess_type


def is_image(filename: str) -> bool:
    mimetype, _ = guess_type(filename)
    return mimetype and mimetype.split("/")[0] == "image"
