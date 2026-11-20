# Guía sencilla para entender y defender el backend NutriVifs

## 1. ¿Qué es el backend?
Es la parte del sistema que recibe las solicitudes del frontend, aplica las reglas del negocio y consulta o guarda información en MySQL. El frontend muestra la información; el backend la procesa y controla quién puede hacer cada acción.

## 2. Tecnologías utilizadas
- Java 21: lenguaje de programación.
- Spring Boot: framework que permite crear la API REST.
- Spring Web: recibe solicitudes HTTP y responde en JSON.
- Spring Data JPA / Hibernate: conecta las clases Java con las tablas de MySQL.
- MySQL: base de datos relacional.
- Spring Security + JWT: autentica usuarios y protege rutas según roles.
- Bean Validation: valida los datos recibidos.
- Swagger / OpenAPI: permite revisar y probar los endpoints.

## 3. ¿Dónde está cada cosa?
Ruta principal: `src/main/java/cl/duoc/nutrivifs/`

- `NutrivifsApplication.java`: punto de entrada; inicia Spring Boot.
- `auth/`: login, registro y emisión de tokens.
- `security/`: filtro JWT, lectura de token y reglas de acceso.
- `usuario/`: entidad, repositorio, servicio y controladores de usuarios y roles.
- `producto/`: productos y categorías del catálogo.
- `servicio/`: servicios veterinarios y sus categorías.
- `boleta/`: compras, boletas y detalles de cada compra.
- `cita/`: solicitudes de hora veterinaria.
- `mensaje/`: mensajes enviados desde el formulario de contacto.
- `resena/`: opiniones y puntuaciones de productos.
- `archivo/`: endpoint que recibe imágenes.
- `config/`: configuración de OpenAPI y publicación de archivos.
- `exception/`: manejo centralizado de errores.
- `util/`: utilidades, por ejemplo conversión de códigos de productos.

## 4. ¿Qué significa cada capa?
Ejemplo usando `cita/`:

- `model/Cita.java`: representa una cita y se guarda como una fila de la tabla `citas`.
- `repository/CitaRepository.java`: consulta y guarda citas en MySQL. Extiende `JpaRepository`.
- `service/CitaService.java`: contiene las reglas del negocio, como crear una cita, comprobar su fecha y cambiar su estado.
- `controller/CitaController.java`: recibe las peticiones HTTP y llama al servicio.
- `dto/`: define qué datos se reciben o devuelven por la API. Evita exponer directamente la entidad cuando no es necesario.

## 5. Flujo de una solicitud
1. Una persona completa un formulario en React.
2. React envía una petición HTTP a una ruta `/api/v1/...`.
3. Spring Security comprueba si la ruta es pública o requiere token y rol.
4. El Controller recibe los datos.
5. El Service aplica validaciones y reglas del negocio.
6. El Repository utiliza JPA/Hibernate para consultar o guardar en MySQL.
7. El Controller devuelve una respuesta JSON y un código HTTP.
8. React muestra el resultado.

## 6. Métodos HTTP
- GET: consultar información.
- POST: crear o enviar información.
- PUT: reemplazar/actualizar un recurso.
- PATCH: cambiar una parte de un recurso, por ejemplo el estado de una cita.
- DELETE: eliminar un recurso.

## 7. Endpoints principales

### Autenticación
- `POST /api/v1/auth/registro`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/refresh`
- `GET /api/v1/auth/me`

### Productos
- `GET /api/v1/productos`
- `GET /api/v1/productos/{id}`
- `POST /api/v1/productos`
- `PUT /api/v1/productos/{id}`
- `DELETE /api/v1/productos/{id}`

### Citas
- `POST /api/v1/citas`: crear solicitud; no requiere sesión.
- `GET /api/v1/citas`: listar para administrador/vendedor.
- `GET /api/v1/citas/mias`: citas del usuario autenticado.
- `PATCH /api/v1/citas/{id}/estado`: cambiar estado; administrador.

### Mensajes
- `POST /api/v1/mensajes`: enviar mensaje; público.
- `GET /api/v1/mensajes`: revisar bandeja; administrador/vendedor.
- `DELETE /api/v1/mensajes/{id}`: borrar; administrador.

### Reseñas
- `GET /api/v1/resenas/producto/{productoId}`: consultar reseñas; público.
- `POST /api/v1/resenas`: crear o actualizar la reseña del usuario autenticado.
- `DELETE /api/v1/resenas/{id}`: borrar la propia reseña o moderar como administrador.

### Imágenes
- `POST /api/v1/archivos/imagen`: subir archivo en `multipart/form-data`, campo `archivo`; solo administrador.
- La respuesta incluye una ruta `/uploads/...` que puede guardarse en el campo `image` del producto.

## 8. Conceptos importantes para la defensa

### ¿Qué es una API REST?
Es una forma de comunicación entre sistemas usando HTTP. En este proyecto React solicita recursos al backend mediante rutas y métodos como GET y POST.

### ¿Qué es JPA?
Es una especificación para trabajar con persistencia en Java. En el proyecto Spring Data JPA facilita las operaciones con MySQL y Hibernate implementa el mapeo objeto-relacional.

### ¿Qué es una entidad?
Es una clase Java marcada con `@Entity` que representa una tabla de la base de datos.

### ¿Qué es un Repository?
Es la capa que accede a los datos. Al extender `JpaRepository`, obtiene operaciones comunes como `save`, `findAll`, `findById` y `delete`.

### ¿Qué es un DTO?
Es un objeto para transportar datos entre frontend y backend. Permite definir qué campos entran y salen sin exponer toda la entidad.

### ¿Qué es JWT?
Es un token firmado que el frontend envía en el encabezado `Authorization: Bearer ...`. El filtro JWT valida el token y reconoce al usuario y su rol.

### ¿Por qué se separa Controller, Service y Repository?
Para mantener responsabilidades claras: Controller atiende HTTP, Service aplica reglas del negocio y Repository trabaja con la base de datos. Esto facilita mantener y probar el código.

### ¿Qué es CORS?
Es una política del navegador. La configuración CORS permite que el frontend que corre en `localhost:5173` pueda llamar al backend en `localhost:8080`.

## 9. Preguntas de práctica con respuestas

**1. ¿Cuál es la función del backend?**
Recibir solicitudes del frontend, validar datos, ejecutar reglas del negocio, consultar o guardar información en MySQL y devolver respuestas.

**2. ¿Qué ocurre cuando un cliente agenda una cita?**
El frontend envía un POST a `/api/v1/citas`. El Controller recibe el JSON, el Service valida la fecha y los datos, el Repository guarda la cita y la API devuelve la cita creada.

**3. ¿Por qué usamos MySQL?**
Porque necesitamos almacenar información de forma persistente y organizada en tablas relacionadas.

**4. ¿Por qué no guardamos todo en el frontend?**
Porque los datos del navegador son locales a ese dispositivo. La base de datos central permite que distintos usuarios y administradores trabajen con la misma información.

**5. ¿Cómo protegemos las rutas?**
Spring Security revisa las rutas y el token JWT. Según el rol, permite o deniega las operaciones.

**6. ¿Qué diferencia hay entre 401 y 403?**
401 significa que falta una autenticación válida. 403 significa que el usuario está autenticado, pero no tiene permiso para esa acción.

**7. ¿Qué hace el Service?**
Contiene las reglas del negocio y coordina las operaciones con los repositorios.

**8. ¿Qué pasa si se intenta borrar una reseña ajena?**
El servicio comprueba el correo del autor. Si no coincide y la persona no es administradora, rechaza la operación.

**9. ¿Qué hace Swagger?**
Documenta los endpoints y permite probar solicitudes sin tener que crear primero una pantalla frontend.

**10. ¿Cómo se conecta React con Spring Boot?**
Mediante Axios, usando la dirección base `http://localhost:8080/api/v1`. Para rutas protegidas, Axios agrega el token JWT al encabezado Authorization.

## 10. Qué debes decir con honestidad en la defensa
El backend contiene los endpoints para citas, mensajes, reseñas y subida de imágenes. Sin embargo, el frontend que fue entregado todavía guarda citas, mensajes y reseñas en localStorage. Por eso, para demostrar el flujo completo desde la interfaz hasta MySQL, todavía se debe integrar React con esos endpoints y probarlo.

No digas que una función fue probada si no la ejecutaste. Muestra las pruebas que realmente hayas realizado.
