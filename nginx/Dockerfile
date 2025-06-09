FROM nginx:1.23-alpine

ARG API_URL
ARG SSL_PATH
ARG SSL_STATUS

# Instalar openssl y generar certificados si SSL está activado
RUN if [ "$SSL_STATUS" = "with" ]; then \
    apk add --no-cache openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/server.key \
        -out /etc/nginx/ssl/server.crt \
        -subj "/CN=localhost" \
        -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"; \
fi

# Copiar plantilla de configuración adecuada
COPY ./templates/${SSL_STATUS}_ssl/default.conf.template /etc/nginx/templates/