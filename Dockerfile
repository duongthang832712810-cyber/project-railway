# 1. Dùng Python 3.12 bản nhẹ
FROM python:3.12-slim

WORKDIR /app

# 2. Cài thư viện hệ thống (để chạy OpenCV)
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Cài PyTorch CPU (Quan trọng: Giảm dung lượng từ 5GB xuống 500MB)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 4. Cài các thư viện khác
COPY requirements.txt .
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy code vào
COPY . .

# 6. LỆNH CHẠY (FIX LỖI)
# Gọi thẳng python, để code python ở bước 1 tự xử lý Port
CMD ["python", "server_api.py"]