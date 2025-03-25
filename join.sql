-- 1. Obtener la lista de todos los pedidos con los nombres de clientes usando INNER JOIN .
SELECT
p.id AS pedido_id,
p.fecha,
c.nombre AS cliente,
p.total
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id;

-- 2. Listar los productos y proveedores que los suministran con INNER JOIN .
SELECT
prd.id AS producto_id,
prd.nombre AS producto,
pr.nombre AS proveedor
FROM Productos prd
INNER JOIN Proveedores pr ON prd.proveedor_id = pr.id;

-- 3. Mostrar los pedidos y las ubicaciones de los clientes con LEFT JOIN .
SELECT
p.id AS pedido_id,
p.fecha,
c.nombre AS cliente,
u.direccion,
u.ciudad,
u.estado
FROM Pedidos p
INNER JOIN Clientes c ON p.cliente_id = c.id
LEFT JOIN Ubicaciones u ON u.entidad_tipo = 'Cliente' AND u.entidad_id = c.id;

-- 4. Consultar los empleados que han registrado pedidos, incluyendo empleados sin pedidos ( LEFT JOIN ).
SELECT
e.id AS empleado_id,
e.nombre AS empleado,
p.id AS pedido_id,
p.fecha
FROM Empleados e
LEFT JOIN Pedidos p ON e.id = p.empleado_id;

-- 5. Obtener el tipo de producto y los productos asociados con INNER JOIN .
SELECT
c.id AS categoria_id,
c.nombre AS categoria,
p.id AS producto_id,
p.nombre AS producto
FROM Productos p
INNER JOIN CategoriasProductos c ON p.categoria_id = c.id;

-- 6. Listar todos los clientes y el número de pedidos realizados con COUNT y GROUP BY .
SELECT
c.id AS cliente_id,
c.nombre,
COUNT(p.id) AS total_pedidos
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- 7. Combinar Pedidos y Empleados para mostrar qué empleados gestionaron pedidos específicos.
SELECT
p.id AS pedido_id,
p.fecha,
e.id AS empleado_id,
e.nombre AS empleado
FROM Pedidos p
INNER JOIN Empleados e ON p.empleado_id = e.id;

-- 8. Mostrar productos que no han sido pedidos ( RIGHT JOIN ).
SELECT
p.id AS producto_id,
p.nombre AS producto
FROM DetallesPedido dp
RIGHT JOIN Productos p ON dp.producto_id = p.id
WHERE dp.producto_id IS NULL;

-- 9. Mostrar el total de pedidos y ubicación de clientes usando múltiples JOIN .
SELECT
c.id AS cliente_id,
c.nombre,
COUNT(p.id) AS total_pedidos,
u.direccion,
u.ciudad,
u.estado
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
LEFT JOIN Ubicaciones u ON u.entidad_tipo = 'Cliente' AND u.entidad_id = c.id
GROUP BY c.id, c.nombre, u.direccion, u.ciudad, u.estado;

-- 10. Unir Proveedores , Productos , y TiposProductos para un listado completo de inventario.
SELECT
pr.id AS proveedor_id,
pr.nombre AS proveedor,
p.id AS producto_id,
p.nombre AS producto,
c.nombre AS categoria,
p.precio
FROM Productos p
INNER JOIN Proveedores pr ON p.proveedor_id = pr.id
INNER JOIN CategoriasProductos c ON p.categoria_id = c.id;