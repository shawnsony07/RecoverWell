from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import logging
import json
import ollama

app = Flask(__name__)
CORS(app)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def check_ollama():
    try:
        response = requests.get("http://localhost:11434/api/tags")
        return response.status_code == 200
    except:
        return False

@app.route("/health", methods=["GET"])
def health_check():
    ollama_running = check_ollama()
    if ollama_running:
        return jsonify({"status": "healthy", "ollama": "connected"})
    return jsonify({"status": "error", "message": "Ollama is not running"}), 503

@app.route("/chat", methods=["POST"])
def chat():
    logger.info("Received chat request")
    
    if not check_ollama():
        logger.error("Ollama is not running")
        return jsonify({"error": "Ollama is not running. Please start Ollama first."}), 503
    
    try:
        data = request.json
        message = data.get('content')
        logger.info(f"Message content: {message}")

        if not message:
            logger.error("No content provided")
            return jsonify({"error": "No content provided"}), 400

        # Send request to Ollama with updated format
        ollama_url = "http://localhost:11434/api/generate"
        payload = {
            'model': 'Sophie',
            'prompt': message,
            'system': 'You must respond in valid JSON format with a messages object containing a contents field. For example: {"messages": {"contents": "your response here"}}',
            'format': 'json',
            'stream': False
        }

        logger.info("Sending request to Ollama")
        response = requests.post(
            ollama_url, 
            json=payload,
            headers={'Content-Type': 'application/json'},
            timeout=120
        )
        
        logger.info(f"Ollama response status: {response.status_code}")
        logger.info(f"Ollama response content: {response.text[:200]}...")  # Log first 200 chars

        if response.status_code == 200:
            response_data = response.json()
            raw_response = response_data.get('response', '').strip()
            
            # Log the raw response for debugging
            logger.info(f"Raw response: {raw_response}")
            
            # Handle empty or whitespace-only responses
            if not raw_response or raw_response.isspace():
                return jsonify({"response": "I apologize, but I received an empty response. Please try again."})
            
            try:
                # Try to parse as JSON first
                if raw_response.startswith('{'):
                    message_content = json.loads(raw_response)
                    content = message_content.get('messages', {}).get('contents', '')
                else:
                    # If not JSON, use the raw response
                    content = raw_response
                
                # If we got an empty response after parsing, send a friendly message
                if not content or content.isspace():
                    content = "I apologize, but I received an empty response. Please try again."
                
                return jsonify({"response": content})
                
            except json.JSONDecodeError as e:
                logger.error(f"Failed to parse JSON response: {e}")
                # Return the raw response if JSON parsing fails
                return jsonify({"response": raw_response})
        else:
            logger.error(f"Ollama error: {response.status_code} - {response.text}")
            return jsonify({
                "error": "Failed to get response from Ollama",
                "details": response.text
            }), response.status_code

    except requests.exceptions.Timeout:
        logger.error("Request to Ollama timed out")
        return jsonify({"error": "Request to Ollama timed out"}), 504
    except Exception as e:
        logger.error(f"Server error: {str(e)}")
        return jsonify({"error": f"Server error: {str(e)}"}), 500

if __name__ == "__main__":
    logger.info("Starting server on port 8000...")
    if not check_ollama():
        logger.warning("WARNING: Ollama is not running! Please start Ollama first.")
    app.run(host="0.0.0.0", port=8000, debug=True)