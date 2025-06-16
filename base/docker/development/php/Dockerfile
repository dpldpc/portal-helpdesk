FROM php:8.4-fpm

# ARG USER_ID=1000
# ARG GROUP_ID=1000
ENV COMPOSER_CACHE_DIR=/tmp/composer
ENV NPM_CONFIG_CACHE=/tmp/npm-cache
ENV YARN_CACHE_FOLDER=/tmp/yarn-cache

ARG APP_NAME
ARG APP_HOST
ARG APP_PREFIX
ARG APP_URL_BASE
ARG APP_ENV
ARG APP_DEBUG
ARG HOST_ENV
ARG COMPOSER_PROJECT_DIR
ARG REDIS_HOST
ARG REDIS_PASSWORD
ARG REDIS_PORT
ARG DB_HOST
ARG DB_PORT
ARG DB_DATABASE
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_CONNECTION

ENV APP_NAME=${APP_NAME}
ENV APP_DEBUG=${APP_DEBUG}
ENV APP_HOST=${APP_HOST}
ENV APP_PREFIX=${APP_PREFIX}
ENV APP_URL_BASE=${APP_URL_BASE}
ENV APP_ENV=${APP_ENV}
ENV HOST_ENV=${HOST_ENV}
ENV COMPOSER_PROJECT_DIR=${COMPOSER_PROJECT_DIR}
ENV REDIS_HOST=${REDIS_HOST}
ENV REDIS_PASSWORD=${REDIS_PASSWORD}
ENV REDIS_PORT=${REDIS_PORT}
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_DATABASE=${DB_DATABASE}
ENV DB_USERNAME=${DB_USERNAME}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV DB_CONNECTION=${DB_CONNECTION}
ENV COMPOSER_ALLOW_SUPERUSER=1


# Instalar dependências e extensões PHP
# RUN apt-get update && apt-get install -y \
#     git \
#     curl \
#     libpng-dev \
#     libonig-dev \
#     libxml2-dev \
#     libzip-dev \
#     libicu-dev \
#     libmagickwand-dev \
#     libzstd-dev \
#     zip \
#     unzip \
#     gnupg \
#     && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
#     && apt-get install -y nodejs \
#     && npm install -g yarn \
#     && docker-php-ext-configure intl \
#     && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl opcache \
#     && pecl install imagick redis \
#     && docker-php-ext-enable imagick redis \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev libzip-dev libicu-dev \
    zip unzip gnupg bind9-dnsutils iputils-ping gettext-base util-linux jq && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    docker-php-ext-configure intl && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl opcache

# Timezone
RUN ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    echo "America/Sao_Paulo" > /etc/timezone

# ====================== #
#  Diretórios de Cache   #
# ====================== #
RUN mkdir -p ${NPM_CONFIG_CACHE} ${YARN_CACHE_FOLDER} ${COMPOSER_CACHE_DIR} 
RUN chown -R www-data:www-data ${NPM_CONFIG_CACHE} ${YARN_CACHE_FOLDER} ${COMPOSER_CACHE_DIR}


# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Novo padrão para Laravel
COPY ../stuff/.env.example /tmp/.env.example

# Adicionar entrypoint
COPY docker/${HOST_ENV}/php/entrypoint.sh /usr/local/bin/
COPY docker/${HOST_ENV}/php/configura_env.sh /usr/local/bin/
COPY docker/${HOST_ENV}/php/set_env.sh /usr/local/bin/
COPY docker/${HOST_ENV}/php/configura_tallstackui.sh /usr/local/bin/
COPY docker/${HOST_ENV}/php/installpackage.sh /usr/local/bin/
COPY docker/${HOST_ENV}/php/makepackage.sh /usr/local/bin/

RUN mkdir -p /var/stuff/pics
COPY ../stuff/laravel-favicon-animado.tar.gz /var/stuff/
COPY ../stuff/pics/* /var/stuff/pics/

RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/configura_env.sh /usr/local/bin/set_env.sh /usr/local/bin/configura_tallstackui.sh /usr/local/bin/installpackage.sh /usr/local/bin/makepackage.sh

# USER devuser
# RUN /usr/local/bin/set_env.sh

WORKDIR /var/www
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm"]
