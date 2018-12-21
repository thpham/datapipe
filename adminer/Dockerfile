FROM adminer:4.7

COPY --chown=adminer:adminer login-servers.php /var/www/html/plugins-enabled/login-servers.php

USER root

RUN apk add --no-cache --virtual .build-deps \ 
    g++ make autoconf && \
  pecl channel-update pecl.php.net && \
  pecl install mongodb && docker-php-ext-enable mongodb && \
  apk del --purge .build-deps

USER adminer