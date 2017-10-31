FROM php:7.1-fpm

ADD ./site.ini /usr/local/etc/php/conf.d
ADD ./site.pool.conf /usr/local/etc/php-fpm.d/

RUN apt-get update && \
    apt-get install -y libssl-dev libpq-dev

RUN pecl install mongodb


# Install extensions using the helper script provided by the base image
RUN docker-php-ext-install \
    pdo_mysql \
    pgsql \
    pdo_pgsql \
    bcmath

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

RUN docker-php-ext-enable opcache mongodb pgsql pdo_pgsql

RUN usermod -u 1000 www-data

RUN { \
        echo 'date.timezone=UTC'; \
        echo 'memory_limit="256M"'; \
    } > /usr/local/etc/php/conf.d/zzz-overrides.ini

#RUN apt-get purge -y --auto-remove libssl-dev


WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
