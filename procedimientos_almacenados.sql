
-- 1. Función que recibe una fecha y devuelve los días transcurridos
DELIMITER $$
CREATE FUNCTION CalcularDiasTranscurridos(fecha DATE)
RETURNS INT DETERMINISTIC
BEGIN
    RETURN DATEDIFF(CURDATE(), fecha);
END $$
DELIMITER;

-- 2. Función para calcular el total con impuesto de un monto (impuesto fijo del 16%)
DELIMITER $$
CREATE FUNCTION CalcularTotalConImpuesto(monto DECIMAL(10,2))
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    RETURN monto * 1.16;
END $$
DELIMITER;

-- 3. Función que devuelve el total (cantidad) de pedidos de un cliente específico
DELIMITER $$
CREATE FUNCTION TotalPedidosCliente(clienteID INT)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalPedidos INT;
    SELECT COUNT(*) INTO totalPedidos FROM Pedidos WHERE cliente_id = clienteID;
    RETURN totalPedidos;
END $$
DELIMITER;

-- 4. Función para aplicar un descuento a un producto
DELIMITER $$
CREATE FUNCTION AplicarDescuentoProducto(precio DECIMAL(10,2), descuento DECIMAL(5,2))
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    RETURN precio * (1 - (descuento / 100));
END $$
DELIMITER;

-- 5. Función que indica si un cliente tiene dirección registrada
DELIMITER $$
CREATE FUNCTION ClienteTieneDireccion(clienteID INT)
RETURNS TINYINT DETERMINISTIC
BEGIN
    IF EXISTS (SELECT 1 FROM Ubicaciones WHERE entidad_tipo = 'Cliente' AND entidad_id = clienteID) THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END $$
DELIMITER;

-- 6. Función que devuelve el salario anual de un empleado
DELIMITER $$
CREATE FUNCTION SalarioAnualEmpleado(empleadoID INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE salario DECIMAL(10,2);
    SELECT p.salario INTO salario
    FROM Empleados e JOIN Puestos p ON e.puesto_id = p.id
    WHERE e.id = empleadoID;
    RETURN salario * 12;
END $$
DELIMITER;

-- 7. Función para calcular el total de ventas de un tipo de producto (por categoría)
DELIMITER $$
CREATE FUNCTION TotalVentasPorCategoria(categoriaID INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE totalVentas DECIMAL(10,2);
    SELECT COALESCE(SUM(cantidad * precio), 0) INTO totalVentas
    FROM DetallesPedido dp JOIN Productos p ON dp.producto_id = p.id
    WHERE p.categoria_id = categoriaID;
    RETURN totalVentas;
END $$
DELIMITER;

-- 8. Función para devolver el nombre de un cliente por ID
DELIMITER $$
CREATE FUNCTION ObtenerNombreCliente(clienteID INT)
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
    DECLARE nombreCliente VARCHAR(100);
    SELECT nombre INTO nombreCliente FROM Clientes WHERE id = clienteID;
    RETURN nombreCliente;
END $$
DELIMITER;

-- 9. Función que recibe el ID de un pedido y devuelve su total
DELIMITER $$
CREATE FUNCTION ObtenerTotalPedido(pedidoID INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT total INTO total FROM Pedidos WHERE id = pedidoID;
    RETURN total;
END $$
DELIMITER;

-- 10. Función que indica si un producto está en inventario (se asume que está si existe en la tabla Productos)
DELIMITER $$
CREATE FUNCTION ProductoEnInventario(productoID INT)
RETURNS TINYINT DETERMINISTIC
BEGIN
    IF EXISTS (SELECT 1 FROM Productos WHERE id = productoID) THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END $$
DELIMITER ;