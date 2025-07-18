import sys
import os

# Add the parent directory to Python path for imports
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)
if parent_dir not in sys.path:
    sys.path.insert(0, parent_dir)

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

# Initialize FastAPI app
app = FastAPI(
    title="FaunaPulse API - Local Model",
    description="Audio Activity Classification API using local model",
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

# Loading the trained model from local directory
MODEL_PATH = os.path.join(os.path.dirname(__file__), "model", "model_InceptionV3_16.tflite")

try:
    # Load TensorFlow Lite model
    print(f"Loading model from: {MODEL_PATH}")
    interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
    interpreter.allocate_tensors()
    
    # Get input and output tensors
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    print(f"Model loaded successfully")
    print(f"Input details: {input_details}")
    print(f"Output details: {output_details}")
    
except Exception as e:
    print(f"Error loading model: {str(e)}")
    interpreter = None
    input_details = None
    output_details = None

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
    
    # Ensure the input matches TFLite model expectations
    # TFLite models typically expect float32 input
    img_array = img_array.astype(np.float32)
    return np.expand_dims(img_array, axis=0)

@app.get("/")
async def root():
    return {"message": "Welcome to FaunaPulse Audio Activity Classification API - Local TFLite Model Version"}

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    if interpreter is None:
        return {
            "status": "error",
            "message": "Model not loaded",
            "model_loaded": False
        }
    
    return {
        "status": "healthy", 
        "model_loaded": True,
        "input_shape": input_details[0]['shape'] if input_details else None,
        "output_shape": output_details[0]['shape'] if output_details else None,
        "model_path": MODEL_PATH
    }

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """Accepts an audio file, converts it to a Mel spectrogram, and predicts activity level"""
    if interpreter is None:
        raise HTTPException(status_code=500, detail="Model not loaded. Please check server logs.")
    
    if not file.filename.lower().endswith(('.wav', '.mp3', '.ogg')):
        raise HTTPException(status_code=400, detail="File must be an audio file (WAV, MP3, or OGG)")
    
    try:
        print(f"Processing file: {file.filename}")
        audio_bytes = await file.read()
        print(f"Audio file size: {len(audio_bytes)} bytes")
        
        img_array = audio_to_mel(audio_bytes)
        print(f"Mel spectrogram shape: {img_array.shape}")

        # Ensure input shape matches model expectations
        expected_shape = input_details[0]['shape']
        current_shape = img_array.shape
        
        print(f"Expected shape: {expected_shape}")
        print(f"Current shape: {current_shape}")
        
        # Convert shapes to tuples for comparison
        if tuple(img_array.shape) != tuple(expected_shape):
            # Reshape if needed
            print(f"Reshaping from {img_array.shape} to {expected_shape}")
            img_array = img_array.reshape(expected_shape)

        # Run inference with TFLite model
        print("Running inference...")
        interpreter.set_tensor(input_details[0]['index'], img_array)
        interpreter.invoke()
        predictions = interpreter.get_tensor(output_details[0]['index'])
        print(f"Raw predictions shape: {predictions.shape}")

        # Ensure we get a scalar value for comparison
        raw_confidence = float(predictions.flatten()[0])
        
        # Debug information
        print(f"Raw prediction shape: {predictions.shape}")
        print(f"Raw prediction value: {raw_confidence}")
        print(f"Raw prediction type: {type(raw_confidence)}")
        
        # If confidence is less than 0.5, it's "Low activity" with confidence (1 - raw_confidence)
        # If confidence is more than 0.5, it's "High activity" with confidence raw_confidence
        if raw_confidence > 0.5:
            confidence_value = raw_confidence
            predicted_class = "High activity"
        else:
            confidence_value = 1 - raw_confidence
            predicted_class = "Low activity"

        print(f"Prediction complete: {predicted_class} with {confidence_value:.2f} confidence")

        return {
            'filename': file.filename,
            'class': predicted_class,
            'confidence': f"{confidence_value * 100:.2f}%",  # Will always show the higher confidence
            'model_source': 'local_tflite',
            'input_shape': list(img_array.shape),
            'output_shape': list(predictions.shape),
            'raw_prediction': float(raw_confidence),
            'debug_info': {
                'expected_shape': list(expected_shape),
                'current_shape': list(current_shape),
                'prediction_shape': list(predictions.shape)
            }
        }
    
    except Exception as e:
        import traceback
        error_details = traceback.format_exc()
        print(f"Error details: {error_details}")
        raise HTTPException(status_code=500, detail=f"Error processing file: {str(e)}")

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    uvicorn.run(app, host="localhost", port=port, reload=True)
