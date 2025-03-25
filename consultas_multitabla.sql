-- 1. Listar todos los pedidos y el cliente asociado
SELECT p.id AS pedido_id, p.fecha, p.total, c.id AS cliente_id, c.nombre AS cliente, c.email AS email
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id;

-- 2. Mostrar la ubicación de cada cliente en sus pedidos
SELECT p.id AS pedido_id, c.nombre AS cliente, u.direccion, u.ciudad, u.estado, u.codigo_postal, u.pais
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
LEFT JOIN Ubicaciones u ON u.entidad_tipo = 'Cliente' AND u.entidad_id = c.id;

-- 3. Listar productos junto con el proveedor y el tipo de producto (categoría)
SELECT prod.id AS producto_id, prod.nombre AS producto, prod.precio, 
       prov.id AS proveedor_id, prov.nombre AS proveedor, 
       cat.id AS categoria_id, cat.nombre AS categoria, cat.descripcion
FROM Productos prod
INNER JOIN Proveedores prov ON prod.proveedor_id = prov.id
INNER JOIN CategoriasProductos cat ON prod.categoria_id = cat.id;

-- 4. Consultar todos los empleados que gestionan pedidos de clientes en una ciudad específica
SELECT DISTINCT e.id AS empleado_id, e.nombre AS empleado
FROM Pedidos p
INNER JOIN Empleados e ON p.empleado_id = e.id
INNER JOIN Clientes c ON p.cliente_id = c.id
INNER JOIN Ubicaciones u ON u.entidad_tipo = 'Cliente' AND u.entidad_id = c.id
WHERE u.ciudad = 'CiudadEjemplo';

-- 5. Consultar los 5 productos más vendidos
SELECT prod.id AS producto_id, prod.nombre AS producto, SUM(dp.cantidad) AS total_vendido
FROM DetallesPedido dp
INNER JOIN Productos prod ON dp.producto_id = prod.id
GROUP BY prod.id, prod.nombre
ORDER BY total_vendido DESC
LIMIT 5;

-- 6. Obtener la cantidad total de pedidos por cliente y ciudad
SELECT c.id AS cliente_id, c.nombre AS cliente, u.ciudad, COUNT(p.id) AS total_pedidos
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
LEFT JOIN Ubicaciones u ON u.entidad_tipo = 'Cliente' AND u.entidad_id = c.id
GROUP BY c.id, c.nombre, u.ciudad;

-- 7. Listar clientes y proveedores en la misma ciudad
SELECT DISTINCT c.id AS cliente_id, c.nombre AS cliente, u.ciudad, prov.id AS proveedor_id, prov.nombre AS proveedor
FROM Clientes c
INNER JOIN Ubicaciones u ON u.entidad_tipo = 'Cliente' AND u.entidad_id = c.id
INNER JOIN Ubicaciones u2 ON u2.entidad_tipo = 'Proveedor' AND u2.ciudad = u.ciudad
INNER JOIN Proveedores prov ON prov.id = u2.entidad_id;

-- 8. Mostrar el total de ventas agrupado por tipo de producto
SELECT cat.id AS categoria_id, cat.nombre AS categoria, SUM(dp.precio * dp.cantidad) AS total_ventas
FROM DetallesPedido dp
INNER JOIN Productos prod ON dp.producto_id = prod.id
INNER JOIN CategoriasProductos cat ON prod.categoria_id = cat.id
GROUP BY cat.id, cat.nombre;

-- 9. Listar empleados que gestionan pedidos de productos de un proveedor específico
SELECT DISTINCT e.id AS empleado_id, e.nombre AS empleado
FROM Pedidos p
INNER JOIN DetallesPedido dp ON p.id = dp.pedido_id
INNER JOIN Productos prod ON dp.producto_id = prod.id
INNER JOIN Proveedores prov ON prod.proveedor_id = prov.id
INNER JOIN Empleados e ON p.empleado_id = e.id
WHERE prov.id = 1;

-- 10. Obtener el ingreso total de cada proveedor a partir de los productos vendidos
SELECT prov.id AS proveedor_id, prov.nombre AS proveedor, SUM(dp.precio * dp.cantidad) AS ingreso_total
FROM DetallesPedido dp
INNER JOIN Productos prod ON dp.producto_id = prod.id
INNER JOIN Proveedores prov ON prod.proveedor_id = prov.id
GROUP BY prov.id, prov.nombre; 