FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Create model directory
RUN mkdir -p model

# Expose port
EXPOSE 8080

# Start the app with gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
