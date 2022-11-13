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
BEGIN

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
                                      telefonoU VARCHAR) RETURNS BOOLEAN
AS
$getUsuario$
DECLARE
    existeCuil BOOLEAN;
    existeCorreo BOOLEAN;
    noExisteUsuario BOOLEAN;
    
BEGIN
 
 SELECT * INTO existeCuil FROM cuilExists(cuilU);
 SELECT * INTO existeCorreo FROM mailExists(correoU);
 noExisteUsuario = NOT (existeCuil OR existeCorreo);
 
 IF noExisteUsuario THEN
     INSERT INTO usuario (cuil, nombre, correo, contrasenia, telefono)
     VALUES (cuilU, nombreU, correoU, contraseniaU, telefonoU);
 END IF;
 
 RETURN noExisteUsuario;
END;
$getUsuario$
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
BEGIN

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

CREATE OR REPLACE FUNCTION getCarritoUsuarioByCuil(cuilU bigintPos) 
RETURNS TABLE (cuil bigintPos,
            nombre VARCHAR(100),
            titulo VARCHAR, 
            fecha_edicion date,
            precio Tprice,
            descripcion VARCHAR,
            idioma VARCHAR(20))
AS
$getCarritoUsuario$
BEGIN

 RETURN QUERY SELECT cu.cuil, 
            cu.nombre, 
            cu.titulo,
            cu.fecha_edicion, 
            cu.precio, 
            cu.descripcion,
            cu.idioma FROM view_CarritoUsuario cu
            WHERE cu.cuil = cuilU;
END;
$getCarritoUsuario$
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
BEGIN

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
BEGIN

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
        RAISE EXCEPTION 'El con id %', idCarrito USING HINT = 'no existe';
    ELSEIF NOT EXISTS(SELECT id_carrito FROM linea_carrito WHERE id_carrito = idCarrito) THEN
        RAISE EXCEPTION 'El con id %', idCarrito USING HINT = ' no tiene ningun producto a comprar';
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
