from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

@app.route('/api/hello', methods=['GET'])
def hello_world():
    return jsonify({
        'message': 'Hello World from Python Backend!',
        'status': 'success'
    })

@app.route('/api/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'healthy',
        'service': 'Python Flask Backend'
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)