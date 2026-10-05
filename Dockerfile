FROM php:8.2-cli

# Install dependensi sistem dan ekstensi SQLite
RUN apt-get update &amp;&amp; apt-get install -y \
    libsqlite3-dev \
    unzip \
    git \
    &amp;&amp; docker-php-ext-install pdo pdo_sqlite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app
COPY . .

# Install dependensi Laravel
RUN composer install --no-dev --optimize-autoloader

EXPOSE 8080

# Perintah untuk membuat database, migrasi, dan menjalankan server
CMD touch database/database.sqlite &amp;&amp; php artisan migrate --force &amp;&amp; php artisan serve --host 0.0.0.0 --port ${PORT:-8080}