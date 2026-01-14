FROM python:3.12-slim

WORKDIR /app

# Cài thư viện hệ thống
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# Cài PyTorch CPU (Bắt buộc)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Cài thư viện
COPY requirements.txt .
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir -r requirements.txt

# Copy code
COPY . .

# Mở cổng 8000
EXPOSE 8000

# Chạy python (Nó sẽ chạy port 8000 như code trên)
CMD ["python", "server_api.py"]