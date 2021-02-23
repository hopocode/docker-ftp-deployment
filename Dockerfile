FROM php:7.1-cli
RUN apt-get update

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

# install zip, required for composers
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
CMD tail -f /dev/null