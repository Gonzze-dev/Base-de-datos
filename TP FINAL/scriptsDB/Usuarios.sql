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