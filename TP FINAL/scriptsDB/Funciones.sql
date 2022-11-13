CREATE OR REPLACE FUNCTION mailExists(correoU mail) RETURNS BOOLEAN 
AS
$existeCorreo$
DECLARE
    correoRegistrado BOOLEAN;
BEGIN
    correoRegistrado = EXISTS(SELECT correo FROM usuario WHERE correo = correoU);

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
BEGIN
    contraseniaV = EXISTS(SELECT contrasenia FROM usuario WHERE correo = correoU AND contrasenia = contraseniaU);

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