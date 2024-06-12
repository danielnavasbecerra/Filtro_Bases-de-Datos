

-- ###########################################################
-- ###### COMANDOS DDL (DB TiendaOnline) - Daniel Navas ######
-- ###########################################################

-- Creación y Selección de la base de datos
CREATE DATABASE tienda_online;
USE tienda_online;


-- Creación de las tablas (4-Total)

CREATE TABLE productos (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    precio DECIMAL(10, 2),
    descripcion TEXT,
    CONSTRAINT PK_Productos_Id PRIMARY KEY(id)
);

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    correo_electronico VARCHAR(100),
    fecha_registro DATE,
    CONSTRAINT PK_Usuarios_Id PRIMARY KEY(id)
);

CREATE TABLE pedidos (
    id INT AUTO_INCREMENT,
    id_usuario INT,
    fecha DATE,
    total DECIMAL(10, 2),
    CONSTRAINT PK_Pedidos_Id PRIMARY KEY(id),
    CONSTRAINT FK_Usuarios_Pedidos_Id FOREIGN KEY(id_usuario) REFERENCES usuarios(id)
);

CREATE TABLE detalles_pedidos (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10, 2),
    CONSTRAINT PK_DetallesPedidos_Id PRIMARY KEY(id_pedido, id_producto),
    CONSTRAINT FK_Pedidos_DetallesPedidos_Id FOREIGN KEY(id_pedido) REFERENCES pedidos(id),
    CONSTRAINT FK_Productos_DetallesPedidos_Id FOREIGN KEY(id_producto) REFERENCES productos(id)
);




-- Daniel Navas - C.C: 1.***.***.797