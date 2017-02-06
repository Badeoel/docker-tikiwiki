FROM montefuscolo/php
MAINTAINER Fabio Montefuscolo <fabio.montefuscolo@gmail.com>

WORKDIR /var/www/html/

RUN curl -o tiki-wiki.tar.gz 'http://ufpr.dl.sourceforge.net/project/tikiwiki/Tiki_12.x_Altair/12.10/tiki-12.10.tar.gz' \
    && tar -C /var/www/html -zxvf  tiki-wiki.tar.gz --strip 1 \
    && rm tiki-wiki.tar.gz \
    && { \
        echo "<?php"; \
        echo "    \$db_tiki        = getenv('TIKI_DB_DRIVER') ?: 'mysql';"; \
        echo "    \$dbversion_tiki = getenv('TIKI_DB_VERSION') ?: '12.10';"; \
        echo "    \$host_tiki      = getenv('TIKI_DB_HOST') ?: 'db';"; \
        echo "    \$user_tiki      = getenv('TIKI_DB_USER');"; \
        echo "    \$pass_tiki      = getenv('TIKI_DB_PASS');"; \
        echo "    \$dbs_tiki       = getenv('TIKI_DB_NAME') ?: 'tikiwiki';"; \
        echo "    \$client_charset = 'utf8';"; \
    } > /var/www/html/db/local.php \
    && /bin/bash htaccess.sh \
    && chown -R root:root /var \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && chown -R www-data db \
    && chown -R www-data dump \
    && chown -R www-data img/wiki \
    && chown -R www-data img/wiki_up \
    && chown -R www-data img/trackers \
    && chown -R www-data modules/cache \
    && chown -R www-data styles \
    && chown -R www-data temp \
    && chown -R www-data temp/cache \
    && chown -R www-data templates \
    && chown -R www-data templates_c \
    && chown -R www-data whelp

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/var/www/html/files/", "/var/www/html/img/wiki/", "/var/www/html/img/wiki_up/", "/var/www/html/img/trackers/"]

EXPOSE 80 443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
