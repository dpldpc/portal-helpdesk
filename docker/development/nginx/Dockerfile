FROM nginx:alpine

ARG APP_HOST
ARG APP_NAME
ARG HOST_ENV

RUN apk add --no-cache bash
# Instale o OpenSSL
RUN apk add --no-cache openssl
RUN apk add --no-cache tzdata

ENV TZ=America/Sao_Paulo
# Crie o diretório para os certificados
# RUN mkdir -p /etc/nginx/ssl

# Gere o certificado SSL
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
#     -keyout /etc/nginx/ssl/certificado.${APP_HOST}.key -out /etc/nginx/ssl/certificado.${APP_HOST}.crt \
#     -subj "/C=BR/ST=Estado/L=Cidade/O=Empresa/OU=Setor/CN=${APP_HOST}" \
#     -addext "subjectAltName = DNS:www.${APP_HOST},DNS:${APP_HOST}"

# Copie os arquivos de configuração
# COPY ./nginx/default.template.conf /etc/nginx/templates/default.template.conf
# COPY ./nginx/10-envsubst-on-templates.sh /docker-entrypoint.d/10-envsubst-on-templates.sh