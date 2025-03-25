-- 1. Pedidos y clientes asociados
SELECT 
    p.id AS pedido_id,
    p.fecha,
    p.estado,
    c.nombre AS cliente_nombre,
    c.email AS cliente_email
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
ORDER BY p.fecha DESC;

-- 2. Pedidos con ubicación del cliente
SELECT 
    p.id AS pedido_id,
    p.fecha,
    c.nombre AS cliente,
    u.direccion,
    u.ciudad,
    u.estado,
    u.pais
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
LEFT JOIN Ubicaciones u ON u.entidad_id = c.id AND u.entidad_tipo = 'cliente'
ORDER BY p.fecha DESC;

-- 3. Productos con proveedor y tipo
SELECT 
    pr.nombre AS producto,
    pr.precio_base,
    p.nombre AS proveedor,
    cp.nombre AS categoria
FROM Productos pr
INNER JOIN Proveedores p ON pr.proveedor_id = p.id
INNER JOIN CategoriasProductos cp ON pr.categoria_id = cp.id
ORDER BY cp.nombre, pr.nombre;

-- 4. Empleados gestionando pedidos por ciudad
SELECT DISTINCT
    e.nombre AS empleado,
    p.nombre AS puesto,
    u.ciudad,
    COUNT(ped.id) AS total_pedidos
FROM Empleados e
INNER JOIN Puestos p ON e.puesto_id = p.id
INNER JOIN EmpleadosProveedores ep ON e.id = ep.empleado_id
INNER JOIN Pedidos ped ON ep.proveedor_id = ped.id
INNER JOIN Clientes c ON ped.cliente_id = c.id
INNER JOIN Ubicaciones u ON u.entidad_id = c.id AND u.entidad_tipo = 'cliente'
WHERE u.ciudad = 'Bogotá'  -- Reemplazar con la ciudad deseada
GROUP BY e.id, e.nombre, p.nombre, u.ciudad;

-- 5. Los 5 productos más vendidos
SELECT TOP 5
    pr.nombre AS producto,
    SUM(dp.cantidad) AS total_vendido,
    SUM(dp.subtotal) AS total_ingresos
FROM Productos pr
INNER JOIN DetallesPedido dp ON pr.id = dp.producto_id
GROUP BY pr.id, pr.nombre
ORDER BY total_vendido DESC;

-- 6. Pedidos por cliente y ciudad
SELECT 
    c.nombre AS cliente,
    u.ciudad,
    COUNT(p.id) AS total_pedidos,
    SUM(dp.subtotal) AS total_gastado
FROM Clientes c
INNER JOIN Pedidos p ON c.id = p.cliente_id
INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
INNER JOIN Ubicaciones u ON u.entidad_id = c.id AND u.entidad_tipo = 'cliente'
GROUP BY c.id, c.nombre, u.ciudad
ORDER BY total_pedidos DESC;

-- 7. Clientes y proveedores en la misma ciudad
SELECT 
    c.nombre AS cliente,
    p.nombre AS proveedor,
    u.ciudad
FROM Clientes c
INNER JOIN Ubicaciones u ON u.entidad_id = c.id AND u.entidad_tipo = 'cliente'
INNER JOIN Proveedores p ON p.direccion_id = u.id
ORDER BY u.ciudad, c.nombre;

-- 8. Ventas por tipo de producto
SELECT 
    cp.nombre AS categoria,
    COUNT(DISTINCT p.id) AS total_pedidos,
    SUM(dp.subtotal) AS total_ventas,
    AVG(dp.precio_unitario) AS precio_promedio
FROM CategoriasProductos cp
INNER JOIN Productos pr ON cp.id = pr.categoria_id
INNER JOIN DetallesPedido dp ON pr.id = dp.producto_id
INNER JOIN Pedidos p ON dp.pedido_id = p.id
GROUP BY cp.id, cp.nombre
ORDER BY total_ventas DESC;

-- 9. Empleados gestionando pedidos de proveedor específico
SELECT DISTINCT
    e.nombre AS empleado,
    p.nombre AS puesto,
    COUNT(ped.id) AS total_pedidos
FROM Empleados e
INNER JOIN Puestos p ON e.puesto_id = p.id
INNER JOIN EmpleadosProveedores ep ON e.id = ep.empleado_id
INNER JOIN Pedidos ped ON ep.proveedor_id = ped.id
INNER JOIN DetallesPedido dp ON ped.id = dp.pedido_id
INNER JOIN Productos pr ON dp.producto_id = pr.id
WHERE pr.proveedor_id = 1  -- Reemplazar con el ID del proveedor deseado
GROUP BY e.id, e.nombre, p.nombre;

-- 10. Ingresos totales por proveedor
SELECT 
    p.nombre AS proveedor,
    COUNT(DISTINCT ped.id) AS total_pedidos,
    SUM(dp.subtotal) AS ingresos_totales,
    AVG(dp.precio_unitario) AS precio_promedio
FROM Proveedores p
INNER JOIN Productos pr ON p.id = pr.proveedor_id
INNER JOIN DetallesPedido dp ON pr.id = dp.producto_id
INNER JOIN Pedidos ped ON dp.pedido_id = ped.id
GROUP BY p.id, p.nombre
ORDER BY ingresos_totales DESC; 