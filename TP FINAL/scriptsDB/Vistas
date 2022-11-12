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






