FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Copenhagen

RUN apt-get update && apt-get upgrade -yq 

RUN apt-get install -qy \
    git \
    wget \
    curl \
    unzip \
    apache2 \
    python2 \
    php7.4-cli \
    php7.4-zip \
    php7.4-xml \
    php7.4-bz2 \
    php7.4-curl \
    php7.4-intl \
    mysql-client \
    php7.4-mysql \
    php7.4-bcmath \
    inotify-tools \
    php7.4-common \
    php7.4-imagick \
    php7.4-mbstring \
    libapache2-mod-php7.4 \
    software-properties-common \
    
    && cd /tmp \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    
    && rm -dr /var/www/html \
    && mkdir -p /var/www/html \
    
    && a2enmod rewrite \
    && a2enmod expires \
    && a2enmod headers

WORKDIR /var/www/html
