FROM php:7.0-fpm

ADD ./site.ini /usr/local/etc/php/conf.d
ADD ./site.pool.conf /usr/local/etc/php-fpm.d/

# Install extensions using the helper script provided by the base image
RUN docker-php-ext-install \
    pdo_mysql \
    bcmath

RUN docker-php-ext-enable opcache

RUN usermod -u 1000 www-data

RUN { \
        echo 'date.timezone=UTC'; \
        echo 'memory_limit="256M"'; \
    } > /usr/local/etc/php/conf.d/zzz-overrides.ini


WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
