#!/bin/bash

# Atualizar sistema
sudo apt-get update

# Aguardar Docker inicializar
sleep 10

# Criar aplicação temporária para demonstração
mkdir -p /tmp/app/public
cat > /tmp/app/package.json << 'EOF'
{
  "name": "devops-app-gcp",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": { "start": "node server.js" },
  "dependencies": { "express": "^4.18.2" }
}
EOF

cat > /tmp/app/server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static('public'));

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/api/info', (req, res) => {
  res.json({
    app: 'DevOps App GCP',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    instance: process.env.HOSTNAME || 'localhost'
  });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
EOF

cat > /tmp/app/public/index.html << 'EOF'

DevOps App - GCP

DevOps App rodando no GCP!
Aplicação containerizada em VM do Google Compute Engine
Health Check | Info API

EOF

# Build da imagem
cd /tmp/app
sudo docker build -t devops-app-gcp:v1.0 .

# Executar container
sudo docker run -d \
  --name devops-app \
  --restart unless-stopped \
  -p 80:3000 \
  -p 3000:3000 \
  devops-app-gcp:v1.0

echo "Aplicação iniciada em $(date)" | sudo tee -a /var/log/app-startup.log