-- Creación de la base de datos
CREATE DATABASE tallersqljuan;
USE vtaszfs;

CREATE TABLE Puestos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    descripcion NVARCHAR(MAX),
    salario_base DECIMAL(10, 2)
);

CREATE TABLE Clientes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    email NVARCHAR(100) UNIQUE,
    fecha_registro DATE DEFAULT GETDATE()
);

CREATE TABLE Ubicaciones (
    id INT IDENTITY(1,1) PRIMARY KEY,
    entidad_tipo NVARCHAR(20) CHECK (entidad_tipo IN ('cliente', 'proveedor', 'empleado')),
    entidad_id INT,
    direccion NVARCHAR(255),
    ciudad NVARCHAR(100),
    estado NVARCHAR(50),
    codigo_postal NVARCHAR(10),
    pais NVARCHAR(50)
);

CREATE TABLE Empleados (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    puesto_id INT,
    fecha_contratacion DATE,
    FOREIGN KEY (puesto_id) REFERENCES Puestos(id)
);

CREATE TABLE DatosEmpleados (
    empleado_id INT PRIMARY KEY,
    fecha_nacimiento DATE,
    genero CHAR(1),
    email NVARCHAR(100) UNIQUE,
    FOREIGN KEY (empleado_id) REFERENCES Empleados(id)
);

CREATE TABLE Telefonos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT,
    numero NVARCHAR(20),
    tipo NVARCHAR(20),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);

CREATE TABLE Proveedores (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    direccion_id INT,
    FOREIGN KEY (direccion_id) REFERENCES Ubicaciones(id)
);

CREATE TABLE ContactoProveedores (
    id INT IDENTITY(1,1) PRIMARY KEY,
    proveedor_id INT,
    nombre NVARCHAR(100),
    email NVARCHAR(100),
    telefono NVARCHAR(20),
    cargo NVARCHAR(50),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id)
);

CREATE TABLE EmpleadosProveedores (
    empleado_id INT,
    proveedor_id INT,
    fecha_asignacion DATE,
    PRIMARY KEY (empleado_id, proveedor_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleados(id),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id)
);

CREATE TABLE CategoriasProductos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    descripcion NVARCHAR(MAX),
    categoria_padre_id INT,
    FOREIGN KEY (categoria_padre_id) REFERENCES CategoriasProductos(id)
);

CREATE TABLE Productos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100),
    precio_base DECIMAL(10, 2),
    proveedor_id INT,
    categoria_id INT,
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores(id),
    FOREIGN KEY (categoria_id) REFERENCES CategoriasProductos(id)
);

CREATE TABLE Pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT,
    fecha DATE,
    estado NVARCHAR(20) CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);

CREATE TABLE DetallesPedido (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT,
    producto_id INT,
    cantidad INT,
    precio_unitario DECIMAL(10, 2),
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES Productos(id)
);

CREATE TABLE HistorialPedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT,
    fecha_cambio DATETIME,
    estado_anterior NVARCHAR(20) CHECK (estado_anterior IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    estado_nuevo NVARCHAR(20) CHECK (estado_nuevo IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    usuario VARCHAR(80),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id)
);


