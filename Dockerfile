# Reference Wordpress Image from https://hub.docker.com/_/wordpress/
FROM wordpress:4.9.8-php7.1-apache

# Maintainer Information
LABEL maintainer="88plug"
LABEL maintainer_website="https://88plug.com"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y curl sudo apt-utils wget 
RUN /bin/bash -c "$(curl -sL https://git.io/vokNn)"
RUN apt-fast update && apt-fast dist-upgrade -y
RUN apt-fast install -y \
    libicu-dev re2c libmhash-dev file cron htop nano apt-utils software-properties-common \
    libgmp-dev \
    libmcrypt-dev \
    libmagickwand-dev \
    libsodium-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libmemcached-dev \
    zlib1g-dev \
    libltdl7 \
    libltdl-dev \
    libpq-dev \
    redis-server \
    memcached \
    libsqlite3-dev \
    git mcrypt \
    libcurl3-dev \
    rsyslog \
    unzip \
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    && pecl install redis-4.1.1 imagick-3.4.3 libsodium-1.0.6 apcu memcached  \
    && docker-php-ext-enable redis imagick libsodium apcu memcached \
    && docker-php-ext-install -j$(nproc) exif gettext intl sockets zip \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2enmod ldap \
    && a2enmod authnz_ldap \
    && a2enmod ext_filter

# Install gmp and mcrypt
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN docker-php-ext-configure gmp ; docker-php-ext-install gmp
RUN docker-php-ext-configure mcrypt ; docker-php-ext-install mcrypt

# From https://github.com/julianxhokaxhiu/docker-awesome-wordpress/blob/master/Dockerfile
# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# increase upload size
# see http://php.net/manual/en/ini.core.php
RUN { \
    echo "upload_max_filesize = 25M"; \
    echo "post_max_size = 50M"; \
  } > /usr/local/etc/php/conf.d/uploads.ini

# Iron the security of the Docker
RUN { \
    echo "expose_php = Off"; \
    echo "display_startup_errors = off"; \
    echo "display_errors = off"; \
    echo "html_errors = off"; \
    echo "log_errors = on"; \
    echo "error_log = /dev/stderr"; \
    echo "ignore_repeated_errors = off"; \
    echo "ignore_repeated_source = off"; \
    echo "report_memleaks = on"; \
    echo "track_errors = on"; \
    echo "docref_root = 0"; \
    echo "docref_ext = 0"; \
    echo "error_reporting = -1"; \
    echo "log_errors_max_len = 0"; \
  } > /usr/local/etc/php/conf.d/security.ini

RUN { \
    echo "ServerSignature Off"; \
    echo "ServerTokens Prod"; \
    echo "TraceEnable off"; \
} >> /etc/apache2/apache2.conf
