# Servir Alveo desde un servidor ZimaOS

[English](ZIMAOS.md) · **Español**

Esto sirve la versión web/PWA de Alveo desde un servidor ZimaOS doméstico, para
que las personas de un hogar puedan instalarla sin pasar por GitHub Pages.

**Lee esto primero: el servidor solo sirve la app.** Registros, entradas del
diario, notas de sesión (todo lo que guarda Alveo) se quedan en el
almacenamiento del navegador de cada persona, en su propio dispositivo. Nada de
eso llega a este servidor, y el contenedor no tiene volumen ni base de datos.
Dos personas que usan el mismo servidor no comparten nada ni ven nada de la
otra. Recrear o actualizar el contenedor no pierde nada, porque no hay nada en
él que perder.

La contracara: la única copia de seguridad es la exportación de cada persona
(Ajustes → Tus datos → Exportar copia). Nadie puede recuperar sus datos desde el
servidor, porque nunca estuvieron ahí.

## Requisitos

- ZimaOS con acceso a su interfaz web y a internet.
- Una versión publicada por `.github/workflows/release.yml`, que sube
  `ghcr.io/iezappa/alveoapp:<version>` y `:latest` para amd64 y arm64.

## 1. Publicar la imagen

```bash
git tag v1.0.0 && git push origin v1.0.0
```

La primera vez, haz público el paquete: GitHub → Packages → el paquete →
Package settings → Change visibility → Public. ZimaOS no puede descargar un
paquete privado sin credenciales.

## 2. Instalarla

1. En ZimaOS abre **App Store** → **"+"** → **Install a customized app**.
2. Usa **Import** y pega `deploy/docker-compose.yml` tal como está. Ya indica la
   imagen, el puerto (8083) y el ícono; cambia el puerto solo si otra cosa en el
   servidor lo usa.
3. **Install**, y luego comprueba que `http://<zimaos-ip>:8083` carga. Esa URL
   es solo para comprobar: mira la sección siguiente.

Los nombres de los menús cambian entre versiones de ZimaOS; busca en el App
Store la opción de instalación personalizada o de "import docker-compose".

## 3. HTTPS para todos los demás, con Tailscale

Instalar una PWA, el service worker y el almacenamiento OPFS necesitan un
contexto seguro. `http://IP:puerto` carga en un navegador, pero no se puede
instalar y pierde el funcionamiento sin conexión, así que no es una forma de
darle la app a alguien.

1. Instala **Tailscale** desde el App Store de ZimaOS e inicia sesión.
2. En la consola de administración de Tailscale activa **MagicDNS** y **HTTPS
   Certificates**.
3. En el servidor:

   ```bash
   tailscale serve --bg http://127.0.0.1:8083
   tailscale serve status
   ```

   Si Tailscale corre como contenedor, ejecútalo dentro de ese contenedor
   apuntando a la dirección LAN del servidor en lugar de `127.0.0.1`.
4. La app queda entonces en `https://<server>.<your-tailnet>.ts.net/`.
5. Cada persona instala Tailscale en su dispositivo y se une a la tailnet.

**Usa siempre la URL `ts.net`, también en casa.** El almacenamiento del
navegador es por origen: los datos escritos al visitar la IP de la LAN no
existen al visitar el nombre `ts.net`, y la app se verá vacía. Una sola URL, en
todas partes.

## 4. Instalación en cada dispositivo

| Dispositivo | Cómo |
|---|---|
| iPhone / iPad | Abre la URL `ts.net` en **Safari** → Compartir → **Agregar a la pantalla de inicio**. Ábrela siempre desde ese ícono: una web app instalada y en uso conserva su almacenamiento; una pestaña de Safari puede perderlo tras una semana sin visitarla. |
| Android | Chrome → menú → **Instalar app**. O el APK firmado de GitHub Releases, que no necesita ningún servidor. |
| Windows / macOS / Linux | Chrome o Edge → el ícono de instalación en la barra de direcciones. O la versión de escritorio de GitHub Releases. |

Después de instalarla, ábrela una vez con conexión y comprueba que una
exportación funciona.

## 5. Actualizar

1. Sube una etiqueta nueva; el workflow actualiza `:latest`.
2. En ZimaOS, actualiza la app (o `docker pull ghcr.io/iezappa/alveoapp:latest`)
   y reiníciala para que se recree el contenedor.
3. La próxima vez que alguien abra la app con conexión, el service worker
   descarga la versión nueva en segundo plano y la app muestra "Hay una versión
   nueva". Nada cambia debajo de una página en uso hasta que se toca
   Actualizar.

Cuando una versión cambia el esquema local, la migración corre en cada
dispositivo, sobre la única copia de los datos de esa persona. Por eso mismo el
aviso pide antes una copia de seguridad: dilo también en las notas de la
versión.
