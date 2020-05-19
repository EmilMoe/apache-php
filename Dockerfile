FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Copenhagen

RUN apt-get update && apt-get -yq upgrade \
    && apt-get install -yq apache2 libapache2-mod-php7.4 php7.4 php7.4-mysql \
       php7.4-bcmath php7.4-bz2 php7.4-mbstring php7.4-zip \
       php7.4-common php7.4-xml php7.4-cli php7.4-curl git \
       unzip curl php-imagick composer software-properties-common \
    && groupadd -g 61000 docker \
    && useradd -g 61000 -l -M -s /bin/false -u 61000 docker \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && a2enmod rewrite \
    && sed -ri '/AllowOverride/s/^\t+(\S+).*/\t\1 All/' /etc/apache2/apache2.conf \
    && sed -ri '/Options/d' /etc/apache2/apache2.conf \
        && ln -sf /dev/stdout /var/log/apache2/access.log \
        && ln -sf /dev/stderr /var/log/apache2/error.log \
    && echo "upload_max_filesize = 250M;" >> /etc/php/7.4/apache2/conf.d/30-uploads.ini \
    && mkdir -p /var/www/html && rm -r /var/www/html/* \
    && { \
        echo "#!/usr/bin/env bash"; \
        echo "set -e"; \
        echo "rm -f /run/apache2/apache2.pid"; \
        echo "exec apache2ctl -DFOREGROUND \"\$@\""; \
    } > /usr/local/bin/entrypoint \
    && chmod a+rx /usr/local/bin/entrypoint \
    && apt-get -yq clean autoclean && apt-get -yq autoremove \
    && rm -rf /var/lib/apt/lists/*

USER docker

EXPOSE 80/tcp 443/tcp

ENTRYPOINT ["entrypoint"]

