from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
import re
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the model and vectorizer
model = pickle.load(open('model/naive_bayes_model.pkl', 'rb'))
vectorizer = pickle.load(open('model/vectorizer.pkl', 'rb'))

# Preprocessing function
def preprocess_text(text):
    # Convert to lowercase
    text = text.lower()
    # Remove special characters and digits
    text = re.sub(r'[^\w\s]', ' ', text)
    text = re.sub(r'\d+', ' ', text)
    # Remove extra spaces
    text = re.sub(r'\s+', ' ', text).strip()
    return text

@app.route('/detect', methods=['POST'])
def detect_gambling():
    data = request.json
    title = data.get('title', '')
    
    if not title:
        return jsonify({'error': 'No title provided'}), 400
    
    # Preprocess the title
    processed_title = preprocess_text(title)
    
    # Transform using the vectorizer
    title_vector = vectorizer.transform([processed_title])
    
    # Make prediction
    prediction = model.predict(title_vector)[0]
    probability = model.predict_proba(title_vector)[0]
    
    # Return the prediction
    return jsonify({
        'title': title,
        'is_gambling': bool(prediction),
        'confidence': float(probability[1])  # Probability of being gambling content
    })

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
