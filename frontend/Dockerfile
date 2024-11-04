FROM nginx:alpine

# Remove o arquivo de configuração padrão para evitar conflitos
RUN rm /etc/nginx/conf.d/default.conf

# Copia o HTML e o arquivo nginx
COPY index.html /usr/share/nginx/html/index.html

COPY nginx.conf /etc/nginx/nginx.conf

# Expõe a porta do front
EXPOSE 80