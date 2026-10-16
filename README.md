# CI Pipeline para Laravel

## Objetivo

Automatizar la instalación de dependencias y la ejecución de pruebas de la aplicación Laravel mediante GitHub Actions, de modo que cada cambio enviado a la rama `main` sea validado automáticamente.

## Tecnologías

- PHP 8.2
- Laravel
- Composer
- PHPUnit
- Git y GitHub
- GitHub Actions

## Requisitos

- PHP compatible con el proyecto (8.2 o superior)
- Composer
- Git
- Acceso al repositorio de GitHub

## Instalación local

1. Clonar el repositorio:
```bash
   git clone https://github.com/EduarCas231/pipeline.git
   cd pipeline
```
2. Instalar las dependencias:
```bash
   composer install
```
3. Copiar el archivo de entorno:
```bash
   cp .env.example .env
```
4. Generar la clave de la aplicación:
```bash
   php artisan key:generate
```
5. Configurar la base de datos requerida en el archivo `.env`.
6. Ejecutar las migraciones si son necesarias:
```bash
   php artisan migrate
```
7. Ejecutar las pruebas:
```bash
   php artisan test
```

## Integración continua

El workflow `.github/workflows/ci.yml` se ejecuta al enviar cambios a la rama `main` o al crear una solicitud de integración (pull request) dirigida a ella.

Pasos que ejecuta el job `laravel-tests`:

1. Obtener el código del repositorio (`actions/checkout@v4`).
2. Configurar PHP 8.2 con las extensiones necesarias (`shivammathur/setup-php@v2`).
3. Validar `composer.json` con `composer validate`.
4. Instalar las dependencias con `composer install`.
5. Preparar el entorno de Laravel (`.env`, `key:generate`, `config:clear`).
6. Ejecutar las pruebas con `php artisan test`, usando SQLite en memoria.

## Pruebas

| Prueba | Descripción | Resultado esperado |
|---|---|---|
| `Tests\Unit\ExampleTest` | Prueba unitaria de ejemplo | Pasa |
| `Tests\Feature\ExampleTest` | Verifica que la aplicación responde correctamente | Pasa |
| `Tests\Feature\HomePageTest` | Realiza una petición GET a `/` y verifica un código de éxito (HTTP 200) | Pasa |

**Resultado obtenido en local:** `Tests: 3 passed (3 assertions)`.

![Pruebas locales](capturas/pruebas-locales.png)

Las pruebas usan las variables `APP_ENV=testing`, `DB_CONNECTION=sqlite` y `DB_DATABASE=:memory:`, por lo que no dependen de MySQL.

## Evidencias

### Ejecución exitosa

- **Fecha:** 16/10/2026
- **Commit:** Primer comit (`9b7b4f2`)
- **Resultado:** exitoso. Los 9 pasos terminaron en verde en 18 s y las 3 pruebas pasaron.
- **Enlace:** https://github.com/EduarCas231/pipeline/actions/runs/38979252315

![Ejecución exitosa](capturas/ejecucion-exitosa.png)

GitHub mostró una advertencia (la acción `actions/checkout@v4` usa Node.js 20, que se está retirando) y un aviso (la etiqueta `ubuntu-latest` migrará a Ubuntu 26 el 19 de octubre de 2026). Ninguno afectó el resultado.

### Ejecución fallida (controlada)

- **Fecha:** [fecha]
- **Commit:** Prueba fallida controlada ([hash])
- **Cambio realizado:** en `HomePageTest.php` se sustituyó `assertSuccessful()` por `assertStatus(404)`.
- **Error:** `Expected response status code [404] but received 200.`
- **Interpretación:** la ruta `/` responde correctamente con HTTP 200, pero la prueba esperaba 404, por lo que la aserción falló y GitHub Actions marcó el job como fallido.
- **Solución:** restaurar la aserción correcta `assertSuccessful()`.
- **Enlace:** [enlace de la ejecución fallida]

![Ejecución fallida](capturas/ejecucion-fallida.png)

### Ejecución exitosa posterior a la corrección

- **Fecha:** [fecha]
- **Commit:** Corregir prueba ([hash])
- **Resultado:** exitoso, con las 3 pruebas en verde.
- **Enlace:** [enlace de la ejecución corregida]

![Ejecución corregida](capturas/ejecucion-corregida.png)

## Conclusiones

- El pipeline detectó automáticamente el error introducido a propósito en la prueba (`assertStatus(404)` frente a una respuesta 200), lo que demuestra que no solo se ejecuta, sino que también comunica los fallos.
- Al restaurar la aserción correcta y volver a enviar los cambios, el pipeline volvió a aprobarse, confirmando que la corrección fue efectiva.
- La integración continua reduce el riesgo de integrar código defectuoso, da retroalimentación inmediata en cada push, garantiza que las dependencias se instalen de forma reproducible y facilita encontrar el origen de los errores mediante los logs.
- Como mejora futura, se pueden actualizar las versiones de las acciones y agregar una etapa de construcción del frontend o de despliegue como paso independiente.