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

# Tambahkan pemeriksaan model
RUN python -c "import pickle; import os; print('Checking if model files exist:'); \
    print(f'naive_bayes_model.pkl: {os.path.exists(\"model/naive_bayes_model.pkl\")}'); \
    print(f'vectorizer.pkl: {os.path.exists(\"model/vectorizer.pkl\")}'); \
    try: \
        with open('model/naive_bayes_model.pkl', 'rb') as f: model = pickle.load(f); print('Model loaded successfully'); \
        with open('model/vectorizer.pkl', 'rb') as f: vec = pickle.load(f); print('Vectorizer loaded successfully'); \
    except Exception as e: print(f'Error loading model: {e}')"

ENV PATH="/opt/venv/bin:$PATH"

CMD ["gunicorn", "app:app"]