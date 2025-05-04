FROM python:3.10-slim

WORKDIR /app

# Copy requirements terlebih dahulu
COPY requirements.txt .

# Update dan install dependencies sistem
RUN apt-get update
RUN apt-get install -y --no-install-recommends gcc build-essential python3-distutils

# Setup virtual environment dan upgrade pip
RUN python -m venv --copies /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip setuptools wheel

# Install packages satu per satu untuk debug
RUN pip install flask==2.3.2
RUN pip install flask-cors==4.0.0
RUN pip install numpy==1.25.2
RUN pip install scipy==1.11.2
RUN pip install joblib==1.3.2
RUN pip install scikit-learn==1.3.0
RUN pip install gunicorn==21.2.0

# Copy aplikasi
COPY . .

# Clean up
RUN apt-get purge -y --auto-remove gcc build-essential
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Command untuk menjalankan aplikasi
CMD ["gunicorn", "app:app"]