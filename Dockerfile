# 1. Dùng Python 3.12 bản Slim (Rất nhẹ)
FROM python:3.12-slim

# Thiết lập thư mục làm việc
WORKDIR /app

# 2. Cài thư viện hệ thống cần thiết cho OpenCV
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Cài đặt PyTorch bản CPU (Quan trọng: Giúp giảm 4GB dung lượng)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 4. Copy và cài các thư viện còn lại
COPY requirements.txt .
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy toàn bộ code vào
COPY . .

# 6. Lệnh chạy Server (Dùng python trực tiếp để file server_api.py tự xử lý Port)
CMD ["python", "server_api.py"]