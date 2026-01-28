from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from groq import Groq
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)

# Inicializa o cliente Groq
api_key = os.environ.get("GROQ_API_KEY")
client = Groq(api_key=api_key) if api_key else None

@app.route('/')
def home():
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>Chat API</title>
        <style>
            body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
            #chat { border: 1px solid #ccc; padding: 20px; min-height: 200px; margin-bottom: 20px; }
            #input { width: 80%; padding: 10px; }
            button { padding: 10px 20px; }
            .msg { margin: 10px 0; padding: 10px; border-radius: 5px; }
            .user { background: #007bff; color: white; text-align: right; }
            .bot { background: #f1f1f1; }
        </style>
    </head>
    <body>
        <h1>Chat com IA</h1>
        <div id="chat"></div>
        <input type="text" id="input" placeholder="Digite sua mensagem...">
        <button onclick="send()">Enviar</button>
        <script>
            async function send() {
                const input = document.getElementById('input');
                const chat = document.getElementById('chat');
                const msg = input.value;
                if (!msg) return;
                
                chat.innerHTML += '<div class="msg user">' + msg + '</div>';
                input.value = '';
                
                try {
                    const res = await fetch('/chat', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify({message: msg})
                    });
                    const data = await res.json();
                    chat.innerHTML += '<div class="msg bot">' + (data.response || data.error) + '</div>';
                } catch(e) {
                    chat.innerHTML += '<div class="msg bot">Erro: ' + e.message + '</div>';
                }
                chat.scrollTop = chat.scrollHeight;
            }
            document.getElementById('input').addEventListener('keypress', e => { if(e.key === 'Enter') send(); });
        </script>
    </body>
    </html>
    '''

@app.route('/chat', methods=['POST'])
def chat():
    if not client:
        return jsonify({"error": "GROQ_API_KEY não configurada"}), 500
    
    data = request.json
    user_message = data.get('message', '')
    
    try:
        completion = client.chat.completions.create(
            model="llama3-8b-8192",
            messages=[{"role": "user", "content": user_message}]
        )
        return jsonify({"response": completion.choices[0].message.content})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
