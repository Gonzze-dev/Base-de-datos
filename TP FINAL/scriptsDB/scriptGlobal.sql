CREATE DOMAIN porcentage as int2
constraint pito check (VALUE BETWEEN 0 and 100);

CREATE DOMAIN smallintPos as int
constraint ck_smallintPos check (VALUE BETWEEN 0 and 65535);

CREATE DOMAIN intPos as bigint
constraint ck_intPos check (VALUE BETWEEN 0 and 4294967294);

CREATE DOMAIN bigintPos as bigint
constraint ck_bigintPos check (VALUE BETWEEN 0 and 9223372036854775807);

CREATE DOMAIN Tprice as numeric(9, 2)
constraint ck_Tpunctuation check (VALUE BETWEEN 0.00 and 4294967295.99);

CREATE DOMAIN Tpuntuation as int2
constraint ck_Tpuntuation check (VALUE BETWEEN 0 and 5);

CREATE DOMAIN mail as varchar
constraint ck_mail check (VALUE ~* '([a-zA-Z]|_)[a-zA-Z0-9_.]+@[a-zA-Z]+[.][a-zA-Z]{2,4}([.][a-zA-Z]{2,4})*');


CREATE TABLE IF NOT EXISTS pais
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS provincia
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(60) UNIQUE NOT NULL,
    id_pais intPos NOT NULL,
    
    CONSTRAINT FK_id_pais FOREIGN KEY (id_pais) REFERENCES pais(id)
    
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS ciudad
(
    cp smallintPos PRIMARY KEY NOT NULL,
    nombre VARCHAR(60) unique NOT NULL,
    id_provincia intPos NOT NULL,
    
    CONSTRAINT FK_id_provincia FOREIGN KEY (id_provincia) REFERENCES provincia(id)
    
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS idioma
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS autor
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS tema
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS editorial
(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS libro
(
    isbn VARCHAR PRIMARY KEY NOT NULL,
    url_imagen VARCHAR NOT NULL,
    titulo VARCHAR NOT NULL,
    fecha_edicion DATE NOT NULL,
    precio Tprice NOT NULL,
    stock intPos NOT NULL,
    descripcion VARCHAR NOT NULL,
    fecha_ingreso DATE NOT NULL DEFAULT CURRENT_DATE,
    id_editorial intPos NOT NULL,
    id_idioma intPos NOT NULL,
    
    CONSTRAINT FK_id_editorial FOREIGN KEY (id_editorial) REFERENCES editorial(id),
    CONSTRAINT FK_id_idioma FOREIGN KEY (id_idioma) REFERENCES idioma(id)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS compra_libro
(
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    isbn varchar NOT NULL,
    cantidad intPos NOT NULL,
    
    CONSTRAINT FK_isbn FOREIGN KEY (isbn) REFERENCES libro(isbn)
    
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS asignar_tema
(
    isbn varchar NOT NULL,
    id_tema intPos NOT NULL,
    
    CONSTRAINT PK_asignar_tema PRIMARY KEY (isbn, id_tema),
    CONSTRAINT FK_isbn FOREIGN KEY (isbn) REFERENCES libro(isbn),
    CONSTRAINT FK_id_tema FOREIGN KEY (id_tema) REFERENCES tema(id)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS escrito_por
(
    isbn varchar NOT NULL,
    id_autor intPos NOT NULL,
    
    CONSTRAINT PK_escrito_por PRIMARY KEY (isbn, id_autor),
    CONSTRAINT FK_isbn FOREIGN KEY (isbn) REFERENCES libro(isbn),
    CONSTRAINT FK_id_autor FOREIGN KEY (id_autor) REFERENCES autor(id)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS carrito
(
    id SERIAL PRIMARY KEY,
    fecha DATE DEFAULT(CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS usuario
(
    cuil bigintPos NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo mail UNIQUE NOT NULL,
    contrasenia VARCHAR NOT NULL,
    telefono varchar,
    admin BOOLEAN DEFAULT false,
    id_carrito SERIAL NOT NULL,
    
    CONSTRAINT FK_id_carrito FOREIGN KEY (id_carrito) REFERENCES carrito(id)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS favorito
(
    cuil bigintPos NOT NULL,
    isbn varchar NOT NULL,

    CONSTRAINT PK_favorito PRIMARY KEY (isbn, cuil),
    CONSTRAINT FK_cuil FOREIGN KEY (cuil) REFERENCES usuario(cuil),
    CONSTRAINT FK_isbn FOREIGN KEY (isbn) REFERENCES libro(isbn)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS linea_carrito
(
    nro_linea SERIAL PRIMARY KEY,
    cantidad smallintPos NOT NULL,
    isbn varchar NOT NULL,
    id_carrito intPos NOT NULL,
    
    CONSTRAINT FK_isbn FOREIGN KEY (isbn) REFERENCES libro(isbn),
    CONSTRAINT FK_id_carrito FOREIGN KEY (id_carrito) REFERENCES carrito(id)

    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS direccion
(
    id SERIAL PRIMARY KEY,
    calle varchar NOT NULL,
    numero smallintPos NOT NULL,
    piso_departamento varchar(10),
    cuil bigintPos NOT NULL,
    cp smallintPos NOT NULL,
    
    CONSTRAINT FK_cuil FOREIGN KEY (cuil) REFERENCES usuario(cuil),
    CONSTRAINT FK_cp FOREIGN KEY (cp) REFERENCES ciudad(cp)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS cupon
(
    codigo VARCHAR NOT NULL PRIMARY KEY,
    porc_descuento porcentage NOT NULL,
    usado BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE IF NOT EXISTS orden
(
    id SERIAL PRIMARY KEY,
    fecha DATE NOT NULL DEFAULT CURRENT_DATE,
    total Tprice NOT NULL,
    codigo_cupon VARCHAR DEFAULT NULL,
    cuil bigintPos NOT NULL ,
    id_direccion intPos NOT NULL,
    
    CONSTRAINT FK_cuil FOREIGN KEY (cuil) REFERENCES usuario(cuil),
    CONSTRAINT FK_id_direccion FOREIGN KEY (id_direccion) REFERENCES direccion(id)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS orden_detalle
(
    id SERIAL PRIMARY KEY,
    precio Tprice NOT NULL,
    cantidad smallintPos NOT NULL,
    id_orden intPos DEFAULT(NULL),
    isbn varchar NOT NULL,
    id_carrito intPos NOT NULL,
    
    CONSTRAINT FK_isbn FOREIGN KEY (isbn) REFERENCES libro(isbn),
    CONSTRAINT FK_orden FOREIGN KEY (id_orden) REFERENCES orden(id),
    CONSTRAINT FK_id_carrito FOREIGN KEY (id_carrito) REFERENCES carrito(id)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS opinion
(
    comentario VARCHAR,
    isbn VARCHAR NOT NULL,
    cuil bigintPos NOT NULL,

    CONSTRAINT PK_opinion PRIMARY KEY (isbn, cuil),
    CONSTRAINT FK_isbn FOREIGN KEY (isbn) REFERENCES libro(isbn),
    CONSTRAINT FK_cuil FOREIGN KEY (cuil) REFERENCES usuario(cuil)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS puntuacion
(
    puntuacion Tpuntuation,
    isbn VARCHAR NOT NULL,
    cuil bigintPos NOT NULL,

    CONSTRAINT PK_puntuacion PRIMARY KEY (isbn, cuil),
    CONSTRAINT FK_isbn FOREIGN KEY (isbn) REFERENCES libro(isbn),
    CONSTRAINT FK_cuil FOREIGN KEY (cuil) REFERENCES usuario(cuil)

    ON UPDATE CASCADE
    ON DELETE RESTRICT
);


CREATE OR REPLACE FUNCTION mailExists(correoU mail) RETURNS BOOLEAN 
AS
$existeCorreo$
DECLARE
    correoRegistrado BOOLEAN;
    correoString varchar;
BEGIN
    correoString := upper(correoU::varchar);
    correoRegistrado = EXISTS(SELECT correo FROM usuario WHERE correo = correoString);

 RETURN correoRegistrado;
END;
$existeCorreo$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION cuilExists(cuilU bigintPos) RETURNS BOOLEAN 
AS
$existeCuil$
DECLARE
    cuilRegistrado BOOLEAN;
BEGIN
    cuilRegistrado = EXISTS(SELECT cuil FROM usuario WHERE cuil = cuilU);

 RETURN cuilRegistrado;
END;
$existeCuil$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validPassword(correoU mail, contraseniaU VARCHAR) RETURNS BOOLEAN
AS
$contraseniaValida$
DECLARE
    contraseniaV BOOLEAN;
    correoString varchar;
BEGIN
    correoString := upper(correoU::varchar);
    contraseniaV := EXISTS(SELECT contrasenia FROM usuario WHERE correo = correoString AND contrasenia = contraseniaU);
    
 RETURN contraseniaV;
END;
$contraseniaValida$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION libroExists(isbnLibro varchar) RETURNS BOOLEAN 
AS
$libroExists$
DECLARE
    libroRegistrado BOOLEAN;
BEGIN
    libroRegistrado = EXISTS(SELECT isbn FROM libro WHERE isbn = isbnLibro);

 RETURN libroRegistrado;
END;
$libroExists$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION existeDireccion(idCarrito intPos) RETURNS BOOLEAN 
AS
$existeDireccion$
DECLARE
    existsDireccion BOOLEAN;
BEGIN
    
    existsDireccion := EXISTS(SELECT direccion.id FROM usuario
          JOIN direccion ON direccion.cuil = usuario.cuil
          WHERE usuario.id_carrito = idCarrito);

    
    RETURN existsDireccion;
END;
$existeDireccion$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION quedaStock(cantComprada intPos,
                                       isbnL VARCHAR) RETURNS BOOLEAN 
AS
$quedaStock$
DECLARE
    quedaStock BOOLEAN;
    stockL intPos;
BEGIN
    
    SELECT libro.stock INTO stockL FROM libro WHERE libro.isbn = isbnL;

    quedaStock := (stockL - cantComprada)::int >= 0;
    
    RETURN quedaStock;
END;
$quedaStock$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getUserByMail(correoU mail) 
RETURNS TABLE (cuil bigintPos, 
               nombre VARCHAR(100),
               correo mail,
               contrasenia VARCHAR,
               telefono VARCHAR,
               admin BOOLEAN,
                id_carrito int)
AS
$getUsuerByCorreo$
DECLARE
correoString varchar;
BEGIN
    correoU := upper(correoU);
    RETURN QUERY SELECT usuario.cuil, 
                        usuario.nombre, 
                        usuario.correo,
                        usuario.contrasenia,
                        usuario.telefono,
                        usuario.admin,
                        usuario.id_carrito
                FROM usuario 
                WHERE usuario.correo = correoU::character varying;

END;
$getUsuerByCorreo$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertUser(cuilU bigintPos, 
                                      nombreU VARCHAR(100),
                                      correoU mail,
                                      contraseniaU VARCHAR,
                                      telefonoU VARCHAR) RETURNS VARCHAR
AS
$getUsuario$
DECLARE
    existeCuil BOOLEAN;
    existeCorreo BOOLEAN;

BEGIN
 
    SELECT * INTO existeCuil FROM cuilExists(cuilU);
    SELECT * INTO existeCorreo FROM mailExists(correoU);

    IF existeCuil THEN
        RAISE EXCEPTION 'ERORR AL INGRESAR EL USUARIO CON CUIL %', cuilU USING HINT = ' YA EXISTE';
    END IF;
    
    IF existeCorreo THEN
        RAISE EXCEPTION 'ERORR AL INGRESAR EL USUARIO CON CORREO %', correoU USING HINT = ' YA EXISTE';
    END IF;


    INSERT INTO usuario (cuil, nombre, correo, contrasenia, telefono)
    VALUES (cuilU, nombreU, correoU, contraseniaU, telefonoU);


    RETURN 'USUARIO CON CUIL ' || cuilU || ' Y CORREO ' || correoU || ' AGREGADO CON EXITO!';
END;
$getUsuario$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getCarritoUsuarioByCuil(cuilU bigintPos) 
RETURNS TABLE (cuil bigintPos,
            nombre VARCHAR(100),
            titulo VARCHAR, 
            fecha_edicion date,
            precio Tprice,
            cantidad smallintPos,
            descripcion VARCHAR,
            idioma VARCHAR(20))
AS
$getCarritoUsuario$
DECLARE
    existeCuil BOOLEAN;
    existeCorreo BOOLEAN;

BEGIN
 
    SELECT * INTO existeCuil FROM cuilExists(cuilU);

    IF NOT existeCuil THEN
        RAISE EXCEPTION 'ERORR EL USUARIO CON CUIL %', cuilU USING HINT = ' NO EXISTE';
    END IF;

    RETURN QUERY SELECT cu.cuil, 
                        cu.nombre, 
                        cu.titulo,
                        cu.fecha_edicion, 
                        cu.precio,
                        cu.cantidad,
                        cu.descripcion,
                        cu.idioma FROM view_CarritoUsuario cu
                        WHERE cu.cuil = cuilU;
END;
$getCarritoUsuario$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION agregarLibro(isbnL VARCHAR,
                                        url_imagenL VARCHAR,
                                        tituloL VARCHAR,
                                        fecha_edicionL DATE,
                                        precioL Tprice,
                                        stockL intPos,
                                        descripcionL varchar,
                                        id_editorialL intPos,
                                        id_idiomaL intPos)
RETURNS character varying AS
$agregarLibro$
DECLARE
    qry BOOLEAN;
    existe BOOLEAN;
BEGIN

    SELECT * INTO existe FROM libroExists(isbnL);
    
    IF existe THEN
        RAISE EXCEPTION 'ERORR AL INGRESAR EL LIBRO CON ISBN %', isbnL USING HINT = ' ya existe';
    END IF;
    

    INSERT INTO libro (isbn,
                           url_imagen,
                           titulo,
                           fecha_edicion,
                           precio,
                           stock,
                           descripcion,
                           id_editorial,
                           id_idioma)
        VALUES (isbnL,
                url_imagenL,
                tituloL,
                fecha_edicionL,
                precioL,
                stockL,
                descripcionL,
                id_editorialL,
                id_idiomaL);

    RETURN ('EL LIBRO CON ' || isbnl || ' FUE AGREGADO CON EXITO!');
END;
$agregarLibro$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION agregarLibroComprado(isbnL varchar,
                                                cantidadL intPos)
RETURNS character varying AS
$agregarLibroComprado$
DECLARE
    existe BOOLEAN;
BEGIN

    SELECT * INTO existe FROM libroExists(isbnL);

    IF NOT existe THEN
        RAISE EXCEPTION 'ERORR CON EL LIBRO CON ISBN %', isbnL USING HINT = ' NO EXISTE';
    END IF;

    INSERT INTO compra_libro(isbn, cantidad)
    VALUES (isbnL, 
            cantidadL);

    RETURN ('EL LIBRO CON ' || isbnl || ' FUE AGREGADO Y SE ACTUALIZO SU STOCK CON EXITO!');
END;
$agregarLibroComprado$ 
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION getFavUsuarioByCuil(cuilU bigintPos) 
RETURNS TABLE (cuil bigintPos,
            nombre VARCHAR(100),
            titulo VARCHAR, 
            fecha_edicion date,
            precio Tprice,
            descripcion VARCHAR,
            idioma VARCHAR(20))
AS
$getFavUsuarioByCuil$
DECLARE
    existeCuil BOOLEAN;

BEGIN
 
    SELECT * INTO existeCuil FROM cuilExists(cuilU);
    
    IF NOT existeCuil THEN
        RAISE EXCEPTION 'ERORR EL USUARIO CON CUIL %', cuilU USING HINT = ' NO EXISTE';
    END IF;
    
    RETURN QUERY SELECT vfu.cuil, 
                    vfu.nombre, 
                    vfu.titulo, 
                    vfu.fecha_edicion,
                    vfu.precio,
                    vfu.descripcion, 
                    vfu.idioma FROM view_FavoritosUusario vfu
                WHERE vfu.cuil = cuilU;
END;
$getFavUsuarioByCuil$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getFacturaUsuarioByCuil(cuilU bigintPos) 
RETURNS TABLE (cuil bigintPos,
                nombre VARCHAR(100),
                titulo VARCHAR, 
                idioma VARCHAR(20),
                precio Tprice,
                cantidad smallintPos,
                total Tprice,
                fecha DATE,
                calle VARCHAR,
                numero smallintPos,
                piso_departamento VARCHAR(10),
                cp smallintPos)
AS
$getCarritoUsuario$
DECLARE
    existeCuil BOOLEAN;

BEGIN
 
    SELECT * INTO existeCuil FROM cuilExists(cuilU);
    
    IF NOT existeCuil THEN
        RAISE EXCEPTION 'ERORR EL USUARIO CON CUIL %', cuilU USING HINT = ' NO EXISTE';
    END IF;

    RETURN QUERY SELECT vfu.cuil, 
                    vfu.nombre, 
                    vfu.titulo,
                    vfu.idioma,
                    vfu.precio,
                    vfu.cantidad,
                    vfu.total,
                    vfu.fecha,
                    vfu.calle,
                    vfu.numero,
                    vfu.piso_departamento,
                    vfu.cp FROM view_FacturaUsuario vfu
                WHERE vfu.cuil = cuilU;
END;
$getCarritoUsuario$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getLibroByIsbn(isbnL varchar) 
RETURNS TABLE (isbn varchar,
            titulo VARCHAR(100),
            url_imagen VARCHAR,
            fecha_edicion DATE,
            precio Tprice,
            stock intPos,
            descripcion VARCHAR,
            PuntuacionPromedio decimal(2,2),
            idioma VARCHAR(20),
            editorial VARCHAR,
            tema VARCHAR)
AS
$getLibroByIsbn$
DECLARE
    existe BOOLEAN;
BEGIN

    SELECT * INTO existe FROM libroExists(isbnL);
    
    IF NOT existe THEN
        RAISE EXCEPTION 'ERORR AL INGRESAR EL LIBRO CON ISBN %', isbnL USING HINT = ' NO EXISTE';
    END IF;
    
    RETURN QUERY SELECT DISTINCT
                    vl.isbn,
                    vl.titulo,
                    vl.url_imagen,
                    vl.fecha_edicion,
                    vl.precio,
                    vl.stock,
                    vl.descripcion,
                    vl.PuntuacionPromedio,
                    vl.idioma,
                    vl.editorial,
                    vl.tema FROM view_Libro vl
                WHERE vl.isbn = isbnL;
END;
$getLibroByIsbn$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getLibrosOrdenadosMayorAMenor() 
RETURNS TABLE (isbn varchar,
            titulo VARCHAR(100),
            url_imagen VARCHAR,
            fecha_edicion DATE,
            precio Tprice,
            stock intPos,
            descripcion VARCHAR,
            PuntuacionPromedio decimal(2,2),
            idioma VARCHAR(20),
            editorial VARCHAR,
            tema VARCHAR)
AS
$getLibrosOrdenadosMayorAMenor$
BEGIN

 RETURN QUERY SELECT vl.isbn,
                     vl.titulo,
                     vl.url_imagen,
                     vl.fecha_edicion,
                     vl.precio,
                     vl.stock,
                     vl.descripcion,
                     vl.PuntuacionPromedio,
                     vl.idioma,
                     vl.editorial,
                     vl.tema FROM view_Libro vl
                ORDER BY vl.precio DESC;
END;
$getLibrosOrdenadosMayorAMenor$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getLibrosOrdenadosMenorAMayor() 
RETURNS TABLE (isbn varchar,
            titulo VARCHAR(100),
            url_imagen VARCHAR,
            fecha_edicion DATE,
            precio Tprice,
            stock intPos,
            descripcion VARCHAR,
            PuntuacionPromedio decimal(2,2),
            idioma VARCHAR(20),
            editorial VARCHAR,
            tema VARCHAR)
AS
$getLibrosOrdenadosMenorAMayor$
BEGIN

 RETURN QUERY SELECT vl.isbn,
                     vl.titulo,
                     vl.url_imagen,
                     vl.fecha_edicion,
                     vl.precio,
                     vl.stock,
                     vl.descripcion,
                     vl.PuntuacionPromedio,
                     vl.idioma,
                     vl.editorial,
                     vl.tema FROM view_Libro vl
                ORDER BY vl.precio;
END;
$getLibrosOrdenadosMenorAMayor$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getLibrosEnRangoPrecio(valMin Tprice, valMax Tprice)
RETURNS TABLE (isbn varchar,
            titulo VARCHAR(100),
            url_imagen VARCHAR,
            fecha_edicion DATE,
            precio Tprice,
            stock intPos,
            descripcion VARCHAR,
            PuntuacionPromedio decimal(2,2),
            idioma VARCHAR(20),
            editorial VARCHAR,
            tema VARCHAR)
AS
$getLibrosEnRangoPrecio$
BEGIN
    
    IF NOT valMin <= valMax THEN
        RAISE EXCEPTION 'ERORR, EL VALOR MINIMO %', valMin || ' ES MAYOR QUE EL VALOR MAXIMO ' || valMax isbnL USING HINT = ' NO EXISTE';
    END IF;
    
    RETURN QUERY SELECT vl.isbn,
                        vl.titulo,
                        vl.url_imagen,
                        vl.fecha_edicion,
                        vl.precio,
                        vl.stock,
                        vl.descripcion,
                        vl.PuntuacionPromedio,
                        vl.idioma,
                        vl.editorial,
                        vl.tema FROM view_Libro vl
                    WHERE vl.precio >= valMin AND vl.precio <= valMax;

END;
$getLibrosEnRangoPrecio$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getLibrosByTema(nombreTema VARCHAR)
RETURNS TABLE (isbn varchar,
            titulo VARCHAR(100),
            url_imagen VARCHAR,
            fecha_edicion DATE,
            precio Tprice,
            stock intPos,
            descripcion VARCHAR,
            PuntuacionPromedio decimal(2,2),
            idioma VARCHAR(20),
            editorial VARCHAR,
            tema VARCHAR)
AS
$getLibrosByTema$
DECLARE
    existeTema BOOLEAN;
BEGIN
    nombreTema := upper(nombreTema);
    existeTema:= EXISTS(SELECT nombre FROM tema WHERE nombre = nombreTema);
    
    IF NOT existeTema THEN
        RAISE EXCEPTION 'ERORR, CON EL TEMA %', nombreTema USING HINT = ' NO EXISTE';
    END IF;
    
     RETURN QUERY SELECT DISTINCT vl.isbn,
                         vl.titulo,
                         vl.url_imagen,
                         vl.fecha_edicion,
                         vl.precio,
                         vl.stock,
                         vl.descripcion,
                         vl.PuntuacionPromedio,
                         vl.idioma,
                         vl.editorial,
                         vl.tema FROM view_Libro vl
                    WHERE vl.tema = nombreTema;
END;
$getLibrosByTema$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getLibrosByTitulo(nombreTitulo VARCHAR)
RETURNS TABLE (isbn varchar,
            titulo VARCHAR(100),
            url_imagen VARCHAR,
            fecha_edicion DATE,
            precio Tprice,
            stock intPos,
            descripcion VARCHAR,
            PuntuacionPromedio decimal(2,2),
            idioma VARCHAR(20),
            editorial VARCHAR,
            tema VARCHAR)
AS
$getLibrosByTema$
BEGIN

 RETURN QUERY SELECT DISTINCT vl.isbn,
                     vl.titulo,
                     vl.url_imagen,
                     vl.fecha_edicion,
                     vl.precio,
                     vl.stock,
                     vl.descripcion,
                     vl.PuntuacionPromedio,
                     vl.idioma,
                     vl.editorial,
                     vl.tema FROM view_Libro vl
                WHERE vl.titulo LIKE '%' || nombreTitulo || '%';
END;
$getLibrosByTema$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION compraUsuarioRealizada(idCarrito intPos) RETURNS BOOLEAN 
AS
$libroExists$
DECLARE
    libroRegistrado BOOLEAN;
    precioTotal Tprice;
    totalCantidades intPos;
    maxIdOrden intPos;
    cuilUsuario bigintPos;
    idDireccion intPos;
BEGIN
    
    IF NOT EXISTS(SELECT id FROM carrito WHERE id = idCarrito) THEN
        RAISE EXCEPTION 'El usuario con id_carrito %', idCarrito USING HINT = 'no existe';
    ELSEIF NOT EXISTS(SELECT id_carrito FROM linea_carrito WHERE id_carrito = idCarrito) THEN
        RAISE EXCEPTION 'El usuario con id_carrito %', idCarrito USING HINT = ' no tiene ningun producto a comprar';
    END IF;
    
    DELETE FROM linea_carrito WHERE id_carrito = idCarrito;
    
    SELECT max(id_orden) INTO maxIdOrden FROM orden_detalle;

    SELECT sum(cantidad) INTO totalCantidades FROM orden_detalle
    WHERE id_orden = maxIdOrden;

    SELECT sum(precio) INTO precioTotal FROM orden_detalle
    WHERE id_orden = maxIdOrden;

    SELECT cuil INTO cuilUsuario FROM usuario 
    WHERE id_carrito = idCarrito;

    SELECT direccion.id INTO idDireccion FROM direccion 
    WHERE direccion.cuil = cuilUsuario;
    
    precioTotal = precioTotal * totalCantidades;
    
    INSERT INTO orden (total, cuil, id_direccion)
    VALUES (precioTotal, cuilUsuario, idDireccion);
    
    ALTER TABLE orden_detalle
        ADD CONSTRAINT FK_orden FOREIGN KEY (id_orden) REFERENCES orden(id);
    
    RETURN TRUE;
END;
$libroExists$ 
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION crearCarrito() RETURNS TRIGGER AS
$crearCarritoCuandoSeCreaUsuario$
BEGIN
        INSERT INTO carrito (fecha) VALUES (CURRENT_DATE);
 RETURN NEW;
END;
$crearCarritoCuandoSeCreaUsuario$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_crearCarrito BEFORE INSERT ON usuario
FOR EACH ROW EXECUTE PROCEDURE crearCarrito(); 

CREATE OR REPLACE FUNCTION actualizarStockLibro() RETURNS TRIGGER AS
$actualizarStockLibro$
DECLARE
    stockLibro intPos;
    nuevaCantidad intPos;
BEGIN
    SELECT stock INTO stockLibro FROM libro WHERE isbn = NEW.isbn;
    
    nuevaCantidad := stockLibro + NEW.cantidad;
    
    UPDATE libro
        SET stock = nuevaCantidad
    WHERE isbn = NEW.isbn;
    
    RETURN NEW;
END;
$actualizarStockLibro$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizarStockLibro AFTER INSERT ON compra_libro
FOR EACH ROW EXECUTE PROCEDURE actualizarStockLibro(); 

CREATE OR REPLACE FUNCTION actualizarLibroComprado() RETURNS TRIGGER AS
$actualizarLibroComprado$
DECLARE
    cantidad intPos;
BEGIN
    cantidad := NEW.stock;
    UPDATE libro
        SET stock = 0
    WHERE isbn = NEW.isbn;
    
    INSERT INTO compra_libro(isbn, cantidad)
    VALUES (NEW.isbn, cantidad);
    
    RETURN NEW;
END;
$actualizarLibroComprado$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizarLibroComprado AFTER INSERT ON libro
FOR EACH ROW EXECUTE PROCEDURE actualizarLibroComprado(); 

CREATE OR REPLACE FUNCTION convertirLineaCarritoAOrden_detalle() RETURNS TRIGGER AS
$convertirLineaCarritoAOrden_detalle$
DECLARE
    maxIdOrden intPos;
    precioLibro Tprice;
BEGIN
    
    IF NOT existeDireccion(OLD.id_carrito) THEN
        RAISE EXCEPTION 'NO SE PUDO REALIZAR LA COMPRA DEL LIBRO CON ISBN %', OLD.isbn USING HINT = 'EL USUARIO CON ID CARRITO ' || OLD.id_carrito || ' NO TIENE UNA DIRECCION';
    END IF;

    IF NOT quedaStock(OLD.cantidad, OLD.isbn) THEN
        ROLLBACK;
        RAISE EXCEPTION 'NO SE PUDO REALIZAR LA COMPRA DEL LIBRO CON ISBN %', OLD.isbn USING HINT = 'LA CANTIDAD A COMPRAR ES MAYOR QUE LA DEL LIBRO';
    END IF;
    
    ALTER TABLE orden_detalle
        DROP CONSTRAINT IF EXISTS FK_orden;
    
    SELECT max(orden.id) INTO maxIdOrden FROM orden;
    
    SELECT libro.precio INTO precioLibro FROM libro 
    WHERE libro.isbn = OLD.isbn;
    
    IF maxIdOrden IS NULL THEN
        maxIdOrden := 1;
    ELSE
        maxIdOrden := maxIdOrden + 1;
    END IF;
    
    INSERT INTO orden_detalle (precio, cantidad, id_orden, isbn, id_carrito)
    VALUES (precioLibro,OLD.cantidad, maxIdOrden, OLD.isbn, OLD.id_carrito);
    
    UPDATE libro SET
        stock = stock - OLD.cantidad
    WHERE isbn = OLD.isbn;
    
    RETURN NEW;
END;
$convertirLineaCarritoAOrden_detalle$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_convertirLineaCarritoAOrden_detalle AFTER DELETE ON linea_carrito
FOR EACH ROW EXECUTE PROCEDURE convertirLineaCarritoAOrden_detalle();

CREATE OR REPLACE FUNCTION minAMayus() RETURNS TRIGGER AS
$minAMayus$
BEGIN
    NEW.nombre := upper(NEW.nombre);
    
    RETURN NEW;
END;
$minAMayus$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_minAMayus_Idioma BEFORE INSERT ON idioma
FOR EACH ROW EXECUTE PROCEDURE minAMayus();

CREATE TRIGGER trigger_minAMayus_Autor BEFORE INSERT ON autor
FOR EACH ROW EXECUTE PROCEDURE minAMayus(); 

CREATE TRIGGER trigger_minAMayus_Tema BEFORE INSERT ON tema
FOR EACH ROW EXECUTE PROCEDURE minAMayus(); 

CREATE TRIGGER trigger_minAMayus_Editorial BEFORE INSERT ON editorial
FOR EACH ROW EXECUTE PROCEDURE minAMayus();

CREATE TRIGGER trigger_minAMayus_Pais BEFORE INSERT ON pais
FOR EACH ROW EXECUTE PROCEDURE minAMayus();

CREATE TRIGGER trigger_minAMayus_Provincia BEFORE INSERT ON provincia
FOR EACH ROW EXECUTE PROCEDURE minAMayus();

CREATE TRIGGER trigger_minAMayus_Ciudad BEFORE INSERT ON ciudad
FOR EACH ROW EXECUTE PROCEDURE minAMayus();

CREATE OR REPLACE FUNCTION minAMayusCorreo() RETURNS TRIGGER AS
$minAMayus$
BEGIN
    NEW.correo := upper(NEW.correo);
    
    RETURN NEW;
END;
$minAMayus$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_minAMayusCorreo BEFORE INSERT ON usuario
FOR EACH ROW EXECUTE PROCEDURE minAMayusCorreo();

CREATE OR REPLACE VIEW view_FavoritosUusario
as SELECT u.cuil, 
    u.nombre, 
    l.titulo, 
    l.fecha_edicion, 
    l.precio, 
    l.descripcion,
    i.nombre AS idioma FROM usuario u
JOIN favorito f ON f.cuil = u.cuil
JOIN libro l ON l.isbn = f.isbn
JOIN idioma i ON i.id = l.id_idioma;

CREATE OR REPLACE VIEW view_CarritoUsuario
as SELECT u.cuil, 
        u.nombre, 
        l.titulo,
        l.fecha_edicion, 
        l.precio,
        lc.cantidad,
        l.descripcion,
        i.nombre as idioma FROM usuario u
JOIN linea_carrito lc ON lc.id_carrito = u.id_carrito
JOIN libro l ON l.isbn = lc.isbn
JOIN idioma i ON i.id = l.id_idioma;

CREATE OR REPLACE VIEW view_FacturaUsuario
as SELECT u.cuil, 
        u.nombre, 
        l.titulo,
        i.nombre as idioma,
        od.precio,
        od.cantidad,
        o.total,
        o.fecha,
        d.calle,
        d.numero,
        d.piso_departamento,
        d.cp FROM usuario u
JOIN orden_detalle od ON od.id_carrito = u.id_carrito
JOIN libro l ON l.isbn = od.isbn
JOIN idioma i ON i.id = l.id_idioma
JOIN orden o ON o.id = od.id_orden
JOIN direccion d ON d.cuil = u.cuil;

CREATE OR REPLACE VIEW view_PuntuacionPromedioLibro
as  SELECT 
        l.isbn AS isbn,
        AVG(p.puntuacion) AS promedio
    FROM libro l
    JOIN puntuacion p ON p.isbn = l.isbn
    WHERE p.puntuacion >= 1
    GROUP BY l.isbn;

CREATE OR REPLACE VIEW view_Libro
as  SELECT 
        l.isbn,
        l.titulo,
        l.url_imagen,
        l.fecha_edicion,
        l.precio,
        l.stock,
        l.descripcion,
        vppl.promedio AS PuntuacionPromedio,
        i.nombre AS idioma,
        e.nombre AS editorial,
        t.nombre AS tema
    FROM libro l
    JOIN editorial e ON e.id = l.id_editorial
    JOIN idioma i ON i.id = l.id_idioma
    JOIN escrito_por ep ON ep.isbn = l.isbn
    JOIN autor a ON a.id = ep.id_autor
    JOIN asignar_tema atema ON atema.isbn = l.isbn
    JOIN tema t ON t.id = atema.id_tema
    JOIN view_PuntuacionPromedioLibro vppl ON vppl.isbn = l.isbn;

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


--CREAR USUARIOS
CREATE USER normalUser WITH PASSWORD '111';
CREATE USER adminUser WITH PASSWORD '222';
CREATE USER superAdminUser WITH PASSWORD '333';

--PERMISOS USUARIO
GRANT INSERT, UPDATE ON usuario, 
                        linea_carrito, 
                        direccion,
                        opinion,
                        puntuacion,
                        favorito,
                        carrito
                        TO normalUser;

GRANT SELECT ON ALL TABLES IN SCHEMA PUBLIC TO normalUser;

GRANT DELETE ON favorito,
                linea_carrito
                TO normalUser;

                
--PERMISOS ADMIN
GRANT INSERT, UPDATE, SELECT ON ALL TABLES IN SCHEMA PUBLIC TO adminUser;


GRANT DELETE ON asignar_tema, 
                escrito_por
                TO adminUser;

--PERMISOS SUPER ADMIN
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PUBLIC TO superAdminUser;