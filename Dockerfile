# ModelScope Docker Studio runtime for Infinite Canvas.
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=7860 \
    INFINITE_CANVAS_RUNTIME_DIR=/mnt/workspace

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . ./

# ModelScope keeps /mnt/workspace between container restarts.  This is where
# local passwords, canvas data, uploads, generated images and API settings go.
RUN mkdir -p /mnt/workspace/API /mnt/workspace/data /mnt/workspace/assets /mnt/workspace/output

EXPOSE 7860

CMD ["python", "main.py"]
