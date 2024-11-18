# Usar una imagen base de PHP 7.2 con Apache
FROM php:7.2-apache

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install pdo pdo_mysql mbstring gd xml zip

# Instalar Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecer el directorio de trabajo en el contenedor
WORKDIR /var/www/html

# Copiar el contenido del proyecto Laravel al contenedor
COPY . /var/www/html

# Establecer permisos correctos para el almacenamiento de Laravel
#RUN chown -R www-data:www-data /var/www/html/cso04/storage /var/www/html/cso04/bootstrap/cache

# Habilitar el módulo de reescritura de Apache
RUN a2enmod rewrite

# Exponer el puerto 80 para Apache
EXPOSE 80

# Ejecutar Apache en el primer plano para que el contenedor no se cierre
CMD ["apache2-foreground"]