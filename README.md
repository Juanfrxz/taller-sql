# Sistema de Gestión de Ventas y Pedidos

Este proyecto implementa un sistema de gestión de ventas y pedidos utilizando SQL Server. El sistema incluye la creación de tablas, procedimientos almacenados, funciones, triggers y consultas complejas.

## Estructura del Proyecto

El proyecto está organizado en los siguientes archivos:

1. `db.sql` - Scripts DDL para la creación de la base de datos y tablas
2. `consultas_simples.sql` - Consultas básicas de selección y filtrado
3. `consultas_multitabla.sql` - Consultas con JOINs y operaciones entre tablas
4. `subconsultas.sql` - Consultas utilizando subconsultas
5. `procedimientos_almacenados.sql` - Procedimientos almacenados
6. `funciones.sql` - Funciones definidas por el usuario
7. `triggers.sql` - Triggers para automatización y validación

## Estructura de la Base de Datos

### Tablas Principales

- **Puestos**: Almacena información sobre los puestos de trabajo
- **Empleados**: Registra información de los empleados
- **Clientes**: Gestiona la información de los clientes
- **Productos**: Catálogo de productos disponibles
- **Pedidos**: Registra las órdenes de compra
- **DetallesPedido**: Detalles de los productos en cada pedido

### Tablas de Soporte

- **DatosEmpleados**: Información adicional de empleados
- **Telefonos**: Gestión de números telefónicos
- **Ubicaciones**: Direcciones de clientes, proveedores y empleados
- **Proveedores**: Información de proveedores
- **CategoriasProductos**: Categorización de productos
- **HistorialPedidos**: Seguimiento de cambios en pedidos

## Consultas y Soluciones

### 1. Consultas Simples

```sql
-- Ejemplo: Listar todos los clientes
SELECT nombre, email 
FROM Clientes 
ORDER BY nombre;
```

### 2. Consultas Multitabla

```sql
-- Ejemplo: Obtener pedidos con información del cliente
SELECT 
    p.id AS pedido_id,
    p.fecha,
    c.nombre AS cliente
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id;
```

### 3. Subconsultas

```sql
-- Ejemplo: Encontrar productos más caros que el promedio
SELECT nombre, precio_base
FROM Productos
WHERE precio_base > (SELECT AVG(precio_base) FROM Productos);
```

### 4. Procedimientos Almacenados

```sql
-- Ejemplo: Actualizar precios de productos
EXEC ActualizarPreciosProveedor @proveedor_id = 1, @porcentaje_aumento = 10;
```

### 5. Funciones

```sql
-- Ejemplo: Calcular días transcurridos
SELECT dbo.CalcularDiasTranscurridos('2024-01-01');
```

### 6. Triggers

Los triggers implementados incluyen:
- Registro de cambios de salario
- Validación de eliminación de productos
- Seguimiento de cambios en pedidos
- Actualización automática de inventario
- Validación de precios mínimos

## Pruebas y Ejemplos

### Inserción de Datos de Prueba

```sql
-- Insertar un nuevo puesto
INSERT INTO Puestos (nombre, descripcion, salario_base)
VALUES ('Vendedor', 'Vendedor de tienda', 25000);

-- Insertar un nuevo empleado
INSERT INTO Empleados (nombre, puesto_id, fecha_contratacion)
VALUES ('Juan Pérez', 1, GETDATE());

-- Insertar un nuevo cliente
INSERT INTO Clientes (nombre, email)
VALUES ('María García', 'maria@email.com');

-- Insertar un nuevo producto
INSERT INTO Productos (nombre, precio_base, proveedor_id, categoria_id)
VALUES ('Laptop HP', 1200.00, 1, 1);
```

### Pruebas de Consultas

```sql
-- Prueba de consulta multitabla
SELECT 
    p.nombre AS producto,
    c.nombre AS categoria,
    pr.nombre AS proveedor
FROM Productos p
INNER JOIN CategoriasProductos c ON p.categoria_id = c.id
INNER JOIN Proveedores pr ON p.proveedor_id = pr.id;

-- Prueba de procedimiento almacenado
EXEC ObtenerDireccionCliente @cliente_id = 1;

-- Prueba de función
SELECT dbo.CalcularTotalConImpuesto(100.00, 19.00);
```

## Requisitos del Sistema

- SQL Server 2019 o superior
- Permisos suficientes para crear bases de datos y objetos
- Espacio en disco para almacenar la base de datos

## Instalación

1. Ejecutar el script `db.sql` para crear la base de datos y las tablas
2. Ejecutar los scripts de procedimientos almacenados, funciones y triggers
3. Insertar datos de prueba según sea necesario


