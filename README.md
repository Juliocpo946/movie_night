# Noche de Cine: Catálogo de Películas con Flutter

## Introducción

**Noche de Cine** es una aplicación móvil desarrollada en Flutter que sirve como un catálogo para explorar, calificar y gestionar películas. Este proyecto se ha construido siguiendo principios robustos de ingeniería de software, implementando **Clean Architecture** en combinación con el patrón de diseño **MVVM (Model-View-ViewModel)**. El objetivo es garantizar una estricta separación de responsabilidades, alta escalabilidad y un código mantenible.

La aplicación consume datos de la API de **The Movie Database (TMDB)** para obtener información sobre películas y gestionar las interacciones del usuario, como la autenticación y la calificación.

## Características Principales

* **Integración con TMDB:** Consume la API de TMDB para mostrar un catálogo de películas populares, realizar búsquedas y obtener detalles.
* **Autenticación de Usuario:** Permite a los usuarios iniciar sesión con sus credenciales de TMDB para acceder a funcionalidades personalizadas.
* **Gestión de Calificaciones:** Los usuarios autenticados pueden añadir, actualizar y eliminar calificaciones para cada película.
* **Lista de Favoritos:** Funcionalidad para marcar películas como favoritas y visualizarlas en una sección dedicada.
* **Navegación Declarativa:** Gestión de rutas centralizada y robusta mediante el paquete `go_router`, facilitando el mantenimiento y la escalabilidad del flujo de navegación.
* **Interfaz Reactiva:** La interfaz de usuario se actualiza de manera eficiente en respuesta a los cambios de estado, gestionados a través de `provider`.

## Arquitectura del Proyecto

El proyecto se adhiere a los principios de **Clean Architecture**, dividiendo la lógica de la aplicación en tres capas principales e independientes: Presentación, Dominio y Datos. Esta estructura se organiza aplicando **Screaming Architecture** y **Vertical Slicing**, donde el código se agrupa por funcionalidad (`feature`) en lugar de por capa.

### 1\. Capa de Presentación (Presentation)

Responsable de la interfaz de usuario y la lógica de presentación, aplicando el patrón MVVM.

* **/pages**: Contiene los widgets que componen las pantallas (Vistas). Se limitan a mostrar datos y delegar eventos del usuario al ViewModel.
* **/providers**: Contiene los `ChangeNotifier` que actúan como ViewModels. Orquestan las interacciones de la UI, gestionan el estado de la vista y se comunican con la capa de dominio a través de casos de uso.
* **/widgets**: Componentes de UI reutilizables en diferentes pantallas.

### 2\. Capa de Dominio (Domain)

El núcleo de la aplicación. Contiene la lógica de negocio y es completamente independiente de cualquier framework de UI o fuente de datos.

* **/entities**: Define los objetos puros del negocio (ej. `Movie`, `User`), sin dependencias externas.
* **/repositories**: Define los contratos (interfaces abstractas) que la capa de datos debe implementar.
* **/usecases**: Encapsula las reglas de negocio específicas y coordina la obtención de datos desde los repositorios.

### 3\. Capa de Datos (Data)

Implementa la lógica de acceso a los datos definida en la capa de dominio.

* **/models**: Contiene los Data Transfer Objects (DTOs) que mapean los datos desde las fuentes externas (API). Incluyen lógica de serialización (`fromJson`).
* **/datasources**: Clases responsables de la comunicación directa con las fuentes de datos remotas (API REST).
* **/repositories**: Implementaciones concretas de los contratos definidos en la capa de dominio. Actúan como el único punto de verdad para los datos.

## Stack Tecnológico

* **Framework:** Flutter
* **Lenguaje:** Dart
* **Arquitectura:** Clean Architecture + MVVM
* **Gestión de Estado:** `provider`
* **Navegación:** `go_router`
* **Cliente HTTP:** `http`
* **Imágenes en Red:** `cached_network_image`
* **Carrusel de UI:** `PageView` (Widget nativo de Flutter)

## Primeros Pasos

Para clonar y ejecutar este proyecto localmente, sigue los siguientes pasos.

### Prerrequisitos

Asegúrate de tener instalado el siguiente software en tu máquina:

* SDK de Flutter
* Un editor de código como Visual Studio Code o Android Studio

### Configuración

1.  **Clonar el repositorio:**

    ```bash
    git clone https://github.com/Juliocpo946/movie_night.git
    cd movie_night
    ```

2.  **Configurar las variables de entorno:**

    * Crea un archivo llamado `.env` en la raíz del proyecto.
    * Añade tu clave de API de The Movie Database (TMDB) de la siguiente manera:
      ```
      TMDB_API_KEY=tu_clave_de_api_aqui
      ```

3.  **Instalar dependencias:**

    ```bash
    flutter pub get
    ```

4.  **Ejecutar la aplicación:**

    ```bash
    flutter run
    ```

## Estructura de Carpetas

```
lib/
├── core/
│   ├── config/         # Configuración de rutas (go_router) y tema (AppTheme)
│   ├── error/          # Clases personalizadas de fallos y excepciones
│   ├── network/        # Cliente HTTP singleton
│   └── utils/          # Constantes y utilidades
│
├── features/
│   └── (ej. movies)/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── pages/
│           ├── providers/
│           └── widgets/
│
├── shared/
│   ├── domain/
│   └── widgets/        # Widgets compartidos entre features
│
└── main.dart           # Punto de entrada de la aplicación
```