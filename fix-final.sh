#!/bin/bash

echo "🔧 Corrigindo o projeto para Render..."

# 1. Criar requirements.txt SEM gevent
cat > requirements.txt << 'EOF'
flask==3.0.0
flask-cors==4.0.0
groq==0.4.2
python-dotenv==1.0.0
gunicorn==21.2.0
EOF
echo "✓ requirements.txt criado (sem gevent)"

# 2. Criar runtime.txt com Python 3.11
echo "python-3.11.9" > runtime.txt
echo "✓ runtime.txt criado (Python 3.11.9)"

# 3. Criar Procfile SEM gevent worker
echo 'web: gunicorn --bind 0.0.0.0:$PORT app:app' > Procfile
echo "✓ Procfile criado (sem --worker-class gevent)"

# 4. Enviar para GitHub
git add -A
git commit -m "fix: Remove gevent para compatibilidade com Render"
echo "Enviando para GitHub..."
git push origin main --force

echo ""
echo "✅ CORREÇÃO APLICADA!"
echo ""
echo "Agora vá ao Render e:"
echo "1. Clique em 'Manual Deploy' -> 'Deploy latest commit'"
echo "2. Aguarde o deploy ficar 'Live'"
