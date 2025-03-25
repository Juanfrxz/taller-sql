-- 1. Lista de pedidos con nombres de clientes (INNER JOIN)
SELECT p.id AS pedido_id, p.fecha, p.estado, c.nombre AS cliente_nombre
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id;

-- 2. Productos y sus proveedores (INNER JOIN)
SELECT pr.nombre AS producto, p.nombre AS proveedor
FROM Productos pr
INNER JOIN Proveedores p ON pr.proveedor_id = p.id;

-- 3. Pedidos y ubicaciones de clientes (LEFT JOIN)
SELECT p.id AS pedido_id, p.fecha, u.direccion, u.ciudad, u.estado
FROM Pedidos p
LEFT JOIN Ubicaciones u ON u.entidad_id = p.cliente_id AND u.entidad_tipo = 'cliente';

-- 4. Empleados y sus pedidos registrados (LEFT JOIN)
SELECT e.nombre AS empleado, p.id AS pedido_id, p.fecha
FROM Empleados e
LEFT JOIN EmpleadosProveedores ep ON e.id = ep.empleado_id
LEFT JOIN Pedidos p ON ep.proveedor_id = p.id;

-- 5. Tipos de productos y productos asociados (INNER JOIN)
SELECT cp.nombre AS categoria, pr.nombre AS producto
FROM CategoriasProductos cp
INNER JOIN Productos pr ON cp.id = pr.categoria_id;

-- 6. Clientes y número de pedidos (COUNT y GROUP BY)
SELECT c.nombre AS cliente, COUNT(p.id) AS total_pedidos
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- 7. Empleados y pedidos gestionados
SELECT e.nombre AS empleado, p.id AS pedido_id, p.fecha, p.estado
FROM Empleados e
INNER JOIN EmpleadosProveedores ep ON e.id = ep.empleado_id
INNER JOIN Pedidos p ON ep.proveedor_id = p.id;

-- 8. Productos sin pedidos (RIGHT JOIN)
SELECT pr.nombre AS producto, dp.id AS detalle_pedido
FROM DetallesPedido dp
RIGHT JOIN Productos pr ON dp.producto_id = pr.id
WHERE dp.id IS NULL;

-- 9. Total de pedidos y ubicación de clientes (múltiples JOIN)
SELECT 
    c.nombre AS cliente,
    COUNT(p.id) AS total_pedidos,
    u.direccion,
    u.ciudad,
    u.estado
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
LEFT JOIN Ubicaciones u ON u.entidad_id = c.id AND u.entidad_tipo = 'cliente'
GROUP BY c.id, c.nombre, u.direccion, u.ciudad, u.estado;

-- 10. Listado completo de inventario (Proveedores, Productos y Categorías)
SELECT 
    pr.nombre AS producto,
    p.nombre AS proveedor,
    cp.nombre AS categoria,
    pr.precio_base
FROM Productos pr
INNER JOIN Proveedores p ON pr.proveedor_id = p.id
INNER JOIN CategoriasProductos cp ON pr.categoria_id = cp.id
ORDER BY cp.nombre, pr.nombre; 