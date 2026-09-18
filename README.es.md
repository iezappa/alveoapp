# Alveo 🌊

[English](README.md) · **Español**

**Un acompañante tranquilo, privado y local‑first para tu trabajo personal en terapia.**

<p align="center">
  <a href="https://h4tyr3l.github.io/alveoapp/">
    <img src="docs/preview.png" alt="Alveo — inicio, ejercicio de respiración y tutorial de primer uso" width="820">
  </a>
</p>

<p align="center"><a href="https://h4tyr3l.github.io/alveoapp/"><strong>Pruébala →</strong></a></p>

Alveo es una app de un solo usuario para llevar registro de cómo estás entre y
alrededor de las sesiones de terapia: registros de ánimo, un diario en Markdown,
preparación y notas de sesión, tareas de tu terapeuta, registros de pensamientos de
TCC, un ejercicio de respiración y tendencias simples a lo largo del tiempo. Todo vive
en tu propio dispositivo.

> **Aviso.** Alveo es una herramienta de registro personal. **No** es un dispositivo
> médico, no ofrece diagnóstico ni tratamiento y **no** reemplaza la atención
> profesional. En una emergencia, comunícate con los servicios de emergencia de tu
> zona o con tu profesional de salud.

> **Si estás en crisis o en peligro**, llama al **911** o al **Centro de Asistencia
> al Suicida**: **135** (gratuita desde CABA y Gran Buenos Aires) o
> **(011) 5275-1135** (desde todo el país). Los mismos números están a un toque
> dentro de la app, en Ajustes → Acerca de y al principio del plan de seguridad.

---

> [!WARNING]
> **Tus datos viven SOLO en tu dispositivo.**
>
> - No se guardan en los servidores del desarrollador, ni tampoco en un servidor
>   ZimaOS: un servidor solo entrega la app, nunca guarda nada tuyo.
> - Si desinstalas la app, pierdes o reseteas el dispositivo, o borras los datos
>   del navegador, **tus datos se pierden para siempre**.
> - La única copia de seguridad es la que haces tú.
>
> **Haz copias seguido (una vez por semana es un buen ritmo):**
>
> 1. Abre la app → **Ajustes** → **Tus datos** → **Exportar copia**.
> 2. Guarda el archivo `.json` en un lugar seguro **fuera de este dispositivo**: una
>    nube, un correo a ti mismo, otro dispositivo. No está cifrado: mantenlo privado.
>
> **Para recuperar tus datos** (dispositivo nuevo, reinstalación):
>
> 1. Instala la app y ábrela.
> 2. **Ajustes** → **Tus datos** → **Importar copia** → elige tu `.json` más reciente.
> 3. Una importación solo agrega: no se sobrescribe nada de lo que ya tienes.

**Descargas:** https://github.com/iezappa/alveoapp/releases/latest ·
**Versión web (iPhone, iPad, cualquier navegador):** https://h4tyr3l.github.io/alveoapp/

---

## Lo principal

- **Local‑first, sin backend.** Sin cuenta, sin servidor de sincronización, sin
  telemetría, sin anuncios, sin IA. Tus datos nunca salen del dispositivo. La única
  solicitud que la app hace por su cuenta es una comprobación de versión (como mucho
  cada seis horas), y no lleva nada tuyo.
- **Privada por diseño.** Bloqueo opcional con PIN, con espera creciente ante fallos
  repetidos. Las copias de seguridad son una exportación de archivo explícita,
  iniciada por el usuario.
- **Bilingüe.** Interfaz completa en español e inglés, con cambio de idioma en
  ejecución.
- **Diseño cálido y mínimo.** Material 3 con una paleta crema cálida y una tipografía
  serif para títulos; pensada para sentirse sin apuro.
- **Funciona en Linux, Windows, macOS, Android y la web.** La versión web se instala
  como PWA (agregar a la pantalla de inicio en iOS/Android) y abre sin conexión.

## Funciones

| Área | Qué hace |
| --- | --- |
| **Registro diario** | Escala de ánimo del 1 al 5 con íconos de clima, rueda de emociones de Plutchik, etiquetas de contexto y una nota breve. |
| **Diario** | Entradas en Markdown organizadas en cuadernos (líneas del día, estudio, creatividad, …) y una revisión mensual. |
| **Sesiones** | Prepara una agenda, toma notas durante la sesión, registra lo que te llevas después; vincula una sesión con tareas, entradas del diario y registros relacionados. |
| **Tareas** | Sigue las tareas que te asigna tu terapeuta, con una nota de cierre al terminarlas. |
| **Herramientas** | Registros de pensamientos de TCC: situación → pensamiento automático → evidencia → reencuadre, con grado de creencia y etiquetas de distorsiones cognitivas. |
| **Respirar** | Un ejercicio de respiración guiado (caja 4·4·4·4 o calma 4·7·8). |
| **Tendencias** | Una minigráfica de ánimo de 14 días en el inicio y un gráfico de tendencia más completo con vista de calendario. |
| **Ver todo** | Un único flujo de solo lectura con todo lo que escribiste, lo más nuevo primero. |
| **Biblioteca** | Una frase motivadora breve para cada día del año. |
| **Plan de seguridad** | Un plan privado y estructurado (señales de alerta, pasos para afrontar, contactos). |
| **Medicación** | Registra medicamentos y sus tomas. |
| **Copias de seguridad** | Exportación e importación completa de la base de datos como un único archivo JSON, más una exportación CSV legible en planillas de cálculo. |
| **Exportación a Obsidian** | Escribe las entradas del diario como Markdown en una bóveda de Obsidian (solo escritorio). |
| **Primer uso** | Pregunta tu nombre al empezar y muestra un tutorial breve, que se puede volver a abrir desde Ajustes. |

## Stack técnico

- **Flutter** (Dart SDK `^3.13.1`), Material 3
- **Riverpod** para el estado, **go_router** para la navegación
- **Drift** sobre SQLite para la persistencia: un archivo nativo en escritorio,
  WebAssembly + IndexedDB en la web (esquema v9, con una prueba de migración desde
  cada versión publicada)
- **fl_chart** para las tendencias, **pdf** para la exportación destinada al
  profesional, fuentes **Lora** / **Lato** incluidas

## Arquitectura

Organizada por funcionalidad, con una capa de dominio sin framework:

```
apps/client/lib/
  app/          # composition root: router, theme, locale, lock, onboarding
  domain/       # pure Dart: emotions, greeting, CBT, export renderers, …
  data/
    local/      # Drift database, tables, platform connections (native / web)
    repositories/  # one per aggregate, the only thing that touches Drift
    export/ transfer/ security/ search/ obsidian/
  features/     # one folder per screen area (UI + its providers)
  l10n/         # app_en.arb / app_es.arb (key parity is enforced by a test)
```

- El código de dominio no importa Flutter ni Drift y se prueba de forma aislada.
- Las pantallas leen providers respaldados por repositorios; las pantallas de lista
  usan una estructura maestro–detalle que pasa a dos paneles en ventanas anchas.
- El código específico de plataforma (conexión a la base de datos, guardado de
  archivos, Obsidian) se elige con imports condicionales.

## Cómo ejecutarla

Requisitos: Flutter (acorde a `apps/client/pubspec.yaml`; desarrollada con 3.47.x).

```bash
cd apps/client
flutter pub get
flutter run -d linux      # or: -d macos / -d windows
flutter run -d chrome     # web
```

Regenera el código de la base de datos después de cambiar tablas:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Pruebas y verificaciones:

```bash
flutter test
flutter analyze
```

## Despliegue web / PWA

`.github/workflows/deploy-web.yml` compila la app web y la publica en GitHub Pages
en cada push a la rama principal:

- `flutter build web --release --base-href "/<repo>/"`
- se agregan el fallback de SPA (`404.html`) y `.nojekyll`
- se despliega con `actions/deploy-pages`

- `tool/generate_sw.sh` marca el service worker propio de la app (`web/sw.js`) con
  la versión y un hash de cada archivo, que es lo que permite que la PWA abra sin
  conexión: el worker de Flutter solo se da de baja a sí mismo.

Para instalarla en un teléfono, abre la URL publicada en Safari (iOS) o Chrome
(Android) y elige **Agregar a la pantalla de inicio**. Cuando se publica una versión
nueva, la app muestra **"Hay una versión nueva"**; nada cambia debajo de una
página en uso hasta que tocas **Actualizar**.

> **Nota sobre iOS.** Safari puede borrar el almacenamiento local de una PWA después
> de aproximadamente una semana sin uso. Abre la app con regularidad y exporta una
> copia desde Ajustes de vez en cuando.

## Datos y privacidad

- La base de datos SQLite **no está cifrada en reposo**. El PIN protege la interfaz,
  no cifra los datos. Usa el cifrado de disco completo (BitLocker / FileVault / LUKS)
  y trata las copias exportadas como archivos sensibles.
- No se sube nada. Una versión web publicada solo ve, en el navegador de cada
  visitante, una base de datos local vacía.
- En Android la app se excluye de la copia de seguridad del sistema
  (`android:allowBackup="false"` más archivos de reglas que niegan la copia en la
  nube y la transferencia entre dispositivos), así que la base de datos nunca se
  copia a una cuenta de Google ni a un teléfono nuevo. La única copia es la que
  exportas tú.
- Para borrar todo: **Ajustes → Tus datos → Borrar todos mis datos**.

- [Política de privacidad](PRIVACY.es.md) · [Términos de uso](TERMS.es.md)

Desarrollador: Zeke Zappa Developments (iezappa); contacto a través de
[los issues del repositorio](https://github.com/iezappa/alveoapp/issues).

## Instalación, por dispositivo

| Dispositivo | Cómo |
|---|---|
| **iPhone / iPad** | Abre https://h4tyr3l.github.io/alveoapp/ en **Safari** → Compartir → **Agregar a la pantalla de inicio**, y ábrela siempre desde ese ícono. Una pestaña y el ícono instalado guardan datos separados, y Safari puede borrar un sitio que dejas de visitar. |
| **Android** | Descarga `alveoapp-vX.Y.Z-android.apk` de la [última versión](https://github.com/iezappa/alveoapp/releases/latest) e instálalo (permite una vez las instalaciones desde este origen). Las actualizaciones se instalan encima: **nunca desinstales antes, eso borra tus datos**. [Obtainium](https://github.com/ImranR98/Obtainium) puede hacerlo automáticamente desde este repositorio. O instala la versión web desde Chrome; las dos guardan datos separados. |
| **Windows** | Descarga `alveoapp-vX.Y.Z-windows-x64.zip`, extráelo en una carpeta que conserves y ejecuta el `.exe`. No está firmado, así que SmartScreen avisa una vez: Más información → Ejecutar de todas formas. |
| **Linux** | `sudo apt install libgtk-3-0`, luego descarga `alveoapp-vX.Y.Z-linux-x64.tar.gz` y extráelo en un lugar que conserves. |
| **macOS** | Descarga `alveoapp-vX.Y.Z-macos.zip`, mueve la app a Aplicaciones y la primera vez haz clic derecho → **Abrir** (no está firmada). |
| **Tu propio servidor** | ZimaOS/CasaOS con `deploy/docker-compose.yml`: consulta [`deploy/ZIMAOS.es.md`](deploy/ZIMAOS.es.md). Usa una única URL HTTPS estable (Tailscale); el almacenamiento del navegador es por origen. |

Tus datos se quedan donde está instalada la app, así que la versión de escritorio,
el APK y la versión web guardan cada uno los suyos. Pasar de una a otra es exportar e
importar.

## Actualizaciones

La app busca una versión nueva cuando se abre con conexión (como mucho una vez cada
seis horas) y muestra un aviso. Si el aviso pide una copia de seguridad, la versión
cambia la forma en que se guardan los datos: exporta primero y luego actualiza.
Después de actualizar, la app muestra qué cambió.

## Estado

Proyecto personal, con un único mantenedor. No está publicada en ninguna tienda de
apps: el APK firmado y la PWA web son las formas de instalación soportadas.

## Publicación de versiones

Etiquetar `vX.Y.Z` compila los archivos de Linux, Windows y macOS, publica la versión
web y la imagen `ghcr.io/iezappa/alveoapp`, y crea la release. El APK se compila y
firma en la máquina del mantenedor y se adjunta después: el keystore nunca llega a
CI. Consulta [`docs/RELEASING.md`](docs/RELEASING.md) y
[`docs/SIGNING.md`](docs/SIGNING.md) (en inglés).
