-- 1. Actualizar precio de productos por proveedor
CREATE PROCEDURE ActualizarPreciosProveedor
    @proveedor_id INT,
    @porcentaje_aumento DECIMAL(5,2)
AS
BEGIN
    UPDATE Productos
    SET precio_base = precio_base * (1 + @porcentaje_aumento/100)
    WHERE proveedor_id = @proveedor_id;
END;
GO

-- 2. Obtener dirección de cliente
CREATE PROCEDURE ObtenerDireccionCliente
    @cliente_id INT
AS
BEGIN
    SELECT 
        c.nombre AS cliente,
        u.direccion,
        u.ciudad,
        u.estado,
        u.codigo_postal,
        u.pais
    FROM Clientes c
    INNER JOIN Ubicaciones u ON u.entidad_id = c.id AND u.entidad_tipo = 'cliente'
    WHERE c.id = @cliente_id;
END;
GO

-- 3. Registrar nuevo pedido y detalles
CREATE PROCEDURE RegistrarPedido
    @cliente_id INT,
    @fecha DATE,
    @estado VARCHAR(20),
    @detalles XML
AS
BEGIN
    DECLARE @pedido_id INT;
    
    -- Insertar pedido
    INSERT INTO Pedidos (cliente_id, fecha, estado)
    VALUES (@cliente_id, @fecha, @estado);
    
    SET @pedido_id = SCOPE_IDENTITY();
    
    -- Insertar detalles del pedido
    INSERT INTO DetallesPedido (pedido_id, producto_id, cantidad, precio_unitario, subtotal)
    SELECT 
        @pedido_id,
        T.c.value('producto_id[1]', 'INT'),
        T.c.value('cantidad[1]', 'INT'),
        T.c.value('precio_unitario[1]', 'DECIMAL(10,2)'),
        T.c.value('cantidad[1]', 'INT') * T.c.value('precio_unitario[1]', 'DECIMAL(10,2)')
    FROM @detalles.nodes('/detalles/detalle') T(c);
END;
GO

-- 4. Calcular total de ventas por cliente
CREATE PROCEDURE CalcularTotalVentasCliente
    @cliente_id INT
AS
BEGIN
    SELECT 
        c.nombre AS cliente,
        COUNT(p.id) AS total_pedidos,
        SUM(dp.subtotal) AS total_ventas,
        AVG(dp.subtotal) AS promedio_por_pedido
    FROM Clientes c
    INNER JOIN Pedidos p ON c.id = p.cliente_id
    INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
    WHERE c.id = @cliente_id
    GROUP BY c.id, c.nombre;
END;
GO

-- 5. Obtener empleados por puesto
CREATE PROCEDURE ObtenerEmpleadosPorPuesto
    @puesto_id INT
AS
BEGIN
    SELECT 
        e.nombre AS empleado,
        p.nombre AS puesto,
        e.fecha_contratacion,
        de.email
    FROM Empleados e
    INNER JOIN Puestos p ON e.puesto_id = p.id
    LEFT JOIN DatosEmpleados de ON e.id = de.empleado_id
    WHERE e.puesto_id = @puesto_id
    ORDER BY e.nombre;
END;
GO

-- 6. Actualizar salario por puesto
CREATE PROCEDURE ActualizarSalarioPuesto
    @puesto_id INT,
    @porcentaje_aumento DECIMAL(5,2)
AS
BEGIN
    UPDATE Puestos
    SET salario_base = salario_base * (1 + @porcentaje_aumento/100)
    WHERE id = @puesto_id;
END;
GO

-- 7. Listar pedidos entre fechas
CREATE PROCEDURE ListarPedidosPorFecha
    @fecha_inicio DATE,
    @fecha_fin DATE
AS
BEGIN
    SELECT 
        p.id AS pedido_id,
        p.fecha,
        p.estado,
        c.nombre AS cliente,
        SUM(dp.subtotal) AS total
    FROM Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.id
    INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
    WHERE p.fecha BETWEEN @fecha_inicio AND @fecha_fin
    GROUP BY p.id, p.fecha, p.estado, c.nombre
    ORDER BY p.fecha DESC;
END;
GO

-- 8. Aplicar descuento a categoría
CREATE PROCEDURE AplicarDescuentoCategoria
    @categoria_id INT,
    @porcentaje_descuento DECIMAL(5,2)
AS
BEGIN
    UPDATE Productos
    SET precio_base = precio_base * (1 - @porcentaje_descuento/100)
    WHERE categoria_id = @categoria_id;
END;
GO

-- 9. Listar proveedores por tipo de producto
CREATE PROCEDURE ListarProveedoresPorCategoria
    @categoria_id INT
AS
BEGIN
    SELECT DISTINCT
        p.nombre AS proveedor,
        cp.nombre AS categoria,
        COUNT(pr.id) AS total_productos
    FROM Proveedores p
    INNER JOIN Productos pr ON p.id = pr.proveedor_id
    INNER JOIN CategoriasProductos cp ON pr.categoria_id = cp.id
    WHERE pr.categoria_id = @categoria_id
    GROUP BY p.id, p.nombre, cp.nombre
    ORDER BY p.nombre;
END;
GO

-- 10. Obtener pedido de mayor valor
CREATE PROCEDURE ObtenerPedidoMayorValor
AS
BEGIN
    SELECT TOP 1
        p.id AS pedido_id,
        p.fecha,
        p.estado,
        c.nombre AS cliente,
        SUM(dp.subtotal) AS total,
        COUNT(dp.id) AS total_productos
    FROM Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.id
    INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
    GROUP BY p.id, p.fecha, p.estado, c.nombre
    ORDER BY SUM(dp.subtotal) DESC;
END;
GO 