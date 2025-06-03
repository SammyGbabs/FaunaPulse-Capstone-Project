# FaunaPulse API

Audio activity classification API using InceptionV3 model.

## Quick Start

1. Install dependencies:
```bash
pip install -r API/requirements.txt
```

2. Run the API:
```bash
uvicorn API.main:app --reload --host 0.0.0.0 --port 8000
```

The model will be automatically downloaded from Google Drive on first run.

## API Endpoints

- GET / - Welcome message
- POST /predict - Upload audio file for classification (WAV, MP3, OGG)

## Note
The model file (~100MB) is stored on Google Drive and downloaded automatically.
