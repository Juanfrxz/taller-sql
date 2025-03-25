/* Trigger 1: Registrar en HistorialSalarios cada cambio de salario en Puestos */
DROP TRIGGER IF EXISTS trg_registrar_salario;
DELIMITER $$
CREATE TRIGGER trg_registrar_salario
AFTER UPDATE ON Puestos
FOR EACH ROW
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO HistorialSalarios(puesto_id, salario_anterior, salario_nuevo, fecha_cambio)
        VALUES (NEW.id, OLD.salario, NEW.salario, NOW());
    END IF;
END$$
DELIMITER ;

/* Trigger 2: Evitar borrar productos con pedidos activos */
DROP TRIGGER IF EXISTS trg_no_borrar_producto_con_pedidos;
DELIMITER $$
CREATE TRIGGER trg_no_borrar_producto_con_pedidos
BEFORE DELETE ON Productos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM DetallesPedido WHERE producto_id = OLD.id) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'No se puede borrar un producto con pedidos activos';
    END IF;
END$$
DELIMITER ;

/* Trigger 3: Registrar en HistorialPedidos cada actualización en Pedidos */
DROP TRIGGER IF EXISTS trg_registrar_actualizacion_pedidos;
DELIMITER $$
CREATE TRIGGER trg_registrar_actualizacion_pedidos
AFTER UPDATE ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPedidos(pedido_id, cambio, fecha_cambio)
    VALUES (NEW.id, CONCAT('Actualización en Pedido: de total ', OLD.total, ' a ', NEW.total), NOW());
END$$
DELIMITER ;

/* Trigger 4: Actualizar el inventario al registrar un pedido (en DetallesPedido) */
DROP TRIGGER IF EXISTS trg_actualizar_inventario_despues_pedido;
DELIMITER $$
CREATE TRIGGER trg_actualizar_inventario_despues_pedido
AFTER INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    UPDATE Inventario
    SET stock = stock - NEW.cantidad
    WHERE producto_id = NEW.producto_id;
END$$
DELIMITER ;

/* Trigger 5: Evitar actualizaciones de precio a menos de $1 en Productos */
DROP TRIGGER IF EXISTS trg_evitar_precio_bajo;
DELIMITER $$
CREATE TRIGGER trg_evitar_precio_bajo
BEFORE UPDATE ON Productos
FOR EACH ROW
BEGIN
    IF NEW.precio < 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El precio no puede ser menor a $1';
    END IF;
END$$
DELIMITER ;

/* Trigger 6: Registrar la fecha de creación de un pedido en HistorialPedidos */
DROP TRIGGER IF EXISTS trg_registrar_creacion_pedido;
DELIMITER $$
CREATE TRIGGER trg_registrar_creacion_pedido
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO HistorialPedidos(pedido_id, cambio, fecha_cambio)
    VALUES (NEW.id, CONCAT('Creado en ', NEW.fecha), NOW());
END$$
DELIMITER ;

/* Trigger 7: Mantener el precio total de cada pedido en Pedidos */
DROP TRIGGER IF EXISTS trg_actualizar_total_pedido;
DELIMITER $$
CREATE TRIGGER trg_actualizar_total_pedido
AFTER INSERT ON DetallesPedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET total = (SELECT COALESCE(SUM(cantidad * precio), 0) FROM DetallesPedido WHERE pedido_id = NEW.pedido_id)
    WHERE id = NEW.pedido_id;
END$$
DELIMITER ;

/* Trigger 8: Validar que la dirección en Ubicaciones para clientes no esté vacía */
DROP TRIGGER IF EXISTS trg_validar_ubicacion_cliente;
DELIMITER $$
CREATE TRIGGER trg_validar_ubicacion_cliente
BEFORE INSERT ON Ubicaciones
FOR EACH ROW
BEGIN
    IF NEW.entidad_tipo = 'Cliente' AND (NEW.direccion IS NULL OR NEW.direccion = '') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'La dirección para el cliente no puede estar vacía';
    END IF;
END$$
DELIMITER ;

/* Trigger 9: Registrar en LogActividades cada modificación en Proveedores */
DROP TRIGGER IF EXISTS trg_log_modificacion_proveedores;
DELIMITER $$
CREATE TRIGGER trg_log_modificacion_proveedores
AFTER UPDATE ON Proveedores
FOR EACH ROW
BEGIN
    INSERT INTO LogActividades(proveedor_id, actividad, fecha)
    VALUES (NEW.id, 'Modificación en Proveedor', NOW());
END$$
DELIMITER ;

/* Trigger 10: Registrar en HistorialContratos cada cambio en Empleados */
DROP TRIGGER IF EXISTS trg_historial_contratos;
DELIMITER $$
CREATE TRIGGER trg_historial_contratos
AFTER UPDATE ON Empleados
FOR EACH ROW
BEGIN
    INSERT INTO HistorialContratos(empleado_id, cambio, fecha_cambio)
    VALUES (NEW.id, CONCAT('Cambio en Empleado: ', OLD.nombre, ' a ', NEW.nombre), NOW());
END$$
DELIMITER ; 