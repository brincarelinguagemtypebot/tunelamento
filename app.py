from flask import Flask, request, jsonify, render_template
from flask_cors import CORS  # <--- ADD ISSO
import os
from groq import Groq
from dotenv import load_dotenv

# Carregar variáveis de ambiente
load_dotenv()

app = Flask(__name__, template_folder='.') # template_folder='.' diz para procurar o index.html na mesma pasta
CORS(app)  # <--- ADD ISSO (Habilita conexões externas/locais sem bloqueio)

# Verifica se a chave existe
api_key = os.environ.get("GROQ_API_KEY")
if not api_key:
    print("ERRO: GROQ_API_KEY não encontrada no arquivo .env")

client = Groq(api_key=api_key)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/chat', methods=['POST']) # Verifique se a rota aqui bate com a do seu javascript (ex: /chat ou /api/chat)
def chat():
    data = request.json
    user_input = data.get('message')
    
    try:
        completion = client.chat.completions.create(
            model="llama3-8b-8192",
            messages=[
                {"role": "user", "content": user_input}
            ],
            temperature=1,
            max_tokens=1024,
            top_p=1,
            stream=False,
            stop=None,
        )
        return jsonify({"response": completion.choices[0].message.content})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
