#!/bin/bash
set -e

echo "Iniciando despliegue de Laravel..."

# 1. Definir directorio de destino
TARGET_DIR="/var/www/html/laravel-app"
mkdir -p $TARGET_DIR
cd $TARGET_DIR

# 2. Descomprimir el artefacto recibido
echo "Descomprimiendo artefacto..."
unzip -o /tmp/release-v1.0.0.zip -d $TARGET_DIR

# 3. Instalar dependencias de producción
echo "Instalando dependencias de producción..."
composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader

# 4. Configurar permisos y caché de Laravel
echo "Configurando permisos y optimizando caché..."
chmod -R 775 storage bootstrap/cache
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 5. Ejecutar migraciones de base de datos
echo "Ejecutando migraciones..."
php artisan migrate --force

echo "¡Despliegue finalizado con éxito!"