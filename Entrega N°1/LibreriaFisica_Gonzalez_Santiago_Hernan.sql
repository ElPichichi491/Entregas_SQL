CREATE SCHEMA LibreriaFisica;
USE LibreriaFisica;

CREATE TABLE editorial(
id_editorial INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
pais VARCHAR(20) NOT NULL,
email VARCHAR(35) NOT NULL);

CREATE TABLE genero(
id_genero INT AUTO_INCREMENT PRIMARY KEY,
tipo_genero VARCHAR(30) NOT NULL);

CREATE TABLE autor(
id_autor INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
apellido VARCHAR(30) NOT NULL,
nacionalidad VARCHAR(20) NOT NULL,
fecha_nacimiento DATE NOT NULL,
fecha_fallecimiento DATE NULL);

CREATE TABLE trabajador(
id_trabajador INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
apellido VARCHAR(30) NOT NULL,
dni VARCHAR(20) NOT NULL,
telefono VARCHAR(20) NOT NULL);

CREATE TABLE libro(
id_libro INT AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR(100) NOT NULL,
precio DECIMAL(6,2) NOT NULL,
stock TINYINT UNSIGNED NOT NULL DEFAULT 0,
anio_publicacion YEAR  NOT NULL,
id_editorial INT NOT NULL);

CREATE TABLE venta(
id_venta INT AUTO_INCREMENT PRIMARY KEY,
total_venta DECIMAL(10,2) NOT NULL,
fecha_venta DATETIME NOT NULL,
id_trabajador INT NOT NULL);

CREATE TABLE genero_libro(
id_genero INT NOT NULL,
id_libro INT NOT NULL,
PRIMARY KEY (id_genero, id_libro));

CREATE TABLE libro_autor(
id_libro INT NOT NULL,
id_autor INT NOT NULL,
PRIMARY KEY (id_libro, id_autor));

CREATE TABLE detalle_venta(
id_libro INT NOT NULL,
id_venta INT NOT NULL,
cantidad INT NOT NULL,
precio_unitario DECIMAL(8,2) NOT NULL,
PRIMARY KEY (id_libro, id_venta));

ALTER TABLE venta ADD CONSTRAINT fk_venta_trabajador
FOREIGN KEY (id_trabajador) REFERENCES trabajador (id_trabajador);

ALTER TABLE libro ADD CONSTRAINT fk_libro_editorial
FOREIGN KEY (id_editorial) REFERENCES editorial (id_editorial);

-- GENERO_LIBRO
ALTER TABLE genero_libro ADD CONSTRAINT fk_genero_libro_id_genero
FOREIGN KEY (id_genero) REFERENCES genero(id_genero);

ALTER TABLE genero_libro ADD CONSTRAINT fk_genero_libro_id_libro
FOREIGN KEY (id_libro) REFERENCES libro(id_libro);

-- LIBRO_AUTOR
ALTER TABLE libro_autor ADD CONSTRAINT fk_libro_autor_id_libro
FOREIGN KEY (id_libro) REFERENCES libro(id_libro);

ALTER TABLE libro_autor ADD CONSTRAINT fk_libro_autor_id_autor
FOREIGN KEY (id_autor) REFERENCES autor(id_autor);

-- DETALLE_VENTA
ALTER TABLE detalle_venta ADD CONSTRAINT fk_detalle_venta_id_libro
FOREIGN KEY (id_libro) REFERENCES libro(id_libro);

ALTER TABLE detalle_venta ADD CONSTRAINT fk_detalle_venta_id_venta
FOREIGN KEY (id_venta) REFERENCES venta(id_venta);









