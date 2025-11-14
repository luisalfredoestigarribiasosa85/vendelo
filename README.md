# Vendelo

Vendelo es un marketplace minimalista en construcción para que cualquier persona pueda publicar y vender productos en línea. El objetivo del proyecto es ofrecer una base sólida (autenticación, catálogo, internacionalización y despliegue listo para producción) sobre la que se puedan sumar módulos como administración, pasarelas de pago y analytics.

## Características actuales

- **Catálogo de productos** con imágenes, contenido enriquecido y precios; ordenados por fecha de publicación (`ProductsController` + `Active Storage` + `Action Text`).
- **Clasificación por categorías** con CRUD completo y validaciones para evitar duplicados (`Category` + vistas en `app/views/categories`).
- **Autenticación con Devise** para registrar y proteger la app; los listados públicos permiten visitas anónimas.
- **Internacionalización** en inglés y español (`config/locales/en.yml`, `config/locales/es.yml`) con detección automática vía `Accept-Language`.
- **Stack Hotwire completo** (`turbo-rails`, `stimulus-rails`, import maps y Propshaft) para respuestas rápidas sin empaquetadores externos.
- **Servicios Solid** para cache, colas y Action Cable listos (Solid Cache/Queue/Cable).
- **Despliegue con Kamal + Docker** hacia un servidor remoto y un accesorio PostgreSQL gestionado por la propia herramienta.

## Stack y dependencias principales

| Componente              | Versión / Detalle                                            |
|-------------------------|--------------------------------------------------------------|
| Ruby                    | 3.3.6 (`.ruby-version`)                                      |
| Bundler                 | 2.6.9 (Dockerfile fuerza esta versión)                       |
| Rails                   | 8.0.2                                                        |
| Base de datos           | PostgreSQL (desarrollo 15+, producción contenedor 17)        |
| Autenticación           | Devise                                                       |
| Frontend                | Hotwire (Turbo + Stimulus) e import maps                     |
| CSS/JS Pipeline         | Propshaft + import maps                                      |
| Background/Cache        | Solid Queue / Cache / Cable                                  |
| Subida de archivos      | Active Storage + `image_processing` (libvips)                |
| Docker/Orquestación     | Kamal 2.x, Thruster para servir recursos estáticos           |

## Requisitos previos

- Ruby 3.3.6 instalado (recomendado usar `rbenv` o `asdf`).
- PostgreSQL accesible (local o Docker) con un usuario que tenga permisos para crear DBs.
- Bundler 2.6.9 (`gem install bundler -v 2.6.9`).
- Node/npm no son necesarios gracias a import maps.
- Para despliegues: Docker >= 24, acceso al registro Docker Hub y Kamal (`gem install kamal`).

## Puesta en marcha local

```bash
git clone git@github.com:<tu-usuario>/vendelo.git
cd vendelo
bin/setup            # instala gemas, prepara la base y arranca bin/dev
```

`bin/setup` ejecuta `bundle install`, `bin/rails db:prepare` y finalmente `bin/dev` que arranca el servidor Puma en `http://localhost:3000`.

Si prefieres pasos manuales:

```bash
bundle install
bin/rails db:prepare
bin/dev
```

La app usa Active Storage en disco local (`storage/`) y Action Text para el campo de descripción de productos.

## Variables de entorno

- `RAILS_MASTER_KEY`: requerido para desencriptar credenciales en producción. Guarda la clave en `.kamal/secrets` o usa un gestor seguro.
- `DB_HOST`, `DB_PORT`, `POSTGRES_USER`, `POSTGRES_PASSWORD`: apuntan al PostgreSQL que usará Rails. Por defecto se asumen `localhost`, `5432`, `postgres`, `postgres`.
- Variables opcionales en `config/deploy.yml` (`SOLID_QUEUE_IN_PUMA`, `WEB_CONCURRENCY`, etc.) permiten ajustar la infraestructura.

## Comandos útiles

```bash
bin/rails db:prepare            # crea/migra la base (usa datos de config/database.yml)
bin/rails dbconsole             # abre consola SQL según el entorno
bin/rails test                  # ejecuta la suite de tests (test-unit/capybara)
bundle exec rubocop             # linting de estilo (Omakase)
bundle exec brakeman            # escáner de seguridad
bin/rails assets:precompile     # compila assets (usado en Dockerfile)
```

## Despliegue con Kamal

El flujo estándar:

```bash
# Construye y publica la imagen + despliega containers
kamal deploy

# Consola remota (usa alias en config/deploy.yml)
bin/kamal console --environment=production

# Shell en el contenedor
bin/kamal shell
```

Notas clave:

- La imagen se construye con el `Dockerfile` multi-stage (Ruby slim + bundler 2.6.9). Durante el build se compilan assets con un `SECRET_KEY_BASE` temporal.
- `config/deploy.yml` define:
  - El nombre de la imagen Docker que se publica en tu registro.
  - Los hosts de la app y cualquier dominio/proxy TLS.
  - Accesorios como la base PostgreSQL y los volúmenes persistentes.
  - Variables de entorno (`DB_*`, `SOLID_QUEUE_IN_PUMA`, etc.) y aliases para tareas frecuentes.
- Guarda secretos (`RAILS_MASTER_KEY`, `KAMAL_REGISTRY_PASSWORD`) en `.kamal/secrets`.
- Para abrir la consola interactiva en producción usa `bin/kamal console` (o manualmente `kamal app exec --interactive -- bin/rails console --environment=production`).

## Arquitectura funcional

- **Usuarios** (`User`): manejados con Devise (`database_authenticatable`, `registerable`, `recoverable`, `rememberable`).
- **Categorías** (`Category`): relación uno-a-muchos con productos, validaciones de presencia y unicidad.
- **Productos** (`Product`): título, descripción enriquecida, precio y una imagen. Asociados a categorías.
- **Controladores**: `ProductsController` y `CategoriesController` permiten navegación pública en `index/show` y requieren autenticación para operaciones de escritura.
- **Internacionalización**: las notificaciones y etiquetas están en `config/locales/en.yml` y `config/locales/es.yml`. `ApplicationController` selecciona el idioma según la cabecera del navegador.
- **Seguridad**: `allow_browser versions: :modern` asegura que sólo navegadores modernos accedan a la app, y Devise protege rutas.

## Roadmap personal

- Panel de administración y dashboards.
- Pasarelas de pago e integración con proveedores de logística.
- Mejorar UX (búsqueda, filtros, favoritos).
- Métricas y reportes de ventas.

## Licencia y autoría

Proyecto personal de Luis Estigarribia. Si deseas reutilizarlo o contribuir, abre un issue/discusión indicando el uso previsto.
