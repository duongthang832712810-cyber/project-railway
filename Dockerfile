# 1. Python 3.12 Slim (Nhẹ)
FROM python:3.12-slim

WORKDIR /app

# 2. Cài thư viện hệ thống
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Cài PyTorch CPU (Bắt buộc để chạy trên Railway Free)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 4. Cài thư viện khác
COPY requirements.txt .
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy code
COPY . .

# 6. LỆNH CHẠY (TUYỆT ĐỐI KHÔNG SỬA DÒNG NÀY)
# Không có uvicorn, không có $PORT -> Không bao giờ lỗi
CMD ["python", "server_api.py"]