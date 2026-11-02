# CI Pipeline para Laravel

## Descripcion del proyecto

Aplicacion web construida con Laravel que incluye una pagina de inicio y un pipeline de integracion continua configurado con GitHub Actions. Cada cambio enviado a la rama `main` dispara automaticamente la instalacion de dependencias y la ejecucion de las pruebas, garantizando que el codigo integrado funcione correctamente.

## Tecnologias

- PHP 8.2
- Laravel
- Composer
- PHPUnit
- GitHub Actions

## Estructura del proyecto

```
pipe/
├── app/                  Logica de la aplicacion (modelos, controladores, proveedores)
├── database/             Migraciones, factories y seeders
├── public/               Punto de entrada HTTP y assets estaticos
├── resources/views/      Vistas Blade (Home.blade.php, welcome.blade.php)
├── routes/web.php        Definicion de rutas web
├── tests/
│   ├── Feature/          Pruebas de integracion HTTP
│   └── Unit/             Pruebas unitarias
├── .github/workflows/
│   └── ci.yml            Workflow de GitHub Actions
└── phpunit.xml           Configuracion de PHPUnit
```

## Como funciona

La ruta principal `/` devuelve la vista `Home`. Las pruebas verifican que esa ruta responde con HTTP 200. El archivo `phpunit.xml` configura el entorno de pruebas para usar SQLite en memoria, por lo que no se necesita una base de datos real para ejecutar los tests.

## Instalacion local

1. Clonar el repositorio:

```bash
git clone https://github.com/EduarCas231/pipeline.git
cd pipeline
```

2. Instalar dependencias:

```bash
composer install
```

3. Configurar el entorno:

```bash
cp .env.example .env
php artisan key:generate
```

4. Ejecutar las pruebas:

```bash
php artisan test
```

## Pruebas

| Prueba | Descripcion | Resultado esperado |
|---|---|---|
| `Tests\Unit\ExampleTest` | Verifica que `true` es `true` | Pasa |
| `Tests\Feature\ExampleTest` | Solicitud GET a `/`, espera HTTP 200 | Pasa |
| `Tests\Feature\HomePageTest` | Solicitud GET a `/`, verifica respuesta exitosa | Pasa |

Las pruebas usan `APP_ENV=testing`, `DB_CONNECTION=sqlite` y `DB_DATABASE=:memory:`, definidos en `phpunit.xml`, por lo que no dependen de MySQL ni de un archivo `.env` con base de datos configurada.

## Pipeline de integracion continua

El workflow `.github/workflows/ci.yml` se ejecuta en cada `push` o `pull request` a `main`.

Pasos del job `laravel-tests`:

1. Obtener el codigo fuente con `actions/checkout@v4`.
2. Configurar PHP 8.2 con las extensiones necesarias usando `shivammathur/setup-php@v2`.
3. Copiar `.env.example` a `.env`.
4. Instalar dependencias con `composer install`.
5. Generar la clave de aplicacion con `php artisan key:generate`.
6. Instalar dependencias de Node y compilar el frontend con `npm install && npm run build`.
7. Ejecutar las pruebas con `php artisan test` usando SQLite en memoria.

## Evidencias

### Ejecucion exitosa

- Commit: `9b7b4f2`
- Resultado: 3 pruebas en verde, 9 pasos completados en 18 s.
- Enlace: https://github.com/EduarCas231/pipeline/actions/runs/38979252315

### Ejecucion fallida (controlada)

Se sustituyo `assertSuccessful()` por `assertStatus(404)` en `HomePageTest.php`.

Error obtenido:

```
Expected response status code [404] but received 200.
```

La ruta `/` responde con 200, por lo que la asercion fallo y GitHub Actions marco el job como fallido. Al restaurar `assertSuccessful()` el pipeline volvio a aprobarse.

## Conclusiones

- El pipeline detecto automaticamente el error introducido a proposito, demostrando que no solo se ejecuta sino que comunica los fallos.
- La integracion continua garantiza que las dependencias se instalen de forma reproducible y da retroalimentacion inmediata en cada push.
- Como mejora futura se pueden actualizar las versiones de las acciones y agregar una etapa de despliegue independiente.
