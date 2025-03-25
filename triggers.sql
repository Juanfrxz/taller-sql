-- 1. Trigger para registrar cambios de salario en HistorialSalarios
CREATE TRIGGER RegistrarCambioSalario
ON Empleados
AFTER UPDATE
AS
BEGIN
    IF UPDATE(salario_base)
    BEGIN
        INSERT INTO HistorialSalarios(empleado_id, salario_anterior, salario_nuevo, fecha_cambio)
        SELECT 
            i.id, 
            d.salario_base, 
            i.salario_base, 
            GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id;
    END
END;
GO

-- 2. Trigger para evitar borrar productos con pedidos activos
CREATE TRIGGER EvitarBorrarProductos
ON Productos
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Pedidos p INNER JOIN deleted d ON p.producto_id = d.id WHERE p.estado IN ('pendiente', 'procesando'))
    BEGIN
        RAISERROR ('No se puede borrar productos con pedidos activos.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Productos WHERE id IN (SELECT id FROM deleted);
    END
END;
GO

-- 3. Trigger para registrar cada actualización en Pedidos en HistorialPedidos
CREATE TRIGGER RegistrarHistorialPedidos
ON Pedidos
AFTER UPDATE
AS
BEGIN
    INSERT INTO HistorialPedidos(pedido_id, fecha_cambio, estado_anterior, estado_nuevo, usuario)
    SELECT 
        i.id, 
        GETDATE(), 
        d.estado, 
        i.estado, 
        SUSER_SNAME()
    FROM inserted i
    INNER JOIN deleted d ON i.id = d.id;
END;
GO

-- 4. Trigger para actualizar inventario al registrar un pedido
CREATE TRIGGER ActualizarInventario
ON Pedidos
AFTER INSERT
AS
BEGIN
    UPDATE Productos
    SET cantidad = cantidad - i.cantidad
    FROM Productos p
    INNER JOIN inserted i ON p.id = i.producto_id;
END;
GO

-- 5. Trigger para evitar actualizaciones de precio a menos de $1
CREATE TRIGGER ValidarPrecioProducto
ON Productos
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE precio_base < 1)
    BEGIN
        RAISERROR ('El precio del producto no puede ser menor a $1.', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE p
        SET p.nombre = i.nombre,
            p.precio_base = i.precio_base,
            p.proveedor_id = i.proveedor_id,
            p.categoria_id = i.categoria_id
        FROM Productos p
        INNER JOIN inserted i ON p.id = i.id;
    END
END;
GO

-- 6. Trigger para registrar la fecha de creación de un pedido en HistorialPedidos
CREATE TRIGGER RegistrarFechaCreacionPedido
ON Pedidos
AFTER INSERT
AS
BEGIN
    INSERT INTO HistorialPedidos(pedido_id, fecha_cambio, estado_anterior, estado_nuevo, usuario)
    SELECT 
        id, 
        GETDATE(), 
        NULL, 
        estado, 
        SUSER_SNAME()
    FROM inserted;
END;
GO

-- 7. Trigger para mantener el precio total de cada pedido en Pedidos
CREATE TRIGGER MantenerTotalPedido
ON DetallesPedido
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Pedidos
    SET total = (SELECT SUM(subtotal) FROM DetallesPedido WHERE pedido_id = i.pedido_id)
    FROM inserted i;
END;
GO

-- 8. Trigger para validar que la dirección del cliente no esté vacía al crear un cliente
CREATE TRIGGER ValidarDireccionCliente
ON Clientes
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE direccion IS NULL)
    BEGIN
        RAISERROR ('La dirección del cliente no puede estar vacía.', 16, 1);
    END
END;
GO

-- 9. Trigger para registrar cada modificación en Proveedores en LogActividades
CREATE TRIGGER RegistrarLogActividades
ON Proveedores
AFTER UPDATE
AS
BEGIN
    INSERT INTO LogActividades(proveedor_id, descripcion, fecha)
    SELECT 
        id, 
        'Proveedor modificado', 
        GETDATE()
    FROM inserted;
END;
GO

-- 10. Trigger para registrar cambios en Empleados en HistorialContratos
CREATE TRIGGER RegistrarHistorialContratos
ON Empleados
AFTER UPDATE
AS
BEGIN
    INSERT INTO HistorialContratos(empleado_id, contrato_anterior, contrato_nuevo, fecha_cambio)
    SELECT 
        i.id, 
        d.contrato, 
        i.contrato, 
        GETDATE()
    FROM inserted i
    INNER JOIN deleted d ON i.id = d.id;
END;
GO 