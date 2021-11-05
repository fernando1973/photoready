FROM php:8.0.2-fpm

ARG APCU_VERSION=5.1.18

LABEL Maintainer="Fernando Almeida <fernando.g.almeida@gmail.com>" \
      Description="PHP and PostgreSQL."

RUN apt-get update && apt install -y libpq-dev \
 && docker-php-ext-install pgsql pdo pdo_pgsql

# Copy existing app directory
COPY src/public /var/www/public
COPY lib /flyway/jars
WORKDIR /var/www

# Configure non-root user.
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

RUN chown -R www-data:www-data /var/www

# Copy and run composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
#RUN composer install --no-interaction

EXPOSE 8080

CMD ["php-fpm"]