#!/bin/bash
set -e # Sair se houver erro

# Cores para o output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}🚀 INICIANDO SCRIPT DE CORREÇÃO COMPLETA PARA RENDER 🚀${NC}"
echo -e "${BLUE}=====================================================${NC}"

# --- PASSO 1: LIMPEZA E REINSTALAÇÃO DO AMBIENTE ---
echo -e "\n${YELLOW}[1/5] Limpando e recriando o ambiente virtual...${NC}"
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
echo -e "${GREEN}✓ Ambiente virtual recriado.${NC}"

echo -e "\n${YELLOW}[2/5] Instalando dependências essenciais...${NC}"
pip install flask flask-cors groq python-dotenv gunicorn gevent
pip freeze > requirements.txt
echo -e "${GREEN}✓ Dependências instaladas e requirements.txt atualizado.${NC}"
echo "-------------------- requirements.txt --------------------"
cat requirements.txt
echo "--------------------------------------------------------"

# --- PASSO 2: CRIAR ARQUIVOS DE CONFIGURAÇÃO PARA RENDER ---
echo -e "\n${YELLOW}[3/5] Criando arquivos de configuração para Render (runtime.txt e Procfile)...${NC}"

# Especifica a versão do Python para o Render
echo "python-3.11.9" > runtime.txt
echo -e "${GREEN}✓ runtime.txt criado com a versão do Python.${NC}"

# Cria o Procfile, que é uma alternativa ao "Start Command" do Render
echo "web: gunicorn --worker-class gevent --bind 0.0.0.0:\$PORT app:app" > Procfile
echo -e "${GREEN}✓ Procfile criado com o comando de inicialização.${NC}"
echo "-------------------- Procfile --------------------"
cat Procfile
echo "------------------------------------------------"

# --- PASSO 3: VERIFICAR E SIMPLIFICAR app.py ---
# (Este script não modifica o app.py, mas você deve garantir que ele está correto)
echo -e "\n${YELLOW}[4/5] Verificando app.py (não será modificado)...${NC}"
if [ -f "app.py" ]; then
    echo -e "${GREEN}✓ app.py encontrado.${NC}"
    echo "Lembre-se: O app.py deve carregar a chave da API via os.environ.get('GROQ_API_KEY')"
else
    echo -e "${RED}ERRO: app.py não encontrado! Saindo.${NC}"
    exit 1
fi

# --- PASSO 4: ENVIAR TUDO PARA O GITHUB ---
echo -e "\n${YELLOW}[5/5] Preparando para enviar as correções para o GitHub...${NC}"
git add .
git commit -m "chore: Limpeza completa do projeto e configuração para Render"
echo "Executando 'git push'... Forneça suas credenciais se solicitado."
git push origin main

echo -e "\n${BLUE}=====================================================${NC}"
echo -e "${GREEN}✅ SCRIPT CONCLUÍDO! ✅${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo -e "Seu projeto foi limpo, configurado e enviado para o GitHub."
echo -e "Agora, vá para o dashboard do Render e faça um 'Manual Deploy' ou aguarde a implantação automática."
