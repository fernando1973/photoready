FROM php:8.0.2-fpm as composer

RUN apt-get update

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

FROM php:8.0.2-fpm

COPY --from=composer /usr/local/bin/composer /usr/local/bin/composer

RUN apt-get update

COPY src/public /var/www/public
copy src/lib /flyway/jars

WORKDIR /var/www