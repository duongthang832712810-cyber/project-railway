# Dùng Python 3.12 Slim (Nhẹ)
FROM python:3.12-slim

WORKDIR /app

# Cài thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Cài PyTorch CPU (Tránh lỗi đầy bộ nhớ)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Cài thư viện dự án
COPY requirements.txt .
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir -r requirements.txt

# Copy code
COPY . .

# --- DÒNG QUAN TRỌNG NHẤT ---
# Chỉ chạy python file, để file python tự xử lý port
CMD ["python", "server_api.py"]