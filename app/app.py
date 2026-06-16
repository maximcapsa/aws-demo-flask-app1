from flask import Flask, render_template, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    # Fetching environment variables to prove dynamic runtime configuration
    env_mode = os.environ.get('FLASK_ENV', 'Production')
    return render_template('index.html', env_mode=env_mode)

@app.route('/health')
def health_check():
    return jsonify({"status": "healthy", "code": 200})

if __name__ == '__main__':
    # Bind to 0.0.0.0 to ensure it is accessible outside the container
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)