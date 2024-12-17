FROM php:8.3.14-fpm-alpine

ENV TZ=UTC

# Set timezone and add the PHP extension installer
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apk add --no-cache curl && \
    curl -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions && \
    chmod +x /usr/local/bin/install-php-extensions

# Update and install dependencies
RUN apk update && apk upgrade && \
    apk add --no-cache \
        mariadb-client \
        ca-certificates \
        postgresql-dev \
        libssh-dev \
        zip \
        libzip-dev \
        libxml2-dev \
        jpegoptim \
        optipng \
        pngquant \
        gifsicle \
        libxslt-dev \
        rabbitmq-c-dev \
        icu-dev \
        oniguruma-dev \
        gmp-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        jpeg-dev \
        libwebp-dev \
        supervisor \
        bash \
        unzip \
        git \
        dcron \
        linux-headers

# Install PHP extensions
RUN install-php-extensions zip opcache pdo_mysql pdo_pgsql mysqli bcmath sockets xsl exif intl gmp pcntl redis gd

# Install and enable xdebug
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    apk del -f .build-deps

WORKDIR /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]