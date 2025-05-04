FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc build-essential && \
    python -m venv --copies /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --prefer-binary -r requirements.txt && \
    apt-get purge -y --auto-remove gcc build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY . .

ENV PATH="/opt/venv/bin:$PATH"

CMD ["gunicorn", "app:app"]