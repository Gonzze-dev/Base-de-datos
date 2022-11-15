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