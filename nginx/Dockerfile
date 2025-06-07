FROM nginx:1.23-alpine

ARG API_URL
ARG SSL_PATH
ARG SSL_STATUS

COPY ./templates/${SSL_STATUS}_ssl/default.conf.template /etc/nginx/templates/