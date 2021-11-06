#FROM php:8.0.2-fpm
FROM php:8.0.2-apache

LABEL Maintainer="Fernando Almeida <fernando.g.almeida@gmail.com>" \
      Description="PHP and PostgreSQL."

# Install postgresql driver
RUN apt-get update && apt install -y libpq-dev git zip \
 && docker-php-ext-install pgsql pdo pdo_pgsql

# Copy and run composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Copy existing app directory
COPY lib /flyway/jars
WORKDIR /var/www/html

ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN groupmod -o -g ${PGID} www-data && \
    usermod -o -u ${PUID} -g www-data www-data

# Add source code files to WORKDIR
COPY . .

# Install composer dependencies
RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

# Ensure file ownership for source code files
RUN chown -R www-data:www-data .

# Application port
EXPOSE 80

# Container start command
#CMD ["php-fpm"]
CMD ["apache2-foreground"]


