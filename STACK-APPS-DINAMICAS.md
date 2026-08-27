# Stack Tecnológico — Aplicaciones Dinámicas Multiplataforma

> **Cómo usar este archivo:** pégalo en la raíz de cada proyecto nuevo de app dinámica (con backend, base de datos y/o lógica de negocio) que deba correr en Windows, Ubuntu, Web, iOS, macOS, tablets, smartwatches y/o Android. Sirve como referencia de decisiones ya tomadas — no lo re-discutas por proyecto, evoluciónalo en el repo `Estandarizador` cuando cambie una decisión para todos los proyectos futuros.

## 1. Principio rector

Una sola base de código de **cliente** para el 90% de las plataformas (Flutter), un **backend** desacoplado detrás de una API con contrato explícito (OpenAPI), y **satélites nativos delgados** solo donde el sistema operativo lo obliga (smartwatches). Nada de lógica de negocio duplicada: el core vive en el backend y/o en paquetes Dart compartidos; la UI es la única capa que varía por plataforma.

```
┌─────────────────────────────────────────────────────────┐
│                    Backend (NestJS)                      │
│         API REST + OpenAPI  ·  Postgres  ·  Redis         │
└───────────────────────────┬───────────────────────────────┘
                             │ contrato OpenAPI → SDK autogenerado
        ┌────────────────────┼─────────────────────┐
        │                    │                      │
┌───────▼────────┐  ┌────────▼────────┐   ┌─────────▼─────────┐
│ Flutter client  │  │  Wear OS nativo │   │  watchOS nativo   │
│ Win/Linux/macOS │  │ Kotlin+Compose  │   │  Swift+SwiftUI    │
│ Web/iOS/Android │  │                 │   │                   │
│ Tablets         │  │                 │   │                   │
└─────────────────┘  └─────────────────┘   └───────────────────┘
```

## 2. Cliente (frontend multiplataforma)

| Capa | Elección | Por qué |
|---|---|---|
| Framework UI | **Flutter** (Dart, canal *stable*) | Único framework maduro con soporte oficial simultáneo para Windows, Linux, macOS, Web, iOS, Android y tablets desde un mismo código. |
| Gestión de estado | **Riverpod** | Menos boilerplate que Bloc, testeable, compile-safe. Si el equipo prefiere una arquitectura más estricta por capas, Bloc es alternativa válida — elige una y no mezcles ambas en el mismo proyecto. |
| Navegación | **go_router** | Estándar de facto en Flutter, soporta deep links y rutas declarativas necesarias para Web. |
| Cliente HTTP/API | SDK **autogenerado** desde el spec OpenAPI del backend (`openapi-generator` con target `dart`) | Evita mantener a mano los modelos/DTO del cliente; si cambia el contrato, se regenera y el compilador marca los rotos. |
| Smartwatches | **Wear OS**: Kotlin + Jetpack Compose · **watchOS**: Swift + SwiftUI | Apple y Google no permiten Flutter en producción para watch apps con confiabilidad aceptable. Son apps delgadas: solo UI + llamadas a la misma API REST. Comparten contrato OpenAPI, no lógica de UI. |
| Diseño | **Material 3** en Android/Web/desktop, ajustes Cupertino solo donde iOS lo exija (`flutter_platform_widgets` si se necesita adaptar look nativo) | Minimiza si/else por plataforma en el árbol de widgets. |
| Web como PWA instalable | Configurar `web/manifest.json` (`name`, `short_name`, `theme_color`, `background_color`, `display: "standalone"`, íconos 192x192/512x512 + `maskable`) — el service worker (`flutter_service_worker.js`) ya lo genera Flutter en cada `flutter build web`, no hay que escribirlo a mano | El build Web ya trae soporte de PWA integrado; personalizar el manifest es lo único que falta para que sea instalable ("Add to Home Screen") — útil como canal de distribución liviano para pilotos/demos sin pasar por Play Store/App Store. |

## 3. Backend

| Capa | Elección | Por qué |
|---|---|---|
| Framework | **NestJS** (Node.js + TypeScript) | Estructura obligatoria (módulos/controladores/servicios/DI), reduce deriva entre proyectos distintos, gran ecosistema, fácil de testear. |
| Contrato de API | **OpenAPI 3.1**, *contract-first* o generado desde decoradores de Nest (`@nestjs/swagger`) | Es la fuente de verdad que alimenta el SDK de Flutter y cualquier otro consumidor. Nunca cambies la API sin regenerar el spec primero. |
| ORM / acceso a datos | **Prisma** | Migraciones versionadas, tipado end-to-end en TS, buen soporte multi-DB si algún proyecto necesita otro motor. |
| Autenticación | **Keycloak** (self-hosted, OIDC/OAuth2) para proyectos con requisitos de control total, o **Supabase Auth** cuando priorices velocidad de arranque | Un solo proveedor de identidad reutilizable entre proyectos evita reinventar login por app. Elige uno como default de la organización. |
| Colas / trabajos en segundo plano | **BullMQ** sobre Redis | Reintentos, cron jobs, procesamiento asíncrono sin infra adicional. |
| Almacenamiento de archivos | **S3-compatible**: Cloudflare R2 (managed) o MinIO (self-hosted) | Mismo SDK (`aws-sdk`) sin importar el proveedor; facilita migrar de self-hosted a cloud o viceversa. |

## 4. Base de datos

| Necesidad | Elección | Por qué |
|---|---|---|
| Relacional (default) | **PostgreSQL 16+** | ACID, JSONB para casos semi-estructurados, extensísimo soporte cloud/self-hosted, evita re-arquitectura al escalar. |
| Cache / sesiones / rate-limiting | **Redis 7+** | Estándar, integra directo con BullMQ y con Nest. |
| Búsqueda full-text avanzada (solo si se necesita) | **Postgres `tsvector`** primero; escalar a **Meilisearch** si no alcanza | No añadas Elasticsearch/OpenSearch por defecto — es sobre-ingeniería para la mayoría de proyectos. |

## 5. Infraestructura, CI/CD y despliegue

- **Contenedores:** Docker + Docker Compose para desarrollo local y para desplegar el backend (misma imagen en todos los entornos).
- **CI/CD:** GitHub Actions como default.
  - Backend: build → test → lint → build imagen Docker → deploy.
  - Flutter: build matrix por plataforma (Android APK/AAB, iOS IPA vía Fastlane + macOS runner, Windows/Linux/macOS desktop builds, Web build a estático).
- **Distribución móvil:** **Fastlane** para automatizar firma y subida a Play Store / App Store — evita el "apuro de último momento" en releases.
- **Hosting backend:** cualquier proveedor con soporte Docker (Railway, Fly.io, o VPS propio) — evita atarte a servicios propietarios sin salida.
- **Feature flags:** **GrowthBook** o **Unleash** (self-hosted) para lanzar funcionalidades de forma incremental y probarlas en producción sin arriesgar el release completo — clave para iterar sin apuros.
- **Observabilidad:** **Sentry** (errores/crashes) en cliente Flutter y backend; logs centralizados solo si el proyecto lo amerita (Grafana Loki).

## 6. Organización del código

- **Monorepo por proyecto** (no monorepo global entre proyectos distintos, salvo que compartan dominio de negocio).
- Dentro del monorepo: `apps/backend`, `apps/mobile` (Flutter), `packages/shared-dart` (modelos/lógica Dart compartida entre Flutter y watch companions si aplica), `packages/api-client` (SDK generado).
- Herramienta de monorepo: **Melos** para los paquetes Dart/Flutter; si el backend vive en el mismo repo con TS, usar workspaces de npm/pnpm es suficiente — no añadas Nx/Turborepo salvo que el repo crezca a muchos paquetes TS.

## 7. Testing (mínimo por proyecto)

- Backend: unit tests con Jest (o Vitest), tests de integración contra Postgres real vía Testcontainers.
- Flutter: `flutter_test` para widgets, `integration_test` para flujos críticos end-to-end en al menos una plataforma (Android o Web).
- Web (si aplica): Playwright para smoke tests del flujo principal.

## 8. Versionado y releases

- **SemVer** + **Conventional Commits** en todos los repos.
- Changelog automático (`standard-version` o `changesets`).
- Releases graduales vía feature flags antes de exponer al 100% de usuarios.

## 9. Alternativas descartadas (y por qué)

| Alternativa | Por qué no es el default |
|---|---|
| React Native (+ Expo) | Sin soporte oficial robusto de Linux desktop; Windows/macOS vía módulos comunitarios menos maduros que Flutter desktop. |
| .NET MAUI | No soporta Linux desktop; fuerte solo si el proyecto es 100% ecosistema Microsoft. |
| Firebase como backend completo | Vendor lock-in fuerte y menor control sobre el modelo de datos relacional; válido solo para prototipos rápidos, no como default de "producción confiable". |
| GraphQL como default | REST + OpenAPI es más simple de generar clientes tipados en Dart de forma confiable; considera GraphQL solo si el proyecto tiene requisitos claros de *querying* flexible desde múltiples clientes con formas de datos muy distintas. |
