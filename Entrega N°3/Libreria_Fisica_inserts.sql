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

CALL sp_registrar_venta(1, 1, "117064");
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