FROM php:8.4-apache

LABEL maintainer="Alexey Mikhaltsov <lexxvlad@gmail.com>"

RUN apt-get update && apt-get upgrade -y 
RUN apt-get install -y g++ 
RUN apt-get install -y libbz2-dev \
    libc-client-dev \
    libcurl4-gnutls-dev \
    libedit-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libkrb5-dev \
    libldap2-dev \
    libldb-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libpq-dev \
    libsqlite3-dev \
    libssl-dev \
    libreadline-dev \
    libxslt1-dev \
    libzip-dev \
    memcached \
    wget \
    unzip \
    zlib1g-dev 
RUN docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    calendar \
    exif \
    gettext \
    mysqli \
    opcache \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    soap \
    xsl 
RUN docker-php-ext-configure gd --with-freetype --with-jpeg 
RUN docker-php-ext-install -j$(nproc) gd  
RUN docker-php-ext-configure intl 
RUN docker-php-ext-install -j$(nproc) intl 
RUN docker-php-ext-configure ldap 
RUN docker-php-ext-install ldap 
RUN docker-php-ext-configure zip 
RUN docker-php-ext-install zip \
    && CFLAGS="$CFLAGS -D_GNU_SOURCE" docker-php-ext-install sockets 
RUN pecl install xmlrpc-1.0.0RC3 && docker-php-ext-enable xmlrpc 
RUN pecl install imap && docker-php-ext-enable imap 
RUN pecl install xdebug && docker-php-ext-enable xdebug 
RUN pecl install memcached && docker-php-ext-enable memcached 
RUN pecl install mongodb && docker-php-ext-enable mongodb 
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN install-php-extensions imagick
RUN pecl install grpc && docker-php-ext-enable grpc
RUN install-php-extensions protobuf
RUN curl -sSk https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && chmod +x /usr/local/bin/composer
#RUN pecl install protobuf && docker-php-ext-enable protobuf
RUN docker-php-source delete \
    && apt-get remove -y g++ wget 
RUN apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*
ADD xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
ADD php.ini /usr/local/etc/php/conf.d/php.ini
RUN a2enmod rewrite
RUN a2enmod actions 
