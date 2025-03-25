-- 1. Producto más caro por categoría
SELECT 
    cp.nombre AS categoria,
    p.nombre AS producto,
    p.precio_base
FROM Productos p
INNER JOIN CategoriasProductos cp ON p.categoria_id = cp.id
WHERE p.precio_base = (
    SELECT MAX(p2.precio_base)
    FROM Productos p2
    WHERE p2.categoria_id = p.categoria_id
)
ORDER BY cp.nombre;

-- 2. Cliente con mayor total en pedidos
SELECT 
    c.nombre AS cliente,
    SUM(dp.subtotal) AS total_gastado
FROM Clientes c
INNER JOIN Pedidos p ON c.id = p.cliente_id
INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
GROUP BY c.id, c.nombre
HAVING SUM(dp.subtotal) = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(dp2.subtotal) AS total
        FROM Clientes c2
        INNER JOIN Pedidos p2 ON c2.id = p2.cliente_id
        INNER JOIN DetallesPedido dp2 ON p2.id = dp2.pedido_id
        GROUP BY c2.id
    ) AS totales
);

-- 3. Empleados con salario superior al promedio
SELECT 
    e.nombre AS empleado,
    p.nombre AS puesto,
    p.salario_base
FROM Empleados e
INNER JOIN Puestos p ON e.puesto_id = p.id
WHERE p.salario_base > (
    SELECT AVG(salario_base)
    FROM Puestos
)
ORDER BY p.salario_base DESC;

-- 4. Productos pedidos más de 5 veces
SELECT 
    p.nombre AS producto,
    COUNT(dp.id) AS veces_pedido
FROM Productos p
INNER JOIN DetallesPedido dp ON p.id = dp.producto_id
GROUP BY p.id, p.nombre
HAVING COUNT(dp.id) > 5
ORDER BY veces_pedido DESC;

-- 5. Pedidos con total superior al promedio
SELECT 
    p.id AS pedido_id,
    p.fecha,
    SUM(dp.subtotal) AS total
FROM Pedidos p
INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
GROUP BY p.id, p.fecha
HAVING SUM(dp.subtotal) > (
    SELECT AVG(total)
    FROM (
        SELECT SUM(dp2.subtotal) AS total
        FROM Pedidos p2
        INNER JOIN DetallesPedido dp2 ON p2.id = dp2.pedido_id
        GROUP BY p2.id
    ) AS totales
)
ORDER BY total DESC;

-- 6. Top 3 proveedores con más productos
SELECT TOP 3
    p.nombre AS proveedor,
    COUNT(pr.id) AS total_productos
FROM Proveedores p
INNER JOIN Productos pr ON p.id = pr.proveedor_id
GROUP BY p.id, p.nombre
ORDER BY total_productos DESC;

-- 7. Productos con precio superior al promedio de su categoría
SELECT 
    p.nombre AS producto,
    p.precio_base,
    cp.nombre AS categoria
FROM Productos p
INNER JOIN CategoriasProductos cp ON p.categoria_id = cp.id
WHERE p.precio_base > (
    SELECT AVG(p2.precio_base)
    FROM Productos p2
    WHERE p2.categoria_id = p.categoria_id
)
ORDER BY cp.nombre, p.precio_base DESC;

-- 8. Clientes con más pedidos que la media
SELECT 
    c.nombre AS cliente,
    COUNT(p.id) AS total_pedidos
FROM Clientes c
INNER JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre
HAVING COUNT(p.id) > (
    SELECT AVG(total)
    FROM (
        SELECT COUNT(p2.id) AS total
        FROM Clientes c2
        INNER JOIN Pedidos p2 ON c2.id = p2.cliente_id
        GROUP BY c2.id
    ) AS totales
)
ORDER BY total_pedidos DESC;

-- 9. Productos con precio superior al promedio general
SELECT 
    p.nombre AS producto,
    p.precio_base,
    cp.nombre AS categoria
FROM Productos p
INNER JOIN CategoriasProductos cp ON p.categoria_id = cp.id
WHERE p.precio_base > (
    SELECT AVG(precio_base)
    FROM Productos
)
ORDER BY p.precio_base DESC;

-- 10. Empleados con salario menor al promedio de su puesto
SELECT 
    e.nombre AS empleado,
    p.nombre AS puesto,
    p.salario_base
FROM Empleados e
INNER JOIN Puestos p ON e.puesto_id = p.id
WHERE p.salario_base < (
    SELECT AVG(p2.salario_base)
    FROM Puestos p2
    WHERE p2.id = p.id
)
ORDER BY p.nombre, p.salario_base; 