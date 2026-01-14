# 1. Đổi sang Python 3.12 bản Slim (Nhẹ)
FROM python:3.12-slim

# Thiết lập thư mục làm việc
WORKDIR /app

# 2. Cài thư viện hệ thống (Python 3.12 slim rất sạch nên cần cài thêm cái này cho OpenCV)
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. QUAN TRỌNG: Cài PyTorch CPU (Bắt buộc để fix lỗi 8GB)
# Dù là Python 3.12 thì mặc định nó vẫn kéo bản GPU nặng 5GB về, nên dòng này cực quan trọng
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 4. Copy và cài các thư viện còn lại
COPY requirements.txt .
# Cài thêm setuptools vì Python 3.12 đã gỡ thư viện distutils mặc định
RUN pip install --no-cache-dir setuptools 
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy code vào
COPY . .

# 6. Chạy server
CMD ["python", "server_api.py"]