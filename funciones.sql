-- 1. Función para calcular días transcurridos
CREATE FUNCTION CalcularDiasTranscurridos
(
    @fecha DATE
)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @fecha, GETDATE());
END;
GO

-- 2. Función para calcular total con impuesto
CREATE FUNCTION CalcularTotalConImpuesto
(
    @monto DECIMAL(10,2),
    @impuesto DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @monto * (1 + @impuesto/100);
END;
GO

-- 3. Función para contar pedidos de un cliente
CREATE FUNCTION ContarPedidosCliente
(
    @cliente_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @total INT;
    SELECT @total = COUNT(*)
    FROM Pedidos
    WHERE cliente_id = @cliente_id;
    RETURN @total;
END;
GO

-- 4. Función para aplicar descuento a producto
CREATE FUNCTION AplicarDescuentoProducto
(
    @producto_id INT,
    @descuento DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @precio_final DECIMAL(10,2);
    SELECT @precio_final = precio_base * (1 - @descuento/100)
    FROM Productos
    WHERE id = @producto_id;
    RETURN @precio_final;
END;
GO

-- 5. Función para verificar dirección de cliente
CREATE FUNCTION TieneDireccionRegistrada
(
    @cliente_id INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @tiene_direccion BIT;
    SELECT @tiene_direccion = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM Ubicaciones
    WHERE entidad_id = @cliente_id AND entidad_tipo = 'cliente';
    RETURN @tiene_direccion;
END;
GO

-- 6. Función para calcular salario anual
CREATE FUNCTION CalcularSalarioAnual
(
    @empleado_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @salario_anual DECIMAL(10,2);
    SELECT @salario_anual = p.salario_base * 12
    FROM Empleados e
    INNER JOIN Puestos p ON e.puesto_id = p.id
    WHERE e.id = @empleado_id;
    RETURN @salario_anual;
END;
GO

-- 7. Función para calcular ventas por tipo de producto
CREATE FUNCTION CalcularVentasPorCategoria
(
    @categoria_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total_ventas DECIMAL(10,2);
    SELECT @total_ventas = ISNULL(SUM(dp.subtotal), 0)
    FROM Productos p
    INNER JOIN DetallesPedido dp ON p.id = dp.producto_id
    WHERE p.categoria_id = @categoria_id;
    RETURN @total_ventas;
END;
GO

-- 8. Función para obtener nombre de cliente
CREATE FUNCTION ObtenerNombreCliente
(
    @cliente_id INT
)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @nombre NVARCHAR(100);
    SELECT @nombre = nombre
    FROM Clientes
    WHERE id = @cliente_id;
    RETURN @nombre;
END;
GO

-- 9. Función para calcular total de pedido
CREATE FUNCTION CalcularTotalPedido
(
    @pedido_id INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);
    SELECT @total = ISNULL(SUM(subtotal), 0)
    FROM DetallesPedido
    WHERE pedido_id = @pedido_id;
    RETURN @total;
END;
GO

-- 10. Función para verificar inventario de producto
CREATE FUNCTION ProductoEnInventario
(
    @producto_id INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @en_inventario BIT;
    SELECT @en_inventario = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM DetallesPedido
    WHERE producto_id = @producto_id;
    RETURN @en_inventario;
END;
GO 