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
    
    && a2enmod rewrite \
    && a2enmod expires \
    && a2enmod headers \
    
    && sed -ri '/AllowOverride/s/^\t+(\S+).*/\t\1 All/' /etc/apache2/apache2.conf \
    && sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-enabled/000-default.conf \
    && sed -ri '/Options/d' /etc/apache2/apache2.conf \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log \
    && echo "upload_max_filesize = 250M;" >> /etc/php/7.4/apache2/conf.d/30-uploads.ini \
    && rm -dr /var/www/html \
    && mkdir -p /var/www/html \
    && chgrp -R www-data /var/www/html/ \
    && chmod 775 -R /var/www/html \
    
    && { \
        echo "#!/usr/bin/env bash"; \
        echo "set -e"; \
        echo "rm -f /run/apache2/apache2.pid"; \
        echo "exec apache2ctl -DFOREGROUND \"\$@\""; \
    } > /usr/local/bin/entrypoint \
    && chmod a+rx /usr/local/bin/entrypoint \
    && apt-get -yq clean autoclean && apt-get -yq autoremove \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html
EXPOSE 80 443
ENTRYPOINT ["entrypoint"]
