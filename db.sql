-- Crear la base de datos
CREATE DATABASE vtaszfs;
USE vtaszfs;

CREATE TABLE Clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Proveedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100)
);

CREATE TABLE Ubicaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entidad_tipo ENUM('Cliente', 'Proveedor', 'Empleado') NOT NULL,
    entidad_id INT NOT NULL,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    estado VARCHAR(50),
    codigo_postal VARCHAR(10),
    pais VARCHAR(50),
    UNIQUE KEY uk_entidad (entidad_tipo, entidad_id)
);

CREATE TABLE Puestos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    puesto VARCHAR(50),
    salario DECIMAL(10,2)
);

CREATE TABLE Empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    puesto_id INT,
    fecha_contratacion DATE,
    FOREIGN KEY (puesto_id) REFERENCES Puestos(id)
);

CREATE TABLE ContactoProveedores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    proveedor_id INT,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id)
);

CREATE TABLE Telefonos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    telefono VARCHAR(20),
    tipo VARCHAR(20),  -- Ejemplo: 'fijo', 'móvil'
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);

CREATE TABLE CategoriasProductos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    descripcion TEXT,
    categoria_padre INT DEFAULT NULL,
    FOREIGN KEY (categoria_padre) REFERENCES CategoriasProductos(id)
);

CREATE TABLE Productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    precio DECIMAL(10,2),
    proveedor_id INT,
    categoria_id INT,
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id),
    FOREIGN KEY (categoria_id) REFERENCES CategoriasProductos(id)
);

CREATE TABLE Pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    fecha DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);

CREATE TABLE DetallesPedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    producto_id INT,
    cantidad INT,
    precio DECIMAL(10,2),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES Productos(id)
);

CREATE TABLE HistorialPedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    cambio TEXT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id)
);

CREATE TABLE Empleados_Proveedores (
    empleado_id INT,
    proveedor_id INT,
    PRIMARY KEY (empleado_id, proveedor_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleados(id),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id)
);
