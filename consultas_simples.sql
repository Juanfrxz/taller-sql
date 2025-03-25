-- 1. Productos con precio mayor a $50
SELECT nombre, precio_base
FROM Productos
WHERE precio_base > 50
ORDER BY precio_base DESC;

-- 2. Clientes registrados en una ciudad específica
SELECT c.nombre, c.email, u.ciudad
FROM Clientes c
INNER JOIN Ubicaciones u ON u.entidad_id = c.id AND u.entidad_tipo = 'cliente'
WHERE u.ciudad = 'Bogotá';  -- Reemplazar con la ciudad deseada

-- 3. Empleados contratados en los últimos 2 años
SELECT e.nombre, e.fecha_contratacion, p.nombre AS puesto
FROM Empleados e
INNER JOIN Puestos p ON e.puesto_id = p.id
WHERE e.fecha_contratacion >= DATE_SUB(CURRENT_DATE, INTERVAL 2 YEAR)
ORDER BY e.fecha_contratacion DESC;

-- 4. Proveedores con más de 5 productos
SELECT p.nombre AS proveedor, COUNT(pr.id) AS total_productos
FROM Proveedores p
INNER JOIN Productos pr ON p.id = pr.proveedor_id
GROUP BY p.id, p.nombre
HAVING COUNT(pr.id) > 5
ORDER BY total_productos DESC;

-- 5. Clientes sin dirección registrada
SELECT c.nombre, c.email
FROM Clientes c
LEFT JOIN Ubicaciones u ON u.entidad_id = c.id AND u.entidad_tipo = 'cliente'
WHERE u.id IS NULL;

-- 6. Total de ventas por cliente
SELECT 
    c.nombre AS cliente,
    COUNT(p.id) AS total_pedidos,
    SUM(dp.subtotal) AS total_ventas
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
LEFT JOIN DetallesPedido dp ON p.id = dp.pedido_id
GROUP BY c.id, c.nombre
ORDER BY total_ventas DESC;

-- 7. Salario promedio de empleados
SELECT 
    p.nombre AS puesto,
    COUNT(e.id) AS total_empleados,
    AVG(p.salario_base) AS salario_promedio
FROM Puestos p
INNER JOIN Empleados e ON p.id = e.puesto_id
GROUP BY p.id, p.nombre;

-- 8. Tipos de productos disponibles
SELECT 
    cp.nombre AS categoria,
    COUNT(pr.id) AS total_productos
FROM CategoriasProductos cp
LEFT JOIN Productos pr ON cp.id = pr.categoria_id
GROUP BY cp.id, cp.nombre
ORDER BY cp.nombre;

-- 9. Los 3 productos más caros
SELECT TOP 3 nombre, precio_base
FROM Productos
ORDER BY precio_base DESC;

-- 10. Cliente con más pedidos
SELECT TOP 1
    c.nombre AS cliente,
    COUNT(p.id) AS total_pedidos,
    SUM(dp.subtotal) AS total_gastado
FROM Clientes c
INNER JOIN Pedidos p ON c.id = p.cliente_id
INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
GROUP BY c.id, c.nombre
ORDER BY total_pedidos DESC; 