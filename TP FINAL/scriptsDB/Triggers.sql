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
    
    RETURN NEW;
END;
$convertirLineaCarritoAOrden_detalle$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_convertirLineaCarritoAOrden_detalle AFTER DELETE ON linea_carrito
FOR EACH ROW EXECUTE PROCEDURE convertirLineaCarritoAOrden_detalle();