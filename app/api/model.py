import io
from PIL import Image
import onnxruntime as onnxrt
import numpy as np


class Model:
    def __init__(self):
        self.session = onnxrt.InferenceSession("models/pneumonia_model.onnx")
        self.input = self.session.get_inputs()[0]
        self.output = self.session.get_outputs()[0]

    def preprocess(self, image: bytes, image_size=(224, 224)) -> np.ndarray:
        image = Image.open(io.BytesIO(image)).convert("RGB")
        image = image.resize(image_size)
        array = np.array(image).astype(np.float32) / 255
        array = np.expand_dims(array, axis=0)
        return array

    def predict(self, image: bytes) -> str:
        # Preprocess the image
        # This is a placeholder. You need to implement the actual preprocessing.
        preprocessed_image = self.preprocess(image)

        # Run inference
        result = self.session.run(
            [self.output.name], {self.input.name: preprocessed_image}
        )

        return str(result[0][0][0])
