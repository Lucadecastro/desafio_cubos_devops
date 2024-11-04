# Usa imagem base Node.js
FROM node:16

# Copia script e concede permissão de execução
COPY wait-for-it.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Instala o cliente do PostgreSQL
RUN apt-get update && apt-get install -y postgresql-client

# Cria diretório de trabalho
WORKDIR /app

# Copia o package.json e instala dependências
COPY . .
RUN npm install

# Expõe a porta definida
EXPOSE 8080

# Comando de inicialização do backend
CMD ["./wait-for-it.sh", "postgres:5432", "--", "node", "index.js"]