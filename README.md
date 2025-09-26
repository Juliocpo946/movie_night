Claro, aquí tienes una plantilla profesional para el archivo `README.md` de tu repositorio en GitHub.

-----

# Noche de Cine: Aplicación de Catálogo de Películas

## Introducción

**Noche de Cine** es una aplicación móvil desarrollada en Flutter que funciona como un catálogo para explorar películas populares. El proyecto está construido siguiendo principios de software robustos, utilizando **Clean Architecture** en conjunto con el patrón de diseño **MVVM (Model-View-ViewModel)** para garantizar una clara separación de responsabilidades, alta escalabilidad y un código mantenible.

La gestión del estado se maneja a través del paquete `provider`, mientras que la persistencia de datos locales para la autenticación de usuarios se implementa con una base de datos **SQLite**.

## Características Principales

* **Autenticación Local:** Sistema de registro e inicio de sesión de usuarios persistido localmente a través de una base de datos SQLite.
* **Catálogo de Películas:** Visualización de películas populares obtenidas desde una API externa (The Movie Database).
* **Interfaz de Usuario Reactiva:** La UI se actualiza de manera eficiente en respuesta a los cambios de estado gestionados por el ViewModel.
* **Seguridad de Vistas:** Implementación de medidas para restringir la captura de pantalla en vistas con información sensible.
* **Navegación Declarativa:** Gestión de rutas centralizada y robusta mediante el paquete `go_router`.

## Arquitectura del Proyecto

El proyecto se adhiere a los principios de **Clean Architecture**, dividiendo la lógica de la aplicación en tres capas principales e independientes: Presentación, Dominio y Datos.

### 1\. Capa de Presentación (Presentation)

Responsable de la interfaz de usuario y la lógica de presentación.

* **/view**: Contiene los widgets que componen las pantallas de la aplicación. Estos componentes son "tontos" y se limitan a mostrar datos y delegar eventos del usuario al ViewModel.
* **/viewmodel**: Contiene los `ChangeNotifier` que actúan como el ViewModel en el patrón MVVM. Orquestan las interacciones de la UI, gestionan el estado y se comunican con la capa de dominio a través de casos de uso.

### 2\. Capa de Dominio (Domain)

El núcleo de la aplicación. Contiene la lógica de negocio y es completamente independiente de cualquier framework de UI o fuente de datos.

* **/entities**: Define los objetos puros del negocio (ej. `Movie`, `User`), sin dependencias externas.
* **/repositories**: Define los contratos (interfaces abstractas) que establecen qué operaciones de datos se pueden realizar.
* **/usecases**: Encapsula las reglas de negocio específicas y orquesta la obtención de datos desde los repositorios.

### 3\. Capa de Datos (Data)

Implementa la lógica de acceso a los datos definidos en la capa de dominio.

* **/models**: Contiene los Data Transfer Objects (DTOs) que mapean los datos desde las fuentes externas (API, base de datos). Incluyen lógica de serialización (`fromJson`, `toJson`).
* **/datasources**: Clases responsables de la comunicación directa con las fuentes de datos, ya sean remotas (API REST con Dio) o locales (base de datos SQLite).
* **/repositories**: Implementaciones concretas de los contratos definidos en la capa de dominio. Actúan como el único punto de verdad para los datos, decidiendo si obtenerlos de una fuente local o remota.

## Stack Tecnológico

* **Framework:** Flutter 3.x
* **Lenguaje:** Dart
* **Arquitectura:** Clean Architecture + MVVM
* **Gestión de Estado:** `provider`
* **Navegación:** `go_router`
* **Base de Datos Local:** `sqflite`
* **Cliente HTTP:** `dio`
* **Imágenes en Red:** `cached_network_image`

## Configuración del Proyecto

Para clonar y ejecutar este proyecto localmente, sigue estos pasos:

1.  **Clonar el repositorio:**

    ```bash
    git clone https://github.com/Juliocpo946/movie_night.git
    cd movie_night
    ```

2.  **Obtener dependencias:**

    ```bash
    flutter pub get
    ```

3.  **Configurar variables de entorno (si aplica):**

    * Crea un archivo `.env` en la raíz del proyecto.
    * Añade las claves de API necesarias (ej. `THE_MOVIE_DB_API_KEY=tu_clave_aqui`).

4.  **Ejecutar la aplicación:**

    ```bash
    flutter run
    ```

## Estructura de Carpetas

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── movies/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── core/
│   ├── config/
│   ├── services/
│   └── ...
└── main.dart
```