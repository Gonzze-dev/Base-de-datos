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

CREATE OR REPLACE FUNCTION quedaStock(cantComprada intPos,
                                       isbnL VARCHAR) RETURNS BOOLEAN 
AS
$quedaStock$
DECLARE
    quedaStock BOOLEAN;
    stockL intPos;
BEGIN
    
    SELECT stock INTO stockL FROM libro WHERE isbn = isbnL;

    quedaStock := (stockL - cantComprada)::int >= 0;
    
    RETURN quedaStock;
END;
$quedaStock$ 
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