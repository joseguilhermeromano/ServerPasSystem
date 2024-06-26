FROM php:7.3-apache

WORKDIR /var/www/html

RUN apt update -y && \
    apt install apt-utils build-essential systemd net-tools curl locales git zip unzip nano vim -y

RUN apt install -y libpq-dev libfreetype6-dev libpng-dev zlib1g-dev \
        libzip-dev graphviz libpspell-dev aspell-en libmcrypt-dev libicu-dev libxml2-dev libldap2-dev  \
        libssl-dev libxslt-dev libkrb5-dev libldb-dev libcurl3-dev \
        libsnmp-dev librecode0 librecode-dev libbz2-dev libc-client-dev

RUN docker-php-ext-configure gd 
RUN docker-php-ext-install gd
RUN docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-install opcache
RUN yes | pecl install xdebug-3.1.6 
COPY ./conf/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap pdo_mysql pdo bcmath intl simplexml zip


RUN a2enmod rewrite && \
    service apache2 restart

RUN cd ~ && \
    curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
    
RUN docker-php-ext-install mysqli
RUN docker-php-ext-enable mysqli

RUN apt update -y && \ 
    apt install -y libgmp-dev

RUN docker-php-ext-configure gmp --with-gmp
RUN docker-php-ext-install gmp

 

RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

RUN passwd -d www

COPY --chown=www:www . /var/www/html

EXPOSE 80