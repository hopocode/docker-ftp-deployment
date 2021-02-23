FROM php:7.1-cli
RUN apt-get update
# RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++ \
#   && apt-get install -y git \
#   && a2enmod rewrite \
#   && docker-php-ext-configure intl \
#   && docker-php-ext-install intl \
#   && apt-get install -y \
#   libfreetype6-dev \
#   libjpeg62-turbo-dev \
#   && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#   && docker-php-ext-install -j$(nproc) gd

# PHP extensiin SSH2
# install dependencies 
RUN apt-get update && apt-get install -y \
    ssh \
    libssh2-1 \
    libssh2-1-dev \
    wget \
    libssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ssh2 extension
RUN wget -O libssh2.tar.gz https://www.libssh2.org/download/libssh2-1.8.1.tar.gz \
    && wget -O ssh2.tgz https://pecl.php.net/get/ssh2-1.1.2.tgz \
    && mkdir libssh2 && tar vxzf libssh2.tar.gz -C libssh2 --strip-components 1 \
    && mkdir ssh2 && tar vxzf ssh2.tgz -C ssh2 --strip-components 1 \
    && cd libssh2 && ./configure \
    && make && make install \
    && cd ../ssh2 && phpize && ./configure --with-ssh2 \
    && make && make install \
    && echo "extension=ssh2.so" >> /usr/local/etc/php/conf.d/ssh2.ini \
    && cd ../ && rm -rf libssh2.tar.gz ssh2.tgz ssh2 libssh2

# # mysql pdo
# RUN docker-php-ext-install pdo pdo_mysql

# # install zip, required for composers
# RUN apt-get update
RUN apt-get update
RUN apt-get install zip unzip

# install git
RUN apt-get install -y git

# install composer
RUN curl -s --show-error http://getcomposer.org/installer | php
RUN mv ./composer.phar /usr/local/bin/composer
RUN composer create-project dg/ftp-deployment ftp-deployment 3.3.0
RUN mv ftp-deployment /var/www/ftp-deployment
# # own php.ini
COPY env/php.ini /usr/local/etc/php

# # set new created file to have full access permissions
# RUN echo "umask 000" >> /etc/apache2/envvars
WORKDIR /var/www/html
CMD tail -f /dev/null