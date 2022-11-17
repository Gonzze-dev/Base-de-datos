--PAIS
INSERT INTO pais (nombre)
VALUES  ('Argentina'),
        ('Chile'),
        ('Uruguay'),
        ('Colombia'),
        ('Paraguay'),
        ('Brasil'),
        ('Bolivia'),
        ('Bahamas'),
        ('Costa Rica'),
        ('Cuba'),
        ('Republica Dominica'),
        ('Ecuador'),
        ('El Salvador'),
        ('Granada'),
        ('Mexico');

--PROVINCIA
INSERT INTO provincia (nombre, id_pais)
VALUES  ('Entre Rios', 1),
        ('Buenos Aires', 1),
        ('Puente Alto', 2),
        ('Maipú', 2),
        ('Santiago', 2),
        ('Cordoba', 1),
        ('Rosario', 1),
        ('Salta', 1),
        ('Santa Fe', 1),
        ('Cuba', 1),
        ('Montevideo', 3),
        ('Salto', 3),
        ('Tacuarembó', 3),
        ('Flores', 3),
        ('Florida', 3);
        
--CIUDAD
INSERT INTO ciudad (cp, nombre, id_provincia)
VALUES  (2820, 'Gualeguaychuu', 1),
        (3260, 'Concepcion del Uruguay', 1),
        (3100, 'Parana', 1),
        (3174, 'Rosario del Tala', 1),
        (2840, 'Gualeguay', 1),
        (4312, 'Mar del plata', 3),
        (1233, 'Bahia blanca', 3),
        (1234, 'Tigre', 3),
        (3105, 'Diamante', 3),
        (3280, 'Colon', 1),
        (3206, 'La Paz', 1),
        (3185, 'Federacion', 1),
        (2139, 'Villaguay', 1),
        (2421, 'Nogoya', 1),
        (2881,'San salvador', 1);

--IDIOMA
INSERT INTO idioma (nombre)
VALUES  ('Español'),
        ('Ingles'),
        ('Japones'),
        ('Chino'),
        ('Portugues'),
        ('Frances'),
        ('Arabe'),
        ('Hindi'),
        ('Ruso'),
        ('Urdu'),
        ('Indonesio'),
        ('Aleman'),
        ('Marati'),
        ('Turco'),
        ('Tamil');

--AUTOR
INSERT INTO autor (nombre)
VALUES  ('Gonzalo Errandonea'),
        ('Gonzalo Romero'),
        ('Alexis Brunetti'),
        ('Gabriel Ramos'),
        ('Tomas Alaluf'),
        ('Mauro Mendoza'),
        ('Pablo Pecsio'),
        ('Esteban Schab'),
        ('Ernesto Ledesma'),
        ('Walter Bel'),
        ('Emiliano Montenegro'),
        ('Marcos Mendoza'),
        ('Juan Mendoza'),
        ('Olga Lopez'),
        ('Vanesa Lopez');

--TEMA
INSERT INTO tema (nombre)
VALUES  ('Drama'),
        ('Terror'),
        ('Accion'),
        ('Comedia'),
        ('Aventura'),
        ('Fantasia'),
        ('Ciencia ficcion'),
        ('Manga'),
        ('Infantil'),
        ('Poesia'),
        ('Teatro'),
        ('Cocina'),
        ('Autoayuda'),
        ('Salud'),
        ('Economia');

--EDITORIAL
INSERT INTO editorial (nombre)
VALUES  ('Acantilado'),
        ('Aguilar'),
        ('Akal'),
        ('Alba'),
        ('Alfaguara'),
        ('Alianza'),
        ('Almadía'),
        ('Anagrama'),
        ('Critica'),
        ('Debolsillo'),
        ('Alpha Decay'),
        ('Ariel'),
        ('Atalanta'),
        ('Gallo Nero'),
        ('Impedimenta');

--CUPON
INSERT INTO cupon (codigo, porc_descuento)
VALUES  ('89ads798as', 50),
        ('G8993786', 20),
        ('9A8SD798SA', 90),
        ('A8DSFG798Sl', 12),
        ('sad789f79d8as', 1),
        ('fasd79w84', 23),
        ('f2134g321', 34),
        ('df87g890fds', 12),
        ('dsa6523678', 36),
        ('cnb8926b97', 57),
        ('df8s79g98fds', 23),
        ('mcvbcvjx890b', 98),
        ('bx34789324', 100),
        ('e25qr24wqer396', 10),
        ('dh387asngf', 7);

--LIBRO
INSERT INTO libro (isbn, url_imagen, titulo, fecha_edicion, 
                    precio, stock, descripcion, id_editorial, id_idioma)
VALUES  ('123-234-513', 'https://http2.mlimages.com/123-234-513', 'Harry Potter y la piedra filosofal', '02/03/1998', 100.00, 10, 'descripcion de Harry Potter y la piedra filosofal', 1, 1),
        ('345-345-432', 'https://http2.mlimages.com/345-345-432', 'Harry Potter y la piedra filosofal', '02/03/1998', 123.00, 10, 'descripcion de Harry Potter y la piedra filosofal',3, 2),
        ('456-546-232', 'https://http2.mlimages.com/456-546-232', 'Las Crónicas de Narnia', '01/01/1998', 634.00, 10, 'descripcion de Las Crónicas de Narnia', 2, 1),
        ('456-546-453', 'https://http2.mlimages.com/456-546-453', 'Don Quijote de La Mancha', '20/08/1999', 10354.00, 10, 'descripcion de Don Quijote de La Mancha', 6, 1),
        ('234-543-251', 'https://http2.mlimages.com/234-543-251', 'Juego De Tronos', '21/09/2000', 10032.00, 10, 'descripcion de Juego De Tronos', 4, 1),
        ('342-543-673', 'https://http2.mlimages.com/342-543-673', 'Choque De Reyes', '12/07/2001', 1233.00, 10, 'descripcion de Choque De Reyes', 7, 1),
        ('880-954-322', 'https://http2.mlimages.com/880-954-322', 'La Razon De Estar Con Tigo', '12/04/1898', 1234.135, 10, 'descripcion de La Razon De Estar Con Tigo', 2, 1),
        ('321-432-134', 'https://http2.mlimages.com/321-432-134', 'Diario Del Fin Del Mundo', '13/06/1498', 1763.00, 10, 'descripcion de Diario Del Fin Del Mundo', 1, 2),
        ('123-213-466', 'https://http2.mlimages.com/123-213-466', 'Luna De Pluton', '15/03/1868', 9500.265, 10, 'descripcion de Luna De Pluton', 1, 1),
        ('564-765-957', 'https://http2.mlimages.com/564-765-957', 'Festibal de la Blasfemia', '22/05/2002', 12310.123, 10, 'descripcion de Festibal de la Blasfemia', 7, 2),
        ('877-345-624', 'https://http2.mlimages.com/877-345-624', 'Valle de La Calma', '10/06/2002', 54654.43, 10, 'descripcion de Valle de La Calma', 15, 1),
        ('573-937-543', 'https://http2.mlimages.com/573-937-543', 'Las Mujeres de Federico', '11/07/2002', 1235.265, 10, 'descripcion de Las Mujeres de Federico', 10, 2),
        ('345-854-383', 'https://http2.mlimages.com/345-854-383', 'La Odisea de Homero', '26/02/2002', 11235.232, 10, 'descripcion de La Odisea de Homero', 14, 1),
        ('456-456-564', 'https://http2.mlimages.com/456-456-564', 'La Macha', '21/03/2000', 45645.222, 10, 'descripcion de La Macha', 13, 3),
        ('456-543-453', 'https://http2.mlimages.com/456-543-453', 'The lliad', '30/04/1998', 123123.25, 10, 'descripcion de The lliad', 9, 5);

--ASIGNAR_TEMA
INSERT INTO asignar_tema (isbn, id_tema)
VALUES  ('345-345-432', 1),
        ('456-546-232', 2),
        ('456-546-453', 3),
        ('234-543-251', 4),
        ('342-543-673', 5),
        ('880-954-322', 6),
        ('321-432-134', 7),
        ('123-213-466', 8),
        ('564-765-957', 9),
        ('877-345-624', 10),
        ('573-937-543', 11),
        ('345-854-383', 12),
        ('456-456-564', 13),
        ('456-543-453', 13),
        ('123-234-513', 1), 
        ('880-954-322', 5),
        ('321-432-134', 6),
        ('123-213-466', 7),
        ('564-765-957', 8),
        ('877-345-624', 9),
        ('573-937-543', 10),
        ('345-854-383', 11),
        ('456-456-564', 15),
        ('456-543-453', 14);

--ESCRITO_POR
INSERT INTO escrito_por (isbn, id_autor)
VALUES  ('456-546-232', 2),
        ('456-546-453', 3),
        ('234-543-251', 4),
        ('342-543-673', 5),
        ('880-954-322', 6),
        ('321-432-134', 7),
        ('123-213-466', 8),
        ('564-765-957', 9),
        ('877-345-624', 10),
        ('573-937-543', 11),
        ('345-854-383', 12),
        ('456-456-564', 13),
        ('456-543-453', 13),
        ('345-345-432', 1),
        ('123-234-513', 1), 
        ('880-954-322', 5),
        ('321-432-134', 6),
        ('123-213-466', 7),
        ('564-765-957', 8),
        ('877-345-624', 9),
        ('573-937-543', 10),
        ('345-854-383', 11),
        ('456-456-564', 15),
        ('456-543-453', 14);

--USUARIO
INSERT INTO usuario (cuil, nombre, correo, contrasenia, telefono, admin)
VALUES (20424644309, 'Gonzalo Errandonea', 'gonzalo.errandonea@gmail.com', 'RACINGcampeon123', '344698231', TRUE),
       (21342284924, 'Jeremias Gonzalez', 'jeremias123@hotmail.com.ar', '123asDDSA2', NULL, FALSE),
       (28428382374, 'Mateo Mendoza', '12mateMendo.23@gmail.com', 'solani321321','344623831', FALSE),
       (20694383722, 'Pablo Brunetti', 'pablo23@yahoo.com.ar.org', '7dd432n8432h', NULL, FALSE),
       (21395373841, 'Juan Romero', 'juanCruz23@hotmail.com', 'sad8732bdy374', NULL, FALSE),
       (21392573047, 'Leonel Messi', 'leoMessi@gmail.com', '234hgsd73g76', NULL, FALSE),
       (20403957391, 'Gabriela Maradona', 'gabriela.gabi@hotmail.com', 'contrasenia213', NULL, FALSE),
       (21424647381, 'Raquel Suarez', 'suRaquel@gmail.com', 'contra23893', NULL, FALSE),
       (27489393025, 'Mauro Moreno', 'MMoreno@gmail.com', '2135n321837', NULL, FALSE),
       (21439302224, 'Rosalia Rossa', 'Rossalia@hotmail.com', '23d74hdj2348', NULL, FALSE),
       (23594932446, 'Analia Clara Suarez', 'anita32@gmail.com', '8437523h437c','344698321', FALSE),
       (21698430941, 'Gonzalo Romero', 'akian231@hotmail.com.ar', '23328c38247', NULL, TRUE),
       (22593394324, 'Mariano Alaluf', 'mariano231@gmail.com', '54938234nf834', NULL, FALSE),
       (21345983824, 'Karen Kloster', 'mariano.32.132@gmail.com', '324hf84h5d8', '3446982312', FALSE),
       (27430328431, 'Carolina Kloster', 'caroklos@hotmail.com', '213bf843h823', NULL, FALSE),
       (21560945341, 'Sofia Fernandez', 'sofisofi@gmail.com', 'h48j32823hd', NULL, FALSE),
       (24490432234, 'Cristina Sanchez', 'crstSuarez@uader.com.ar', 'dfhs8324_-asd98', '344621321', FALSE);

--FAVORITO
INSERT INTO favorito (cuil, isbn)
VALUES (20424644309, '345-345-432'),
        (21342284924,'123-234-513'),
        (20694383722,'456-546-232'),
        (21395373841, '456-546-453'),
        (21392573047, '234-543-251'),
        (20403957391, '342-543-673'),
        (21424647381, '880-954-322'),
        (24490432234, '321-432-134'),
        (20424644309, '123-234-513'),
        (28428382374, '456-546-232'),
        (20694383722,'123-213-466'),
        (21392573047, '456-546-453'),
        (20403957391, '123-213-466'),
        (24490432234, '345-345-432'),
        (20424644309, '456-543-453');

--LINEA_CARRITO
INSERT INTO linea_carrito (cantidad, isbn, id_carrito) 
VALUES (1, '345-345-432', 1),
        (1,'123-234-513', 1),
        (2, '456-546-232', 2),
        (4,'456-546-232', 5),
        (2, '456-546-453', 3),
        (1, '234-543-251', 2),
        (1, '342-543-673', 7),
        (1, '880-954-322', 8),
        (1, '321-432-134', 4),
        (1, '123-234-513', 10),
        (1,'123-234-513', 11),
        (1, '456-546-232', 12),
        (2,'123-213-466', 16),
        (1, '456-546-453', 2),
        (1, '456-546-453', 6),
        (1, '123-213-466', 3),
        (1, '880-954-322', 8),
        (1, '345-345-432', 4);

--DIRECCIÓN
INSERT INTO direccion (calle, numero, piso_departamento, cuil, cp)
VALUES ('Escarguache', 4122, null, 20424644309, 2820),
        ('Juan B Justo', 72, 'AB-1', 20424644309, 3100),
        ('Belgrano', 472, null, 21342284924, 3100),
        ('Ingeniero Henrry', 42, null, 21342284924, 2820),
        ('Scaloneta', 412, 'A2', 20694383722, 3260),
        ('Barrio mar de Maria', 42, null, 20403957391, 2820),
        ('Ursula', 421, null, 21392573047, 2820),
        ('Nogolla', 432, '1S', 21395373841, 3100),
        ('Escarguache', 423, null, 21439302224, 2820),
        ('Concepcion de Tucuman', 242, null, 27489393025, 2820),
        ('Rocamora', 421, 'A3', 21424647381, 3260),
        ('San martin', 4232, null, 22593394324, 2820),
        ('Argentino', 4, null, 23594932446, 2820),
        ('Barrio San Juan de Maria', 32, null, 21345983824, 3260),
        ('San Martin', 4123, null, 27430328431, 2820);

--OPINION
INSERT INTO opinion (cuil, isbn, comentario)
VALUES (20424644309, '345-345-432', 'Buen libro'),
        (21342284924,'345-345-432', 'Romendado'),
        (28428382374, '345-345-432', 'Ok'),
        (20694383722,'456-546-232', 'El final del libro es acpetable, diria que es recomendable para pasar el tiempo'),
        (21395373841, '456-546-453', 'Bueop'),
        (21392573047, '234-543-251', 'Esta bien'),
        (20403957391, '342-543-673', 'Okay'),
        (21424647381, '880-954-322', 'Nice libro'),
        (24490432234, '321-432-134', 'Mi opinion es neutra, no me gusto mucho el inicio del libro'),
        (20424644309, '123-234-513', 'Buen final'),
        (21342284924,'123-234-513', 'Aburrido'),
        (28428382374, '456-546-232', 'No lo recomiendo para nada'),
        (20694383722,'123-213-466', 'Me gusto muchusimo, lo recomiendo'),
        (21392573047, '345-345-432', 'Malisimo'),
        (20403957391, '123-213-466', 'Malo'),
        (24490432234, '345-345-432', 'Me gusto un poco');

--PUNTUACION
INSERT INTO puntuacion (cuil, isbn, puntuacion)
VALUES (20424644309, '345-345-432', 1),
        (21342284924,'345-345-432', 3),
        (28428382374, '345-345-432', 2),
        (20694383722,'456-546-232', 5),
        (21395373841, '456-546-453', 5),
        (21392573047, '234-543-251', 5),
        (20403957391, '342-543-673', 2),
        (21424647381, '880-954-322', 3),
        (24490432234, '321-432-134', 4),
        (20424644309, '123-234-513', 5),
        (21342284924,'123-234-513', 3),
        (28428382374, '456-546-232', 2),
        (20694383722,'123-213-466', 2),
        (21392573047, '345-345-432', 1),
        (20403957391, '123-213-466', 3),
        (24490432234, '345-345-432', 3);