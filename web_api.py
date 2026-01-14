from fastapi import FastAPI, File, UploadFile
from ultralytics import YOLO
from PIL import Image
import io
import asyncio
import os
import uvicorn

# ================= CẤU HÌNH =================
MODEL_PATH = "yolov8n1200.pt"  # Đảm bảo tên file model đúng y hệt
app = FastAPI()

# 1. Load Model
print("🚀 Đang tải model YOLO...")
try:
    model = YOLO(MODEL_PATH)
    print("✅ Model đã tải xong!")
except Exception as e:
    print(f"❌ Lỗi tải model: {e}")
    model = None 

# Khóa để xử lý lần lượt (tránh quá tải RAM)
model_lock = asyncio.Lock()

@app.get("/")
def home():
    return {"message": "Hello World! Server đang chạy ngon lành 🚀"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if not model:
        return {"status": "error", "message": "Model chưa tải được (kiểm tra lại file .pt)"}

    try:
        # Đọc ảnh
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes))

        # Xử lý tuần tự (xếp hàng)
        async with model_lock:
            results = model.predict(image, conf=0.5, verbose=False)
            
            # Lấy kết quả
            result = results[0]
            boxes = result.boxes
            
            detected_text = ""
            if len(boxes) > 0:
                # Sắp xếp từ trái qua phải
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

# --- PHẦN SỬA LỖI PORT ---
if __name__ == "__main__":
    # Tự động lấy PORT từ Railway, nếu chạy máy mình thì lấy 8000
    port = int(os.environ.get("PORT", 8000))
    print(f"🚀 Server starting on port: {port}")
    uvicorn.run(app, host="0.0.0.0", port=port)