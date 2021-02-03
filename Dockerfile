FROM php:7.4.14-cli

RUN apt-get update && apt-get install -y \
        unzip \
        zip \
        libicu-dev \
        libzip-dev \
    && docker-php-ext-enable opcache \
    && docker-php-ext-install intl \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip \
    && rm -rf /var/lib/apt/lists/*

RUN echo "memory_limit = -1;" > $PHP_INI_DIR/conf.d/memory_limit.ini \
    && echo "date.timezone = UTC;" >> $PHP_INI_DIR/conf.d/timezone.ini

# https://symfony.com/doc/current/performance.html
RUN echo "opcache.memory_consumption=256;" >> $PHP_INI_DIR/conf.d/opcache.ini \
    && echo "opcache.max_accelerated_files=20000;" >> $PHP_INI_DIR/conf.d/opcache.ini \
    && echo "realpath_cache_size=4096K;" >> $PHP_INI_DIR/conf.d/realpath-cache.ini \
    && echo "realpath_cache_ttl=600;" >> $PHP_INI_DIR/conf.d/realpath-cache.ini

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --1

# NodeJS 14 + yarn
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash \
    && apt-get install -y nodejs --no-install-recommends \
    && npm install -g yarn@1.22.5 \
    && npm cache clean --force \
    && rm -rf /var/lib/apt/lists/*
