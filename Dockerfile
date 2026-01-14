# 1. Python 3.12 Slim
FROM python:3.12-slim

WORKDIR /app

# 2. Cài thư viện hệ thống
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Cài PyTorch CPU (Fix lỗi đầy bộ nhớ)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 4. Cài thư viện Python
COPY requirements.txt .
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy code
COPY . .

# 6. LỆNH CHẠY (QUAN TRỌNG NHẤT)
# Chúng ta gọi python chạy file .py, để file .py tự lo vụ Port
CMD ["python", "server_api.py"]