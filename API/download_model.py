import os
import gdown

def download_model():
    """
    Downloads the InceptionV3 model from Google Drive if it doesn't exist locally.
    """
    model_dir = "./model"
    model_path = os.path.join(model_dir, "model_inceptionV3.h5")
    
    # Create model directory if it doesn't exist
    if not os.path.exists(model_dir):
        os.makedirs(model_dir)
    
    # Check if model exists
    if not os.path.exists(model_path):
        print("Downloading model...")
        # Extract file ID from Google Drive link
        file_id = "1WrOml4YF2GOAcQpuBRlyY7LoBDF8w9hI"
        url = f"https://drive.google.com/uc?id={file_id}"
        gdown.download(url, model_path, quiet=False)
        print("Model downloaded successfully!")
    else:
        print("Model already exists locally.")

if __name__ == "__main__":
    download_model() 