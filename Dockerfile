FROM python:3.10-slim

WORKDIR /app

# Install system dependencies (for Playwright + audio libs)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    ca-certificates \
    # Playwright / Chromium deps (Debian versions)
    libdbus-1-3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libnss3 \
    libxshmfence1 \
    libu2f-udev \
    fonts-unifont \
    # Missing Playwright libs shown in error
    libxfixes3 \
    libpango-1.0-0 \
    libcairo2 \
    # audio libs (soundfile)
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browser
RUN playwright install chromium

# Copy application
COPY app.py .

# Expose port
EXPOSE 7860

ENV FLASK_APP=app.py
ENV PORT=7860

CMD ["python", "app.py"]
