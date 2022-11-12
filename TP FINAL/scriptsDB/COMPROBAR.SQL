CREATE OR REPLACE FUNCTION convertirLineaCarritoAOrden_detalle() RETURNS TRIGGER AS
$convertirLineaCarritoAOrden_detalle$
DECLARE
    
    maxIdOrden intPos;
    nuevaCantidad intPos;
    precioLibro Tprice;
    cantLibrosEnLineaCarrito intPos;
    precioTotal Tprice;
    cuilUsuario bigintPos;
    idDireccion intPos;
    totalCantidades bigintPos;
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

v1

CREATE OR REPLACE FUNCTION convertirLineaCarritoAOrden() RETURNS TRIGGER AS
$convertirLineaCarritoAOrden$
DECLARE
    
    maxIdOrden intPos;
    precioTotal Tprice;
    cuilUsuario bigintPos;
    idDireccion intPos;
    totalCantidades bigintPos;
    cantLibrosEnLineaCarrito intPos;
BEGIN
    
    SELECT max(orden.id) INTO maxIdOrden FROM orden;
    
    SELECT count(linea_carrito.nro_linea) INTO cantLibrosEnLineaCarrito FROM linea_carrito 
    WHERE linea_carrito.id_carrito = OLD.id_carrito;
    
    maxIdOrden := maxIdOrden + 1;

    IF cantLibrosEnLineaCarrito = 1 THEN
        SELECT sum(orden_detalle.precio) INTO precioTotal FROM orden_detalle
        WHERE orden_detalle.id_orden = maxIdOrden;
        
        SELECT sum(orden_detalle.cantidad) INTO precioTotal FROM orden_detalle
        WHERE orden_detalle.id_orden = maxIdOrden;
        
        SELECT usuario.cuil INTO cuilUsuario FROM usuario 
        WHERE usuario.id_carrito = OLD.id_carrito;
        
        SELECT direccion.id INTO idDireccion FROM direccion 
        WHERE direccion.cuil = cuilUsuario;
        
        precioTotal := precioTotal * totalCantidades;
        
        INSERT INTO orden (total, cuil, id_direccion)
        VALUES (precioTotal, cuilUsuario, idDireccion);
        
        ALTER TABLE orden_detalle
            ADD CONSTRAINT FK_orden FOREIGN KEY (id_orden) REFERENCES orden(id);
    END IF;
    RETURN NEW;
END;
$convertirLineaCarritoAOrden$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_convertirLineaCarritoAOrden AFTER DELETE ON linea_carrito
FOR EACH ROW EXECUTE PROCEDURE convertirLineaCarritoAOrden();

v2

CREATE OR REPLACE FUNCTION convertirLineaCarritoAOrden() RETURNS TRIGGER AS
$convertirLineaCarritoAOrden$
DECLARE
    
    maxIdOrden intPos;
    precioTotal Tprice;
    cuilUsuario bigintPos;
    idCarrito bigintPos;
    idDireccion intPos;
    totalCantidades bigintPos;

BEGIN
    
    SELECT max(orden_detalle.id_orden) INTO maxIdOrden FROM orden_detalle
    LIMIT 1;
    
    SELECT orden_detalle.id_carrito INTO idCarrito FROM orden_detalle 
    WHERE orden_detalle.id_orden = maxIdOrden
    LIMIT 1;
    
    SELECT sum(orden_detalle.cantidad) INTO precioTotal FROM orden_detalle
    WHERE orden_detalle.id_orden = maxIdOrden;
    
    SELECT sum(orden_detalle.precio) INTO precioTotal FROM orden_detalle
    WHERE orden_detalle.id_orden = maxIdOrden;

    SELECT usuario.cuil INTO cuilUsuario FROM usuario 
    WHERE usuario.id_carrito = id_carrito;

    SELECT direccion.id INTO idDireccion FROM direccion 
    WHERE direccion.cuil = cuilUsuario;

    precioTotal := precioTotal * totalCantidades;
    
    IF NOT EXISTS(SELECT id FROM orden WHERE orden.id = maxIdOrden) THEN
        raise notice 'Value: %', maxIdOrden;
        raise notice 'Value: %', idCarrito;
        raise notice 'Value: %', precioTotal;
        
        raise notice 'Value: %', cuilUsuario;
        raise notice 'Value: %', idDireccion;
        
        ALTER TABLE orden_detalle
            ADD CONSTRAINT FK_orden FOREIGN KEY (id_orden) REFERENCES orden(id);
    ELSE
        UPDATE orden
            SET total = total + precioTotal
            WHERE orden.id = maxIdOrden;
    END IF;

    RETURN NEW;
END;
$convertirLineaCarritoAOrden$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_convertirLineaCarritoAOrden BEFORE INSERT ON orden_detalle
FOR EACH ROW EXECUTE PROCEDURE convertirLineaCarritoAOrden();