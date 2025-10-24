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
fecha_fallecimiento DATE);

CREATE TABLE trabajador(
id_trabajador CHAR(6) PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
apellido VARCHAR(30) NOT NULL,
dni CHAR(8) NOT NULL UNIQUE CHECK((CHAR_LENGTH(TRIM(dni)) = 8 AND dni REGEXP '^[0-9]+$')),
telefono VARCHAR(20) NOT NULL);

CREATE TABLE libro(
id_libro INT AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR(100) NOT NULL,
precio DECIMAL(10,2) NOT NULL CHECK (precio > 0),
stock SMALLINT NOT NULL CHECK (stock >= 0),
anio_publicacion YEAR  NOT NULL,
id_editorial INT NOT NULL);

CREATE TABLE venta(
id_venta INT AUTO_INCREMENT PRIMARY KEY,
total_venta DECIMAL(10,2) NOT NULL,
fecha_venta DATETIME NOT NULL,
id_trabajador CHAR(6) NOT NULL);

CREATE TABLE historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
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
cantidad INT NOT NULL CHECK (cantidad > 0),
precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0),
PRIMARY KEY (id_libro, id_venta));

-- CHECK
ALTER TABLE autor ADD CONSTRAINT chk_autor_fechas CHECK(
fecha_fallecimiento IS NULL OR fecha_fallecimiento >= fecha_nacimiento);

ALTER TABLE venta ADD CONSTRAINT fk_venta_trabajador
FOREIGN KEY (id_trabajador) REFERENCES trabajador (id_trabajador);

ALTER TABLE libro ADD CONSTRAINT fk_libro_editorial
FOREIGN KEY (id_editorial) REFERENCES editorial (id_editorial);

ALTER TABLE historial_precios ADD CONSTRAINT fk_historial_precios
FOREIGN KEY (id_libro) REFERENCES libro (id_libro) ON UPDATE CASCADE;

-- GENERO_LIBRO
ALTER TABLE genero_libro ADD CONSTRAINT fk_genero_libro_id_genero
FOREIGN KEY (id_genero) REFERENCES genero(id_genero);

ALTER TABLE genero_libro ADD CONSTRAINT fk_genero_libro_id_libro
FOREIGN KEY (id_libro) REFERENCES libro(id_libro) ON UPDATE CASCADE;

-- LIBRO_AUTOR
ALTER TABLE libro_autor ADD CONSTRAINT fk_libro_autor_id_libro
FOREIGN KEY (id_libro) REFERENCES libro(id_libro) ON UPDATE CASCADE;

ALTER TABLE libro_autor ADD CONSTRAINT fk_libro_autor_id_autor
FOREIGN KEY (id_autor) REFERENCES autor(id_autor);

-- DETALLE_VENTA
ALTER TABLE detalle_venta ADD CONSTRAINT fk_detalle_venta_id_libro
FOREIGN KEY (id_libro) REFERENCES libro(id_libro) ON UPDATE CASCADE;

ALTER TABLE detalle_venta ADD CONSTRAINT fk_detalle_venta_id_venta
FOREIGN KEY (id_venta) REFERENCES venta(id_venta);


DELIMITER $$
CREATE PROCEDURE sp_registrar_venta (
	IN p_id_libro INT,
    IN p_cantidad SMALLINT,
    IN p_id_trabajador CHAR(6)
)
BEGIN 
	DECLARE v_cantidad_stock_actual SMALLINT;
    DECLARE v_precio_libro DECIMAL(10,2);
    DECLARE v_total_venta DECIMAL(10,2);
    DECLARE v_id_venta INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    IF NOT EXISTS (SELECT id_trabajador FROM trabajador WHERE id_trabajador = p_id_trabajador) THEN
    SIGNAL SQLSTATE '45000'SET MESSAGE_TEXT = 'El trabajador no existe';
	END IF;
    
    IF NOT EXISTS (SELECT id_libro FROM libro WHERE id_libro = p_id_libro) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El libro no existe';
    END IF;
    
    SELECT precio, stock INTO v_precio_libro, v_cantidad_stock_actual
    FROM libro
    WHERE id_libro = p_id_libro;
    
    IF v_cantidad_stock_actual < p_cantidad THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
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
    
    COMMIT;
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
    WHERE LOWER(a.apellido) LIKE LOWER(CONCAT('%', p_autor, '%'));
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
        (id_libro, precio_anterior, precio_nuevo, fecha_cambio)
        VALUES 
        (OLD.id_libro, OLD.precio, NEW.precio, NOW());
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

DELIMITER $$
CREATE TRIGGER tr_validar_anio_publicacion
BEFORE INSERT ON libro
FOR EACH ROW
BEGIN
    IF NEW.anio_publicacion > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El año de publicación no puede ser futuro';
    END IF;
    
    IF NEW.anio_publicacion < 1000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El año de publicación no es válido';
    END IF;
END $$
DELIMITER ;

DELIMITER $$ 
CREATE TRIGGER tr_validar_titulo_existente
BEFORE INSERT ON libro
FOR EACH ROW
BEGIN 
	IF EXISTS (SELECT 1 FROM libro WHERE 
    LOWER(TRIM(titulo)) = LOWER(TRIM(NEW.titulo))) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este titulo ya existe';
	END IF;
END $$
DELIMITER ;

/* Decidi poner ingresar todos registros validos por las dudas, pero hay validaciones con mensaje de error
como stock insuficiente o que el trabajador no exista y demas*/
