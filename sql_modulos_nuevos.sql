-- Ejecutar en phpMyAdmin después de crear/seleccionar la base de datos nutrivifs.
USE nutrivifs;

CREATE TABLE IF NOT EXISTS citas (
  id_cita BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  rut VARCHAR(20) NOT NULL,
  correo VARCHAR(120) NOT NULL,
  telefono VARCHAR(30) NOT NULL,
  mascota VARCHAR(100) NOT NULL,
  especie VARCHAR(60) NOT NULL,
  tipo_consulta VARCHAR(120) NOT NULL,
  fecha VARCHAR(10) NOT NULL,
  motivo VARCHAR(1000) NOT NULL,
  estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
  fecha_solicitud DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS mensajes (
  id_mensaje BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) NOT NULL,
  motivo VARCHAR(30) NOT NULL,
  comentario VARCHAR(500) NOT NULL,
  fecha DATETIME NOT NULL
);

CREATE TABLE IF NOT EXISTS resenas (
  id_resena BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  producto_codigo VARCHAR(30) NOT NULL,
  correo VARCHAR(120) NOT NULL,
  autor VARCHAR(100) NOT NULL,
  puntuacion INT NOT NULL,
  comentario VARCHAR(300) NOT NULL,
  fecha DATETIME NOT NULL,
  CONSTRAINT uk_resena_producto_correo UNIQUE (producto_codigo, correo)
);
