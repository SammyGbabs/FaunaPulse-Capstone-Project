from fastapi import FastAPI, File, UploadFile, HTTPException
import uvicorn
import numpy as np
import librosa
import librosa.display
import tensorflow as tf
import io
import matplotlib.pyplot as plt
from PIL import Image
from fastapi.middleware.cors import CORSMiddleware
from .download_model import download_model

# Initialize FastAPI app
app = FastAPI(
    title="FaunaPulse API",
    description="Audio Activity Classification API",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Download model if not exists
download_model()

# Loading the trained model
MODEL = tf.keras.models.load_model("./model/model_inceptionV3.h5")

# Class names (High activity or Low activity)
CLASS_NAMES = ["High activity", "Low activity"]

def audio_to_mel(audio_bytes):
    """Converting uploaded audio file to a Mel spectrogram image"""
    y, sr = librosa.load(io.BytesIO(audio_bytes), sr=None)
    S = librosa.feature.melspectrogram(y=y, sr=sr, n_fft=1024, hop_length=320, n_mels=64)
    S_db = librosa.power_to_db(S, ref=np.max)

    # Converting to an image
    fig, ax = plt.subplots(figsize=(6, 6))
    librosa.display.specshow(S_db, sr=sr, hop_length=320, x_axis="time", y_axis="log")
    plt.axis("off")
    plt.tight_layout()

    # Saving to buffer
    buf = io.BytesIO()
    plt.savefig(buf, format="png")
    plt.close(fig)

    # Converting to NumPy array for model input
    buf.seek(0)
    img = Image.open(buf).convert("RGB")
    img = img.resize((256, 256))
    img_array = np.array(img) / 255.0
    return np.expand_dims(img_array, axis=0)

@app.get("/")
async def root():
    return {"message": "Welcome to FaunaPulse Audio Activity Classification API"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """Accepts an audio file, converts it to a Mel spectrogram, and predicts activity level"""
    if not file.filename.lower().endswith(('.wav', '.mp3', '.ogg')):
        raise HTTPException(status_code=400, detail="File must be an audio file (WAV, MP3, or OGG)")
    
    try:
        audio_bytes = await file.read()
        img_array = audio_to_mel(audio_bytes)

        predictions = MODEL.predict(img_array)
        raw_confidence = float(predictions[0])
        # If confidence is less than 0.5, it's "Low activity" with confidence (1 - raw_confidence)
        # If confidence is more than 0.5, it's "High activity" with confidence raw_confidence
        confidence_value = raw_confidence if raw_confidence > 0.5 else (1 - raw_confidence)
        predicted_class = "High activity" if raw_confidence > 0.5 else "Low activity"

        return {
            'filename': file.filename,
            'class': predicted_class,
            'confidence': f"{confidence_value * 100:.2f}%"  # Will always show the higher confidence
        }
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing file: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000, reload=True)
