DROP DATABASE IF EXISTS LibreriaFisica;
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
id_trabajador CHAR(6) PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
apellido VARCHAR(30) NOT NULL,
dni CHAR(8) NOT NULL,
telefono VARCHAR(20) NOT NULL);

CREATE TABLE libro(
id_libro INT AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR(100) NOT NULL,
precio DECIMAL(10,2) NOT NULL,
stock TINYINT UNSIGNED NOT NULL DEFAULT 0,
anio_publicacion YEAR  NOT NULL,
id_editorial INT NOT NULL);

CREATE TABLE venta(
id_venta INT AUTO_INCREMENT PRIMARY KEY,
total_venta DECIMAL(10,2) NOT NULL,
fecha_venta DATETIME NOT NULL,
id_trabajador CHAR(6) NOT NULL);

CREATE TABLE historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100),
    precio_anterior DECIMAL(10,2),
    precio_nuevo DECIMAL(10,2),
    fecha_cambio DATETIME,
    id_libro INT NOT NULL
);

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
precio_unitario DECIMAL(10,2) NOT NULL,
PRIMARY KEY (id_libro, id_venta));

ALTER TABLE venta ADD CONSTRAINT fk_venta_trabajador
FOREIGN KEY (id_trabajador) REFERENCES trabajador (id_trabajador);

ALTER TABLE libro ADD CONSTRAINT fk_libro_editorial
FOREIGN KEY (id_editorial) REFERENCES editorial (id_editorial);

ALTER TABLE historial_precios ADD CONSTRAINT fk_historial_precios
FOREIGN KEY (id_libro) REFERENCES libro (id_libro);

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

-- INSERTS DE DATOS

INSERT INTO editorial VALUES 
(NULL, "Albatros", "Argentina", "elAlbatros001@gmail.com"),
(NULL, "Bonum", "Argentina", "BonumArgentina@gmail.com"),
(NULL, "SAGE Publications", "Estados Unidos", "SAGEPublicationsEEUU@gmail.com"),
(NULL, "Mezhdunaródnaya Kniga", "Rusia", "KnigaEditorialRusia@gmail.com"),
(NULL, "Penguin Random House", "Estados Unidos", "thePenguin549@gmail.com"),
(NULL, "Olivia", "Argentina", "OliviaEditoriales@gmail.com"),
(NULL, "Fizmatlit", "Rusia", "FizmatlitRusia@gmail.com"),
(NULL, "Océano Argentina", "Argentina", "OceanoArgentina4@gmail.com"),
(NULL, "Espasa", "España", "EspasaEspaña@gmail.com"),
(NULL, "Himpar Editores", "Colombia", "HimparEditores564@gmail.com");

INSERT INTO genero VALUES 
(NULL, "Terror"),
(NULL, "Accion"),
(NULL, "Ciencia-Ficcion"),
(NULL, "Fantasia"),
(NULL, "Aventuras"),
(NULL, "Policial"),
(NULL, "Paranormal"),
(NULL, "Cocina"),
(NULL, "Viajes"),
(NULL, "Conocimiento"),
(NULL, "Novela"),
(NULL, "Romance");

INSERT INTO autor VALUES
(NULL, "Santiago Hernan", "Gonzalez", "Argentina", "2004-06-12", NULL),
(NULL, "Victoria Ayelen", "Olmos", "Argentina", "2004-09-21", NULL),
(NULL, "Elena  Svetlana ", "Volkova", "Rusia", "1994-08-25", NULL),
(NULL, "Ellie Xiomena", "Williams ", "Estados Unidos", "1986-01-16", "2021-02-3"),
(NULL, "Antonio Manuel", "García ", "España", "1992-05-19", NULL),
(NULL, "Isabella  Celeste ", "Hernández", "Colombia", "1956-03-24", "2017-09-8"),
(NULL, "Sabrina Agustina", "Peralta", "Peru", "1997-07-4", NULL),
(NULL, "Iván  Dmitri ", "Petrov", "Rusia", "1968-04-3", "2020-06-14");

INSERT INTO trabajador VALUES
("117064", "Jose Matias", "Rodriguez", "43978365", "1135587896"),
("789536", "Jisela Maria", "Peralta", "45695143","1154695236");

INSERT INTO libro VALUES
(NULL, "NodeJS", 54000.47, 24, "2015", 3),
(NULL, "JavaScript", 62700.24, 34, "2015", 3),
(NULL, "Rubi", 37400.17, 8, "2013", 4),
(NULL, "La Casa Embrujada", 18000, 5, "1994", 1),
(NULL, "El Investigador Raul", 10750.17, 13, "2000", 1),
(NULL, "Metro 2033", 20387.99, 21, "2011", 7),
(NULL, "Invisible Man", 28144.18, 8, "1952", 5),
(NULL, "Libro Maradona", 14400.75, 8, "2022", 2),
(NULL, "Tres Metros Sobre El Cielo", 5000, 3, "2015", 9),
(NULL, "Romance en Buenos Aires", 2000.15, 8, "2003", 6),
(NULL, "Animales Sur America", 16400.17, 8, "2007", 8),
(NULL, "Pablo Escobar", 1000.19, 8, "1999", 10),
(NULL, "The Grapes of Wrath", 22000.69, 15, "1939", 5),
(NULL, "Metro 2034", 23487.20, 12, "2011", 7),
(NULL, "Metro 2035", 21368.50, 10, "2016", 7);

INSERT INTO genero_libro VALUES 
(3, 6), (2, 6), (5, 6),
(10, 1),
(10, 2), 
(10, 3),
(1, 4), (3, 4), (4, 4), (7, 4),
(2, 5), (6, 5),
(2, 7), (9, 7),
(4, 9), (11, 9), (12, 9),
(10, 8), 
(11, 10), (12, 10), 
(10, 11), (9, 11), 
(2, 12), (6, 12),
(8, 13),
(3, 14), (2, 14), (5, 14),
(3, 15), (2, 15), (5, 15);
 
INSERT INTO libro_autor VALUES
(1, 4), (1, 3), (1, 1),
(2, 4), (2, 2),
(3, 1), (3, 2), (3, 3),
(4, 7),
(5, 5), (5, 6),
(6, 8),
(7, 7), (7, 5),
(8, 1), (8, 2), (8, 6),
(9, 5),
(10, 2),
(11, 1), (11, 7), (11, 6),
(12, 6),(12, 7),
(13, 4),
(14, 8),
(15, 8);

DELIMITER $$
CREATE PROCEDURE sp_registrar_venta (
	IN p_id_libro INT,
    IN p_cantidad TINYINT,
    IN p_id_trabajador CHAR(6)
)
BEGIN 
	DECLARE v_cantida_stock_actual TINYINT;
    DECLARE v_precio_libro DECIMAL(10,2);
    DECLARE v_total_venta DECIMAL(10,2);
    DECLARE v_id_venta INT;
    DECLARE v_id_trabajador CHAR(6);
    
    SELECT precio, stock INTO v_precio_libro, v_cantida_stock_actual
    FROM libro
    WHERE id_libro = p_id_libro;
    
    IF NOT EXISTS (SELECT id_libro FROM libro WHERE id_libro = p_id_libro) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El libro no existe';
    END IF;
    
    IF v_cantida_stock_actual < p_cantidad THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
    END IF;
    
    IF NOT EXISTS (SELECT id_trabajador FROM trabajador WHERE id_trabajador = p_id_trabajador) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El trabajador no existe';
	END IF;
    
    SET v_total_venta = v_precio_libro * p_cantidad;
	
    INSERT INTO venta (id_venta, total_venta, fecha_venta, id_trabajador) VALUES
    (NULL, v_total_venta, now(), p_id_trabajador);
    
    UPDATE libro 
    SET stock = stock - p_cantidad
    WHERE id_libro = p_id_libro;
    
    SET v_id_venta = LAST_INSERT_ID();
    
    INSERT INTO detalle_venta (id_libro, id_venta, cantidad, precio_unitario) VALUES
    (p_id_libro, v_id_venta, p_cantidad, v_precio_libro);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_buscar_por_autor_apellido(
	IN p_autor VARCHAR (30)
)
BEGIN 
	SELECT a.nombre, a.apellido, l.titulo, l.precio, l.stock FROM autor a
    INNER JOIN libro_autor la ON la.id_autor = a.id_autor
    INNER JOIN libro l ON l.id_libro = la.id_libro
    WHERE LOWER(a.apellido) LIKE LOWER(concat('%', p_autor, '%'));
END $$
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_trabajador_max_ventas()
RETURNS VARCHAR (100)
DETERMINISTIC 
BEGIN 
	DECLARE v_nombre_completo VARCHAR(100);
    
    SELECT  CONCAT(t.nombre, " ", t.apellido) INTO v_nombre_completo
	FROM trabajador t
    INNER JOIN venta v ON v.id_trabajador = t.id_trabajador
	GROUP BY t.id_trabajador
	ORDER BY COUNT(*) DESC LIMIT 1;
    RETURN v_nombre_completo;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION fn_cantidad_ventas_tiempo (p_fecha_inicio DATE, p_fecha_fin DATE)
RETURNS INT 
DETERMINISTIC 
BEGIN 
	DECLARE v_cantidad_ventas INT;
    
    SELECT COUNT(*) INTO v_cantidad_ventas FROM venta 
    WHERE fecha_venta BETWEEN p_fecha_inicio AND p_fecha_fin;
    RETURN v_cantidad_ventas;
END //
DELIMITER ;

CREATE VIEW vw_ventas_por_autor AS
SELECT a.nombre, a.apellido, COUNT(dv.id_libro) AS cantidad_libros_vendidos
FROM autor a
INNER JOIN libro_autor la ON a.id_autor = la.id_autor
INNER JOIN detalle_venta dv ON la.id_libro = dv.id_libro
GROUP BY a.id_autor, a.nombre, a.apellido
ORDER BY cantidad_libros_vendidos DESC;

CREATE VIEW vw_inventario_por_editorial AS
SELECT e.nombre AS editorial, COUNT(l.id_libro) AS cantidad_titulos, 
SUM(l.stock) AS total_stock, 
SUM(l.stock * l.precio) AS valor_inventario
FROM editorial e
LEFT JOIN libro l ON e.id_editorial = l.id_editorial
GROUP BY e.id_editorial, e.nombre
ORDER BY valor_inventario DESC;

CREATE VIEW vw_libros_sin_vender AS
SELECT l.id_libro, l.titulo, l.stock,
l.precio, e.nombre AS editorial, l.anio_publicacion
FROM libro l
INNER JOIN editorial e ON l.id_editorial = e.id_editorial
LEFT JOIN detalle_venta dv ON l.id_libro = dv.id_libro
WHERE dv.id_libro IS NULL AND l.stock > 0
ORDER BY l.anio_publicacion DESC;

DELIMITER $$
CREATE TRIGGER tr_auditar_cambio_precio
BEFORE UPDATE ON libro
FOR EACH ROW
BEGIN
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO historial_precios 
        (id_libro, titulo, precio_anterior, precio_nuevo, fecha_cambio)
        VALUES 
        (OLD.id_libro, OLD.titulo, OLD.precio, NEW.precio, NOW());
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tr_validar_dni_unico
BEFORE INSERT ON trabajador
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM trabajador WHERE dni = NEW.dni) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El DNI ya existe en el sistema';
    END IF;
END $$
DELIMITER ;

CALL sp_registrar_venta(1, 15, "117064");
CALL sp_registrar_venta(13, 10, "117064");
CALL sp_registrar_venta(14, 4, "789536");
CALL sp_registrar_venta(7, 4, "117064");
CALL sp_registrar_venta(2, 4, "117064");
CALL sp_registrar_venta(12, 5, "789536");
CALL sp_registrar_venta(3, 6, "789536");
CALL sp_registrar_venta(6, 5, "117064"); 
CALL sp_registrar_venta(8, 8, "789536");
CALL sp_registrar_venta(10, 7, "117064");
CALL sp_registrar_venta(15, 7, "789536");

/* Decidi poner ingresar todos registros validos por las dudas, pero hay validaciones con mensaje de error
como stock insuficiente o que el trabajador no exista y demas*/