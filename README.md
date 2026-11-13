# backend-nutrivifs

Backend de la tienda **Clínica NutriVifs** (Evaluación Parcial 3, DSY1104 Desarrollo Fullstack II).
API REST en Spring Boot 4 + MySQL, con Spring Security, JWT por roles y documentación en Swagger.

## Requisitos

- Java 21
- MySQL (XAMPP) en `localhost:3306`, usuario `root` sin contraseña
- IntelliJ IDEA o Maven

## Cómo ejecutarlo

1. Encender MySQL en XAMPP. La base `nutrivifs` se crea sola (`createDatabaseIfNotExist=true`).
2. Ejecutar `NutrivifsApplication` desde IntelliJ (o `mvnw spring-boot:run`).
3. Al iniciar, `config/DatosIniciales` carga los roles, las cuentas de prueba, las 9 categorías,
   los 22 productos, las 5 categorías de servicios y los 27 servicios, solo si las tablas están vacías.
4. Swagger: http://localhost:8080/swagger-ui.html

`src/main/resources/scripts_poblado.sql` tiene los mismos datos como alternativa manual (solo con tablas vacías).

### Cuentas de prueba

| Rol | Correo | Contraseña |
|---|---|---|
| Administrador | admin@duoc.cl | Admin123 |
| Vendedor | vendedor@duoc.cl | Vende123 |
| Cliente | cliente@gmail.com | Cliente1 |

## Estructura (por módulo)

```
cl.duoc.nutrivifs
├── producto   productos y categorías de productos (controller, service, repository, model, dto)
├── servicio   servicios de la clínica y sus categorías
├── usuario    usuarios y roles
├── boleta     compras: boletas y detalle de boleta
├── auth       login, registro, renovación del token
├── security   JwtService, FiltroJwt y SecurityConfig (permisos por rol y CORS)
├── config     Swagger y datos iniciales
├── exception  errores de negocio y manejador global (respuestas JSON con "mensaje")
└── util       conversión id <-> código del frontend (ME001, CAT01, SE001, ORD-0001)
```

Modelo de datos: `usuarios` → `boletas` → `detalles_boleta` ← `productos` ← `categorias_productos`
(más `roles`, `servicios` y `categorias_servicios`).

## Lógica de negocio

- Compra (`POST /api/v1/boletas`): valida el stock, lo descuenta, aplica el cupón `NUTRI10` (10 %) y guarda
  la boleta con su detalle en una sola transacción. El precio sale de la base de datos, no del frontend.
- Login: contraseñas cifradas con BCrypt; la cuenta se bloquea al tercer intento fallido.
- Registro público: siempre crea un Cliente. Edad mínima 14 años; contraseña de 4 a 10 caracteres con una mayúscula.
- No se puede eliminar un producto que ya está en boletas, una categoría con productos, ni un usuario con compras.
- Estados de una boleta: Entrega pendiente, Listo, Enviado.

## Endpoints (`/api/v1`)

| Método | Ruta | Acceso |
|---|---|---|
| POST | /auth/login | Público |
| POST | /auth/registro | Público |
| POST | /auth/refresh | Con sesión |
| GET | /auth/me | Con sesión |
| GET | /productos, /productos/{id} | Público |
| POST, PUT, DELETE | /productos, /productos/{id} | Administrador |
| GET | /productos/categorias, /productos/categorias/{id} | Público |
| POST, PUT, DELETE | /productos/categorias, /productos/categorias/{id} | Administrador |
| GET | /servicios, /servicios/{id}, /servicios/categorias | Público |
| POST, PUT, DELETE | /servicios..., /servicios/categorias... | Administrador |
| POST | /boletas | Con sesión (compra) |
| GET | /boletas/mias | Con sesión |
| GET | /boletas, /boletas/{id} | Administrador y Vendedor |
| PATCH | /boletas/{id}/estado | Administrador |
| GET, POST, PUT, DELETE | /usuarios, /usuarios/{id} | Administrador |
| PATCH | /usuarios/{id}/desbloquear | Administrador |
| PUT | /usuarios/me | Con sesión |
| GET | /usuarios/roles | Administrador |

Las rutas protegidas reciben el header `Authorization: Bearer <token>`. Sin token responden 401 y con un rol
sin permiso responden 403.

## Pruebas

- `BoletaServiceTest`: pruebas unitarias con Mockito de la compra (stock insuficiente, cupón y descuento de stock).
- Swagger: botón **Authorize**, pegar el token que devuelve `/auth/login`.
