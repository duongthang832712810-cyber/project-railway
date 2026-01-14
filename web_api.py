from fastapi import FastAPI, File, UploadFile
from ultralytics import YOLO
from PIL import Image
import io
import asyncio
import uvicorn

# ================= CẤU HÌNH =================
MODEL_PATH = "yolov8n1200.pt" 
app = FastAPI()

# Load Model
print("🚀 Đang tải model YOLO...")
try:
    model = YOLO(MODEL_PATH)
    print("✅ Model đã tải xong!")
except Exception as e:
    print(f"❌ Lỗi tải model: {e}")
    model = None 

model_lock = asyncio.Lock()

@app.get("/")
def home():
    return {"message": "Server 8000 is running!"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if not model:
        return {"status": "error", "message": "Model error"}
    try:
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes))
        async with model_lock:
            results = model.predict(image, conf=0.5, verbose=False)
            result = results[0]
            boxes = result.boxes
            detected_text = ""
            if len(boxes) > 0:
                box_list = boxes.data.tolist()
                box_list.sort(key=lambda x: x[0])
                temp_list = []
                for box in box_list:
                    cls_id = int(box[5])
                    class_name = model.names[cls_id]
                    temp_list.append(class_name)
                detected_text = "".join(temp_list)
        return {"status": "success", "number": detected_text}
    except Exception as e:
        return {"status": "error", "message": str(e), "number": None}

# --- CỐ ĐỊNH PORT 8000 ---
if __name__ == "__main__":
    print("🚀 SERVER ĐANG CHẠY CỐ ĐỊNH Ở PORT 8000")
    # Hardcode cứng 8000 tại đây
    uvicorn.run(app, host="0.0.0.0", port=8000)