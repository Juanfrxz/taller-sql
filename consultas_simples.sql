-- 1. Seleccionar todos los productos con precio mayor a $50
SELECT id, nombre, precio, proveedor_id, categoria_id
FROM Productos
WHERE precio > 50;

-- 2. Consultar clientes registrados en una ciudad específica
SELECT c.id, c.nombre, c.email
FROM Clientes c
INNER JOIN Ubicaciones u ON u.entidad_tipo = 'Cliente' AND u.entidad_id = c.id
WHERE u.ciudad = 'CiudadEjemplo';

-- 3. Mostrar empleados contratados en los últimos 2 años
SELECT id, nombre, puesto_id, fecha_contratacion 
FROM Empleados
WHERE fecha_contratacion >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

-- 4. Seleccionar proveedores que suministran más de 5 productos
SELECT pr.id, pr.nombre
FROM Proveedores pr
INNER JOIN Productos p ON pr.id = p.proveedor_id
GROUP BY pr.id, pr.nombre
HAVING COUNT(p.id) > 5;

-- 5. Listar clientes que no tienen dirección registrada en Ubicaciones
SELECT c.id, c.nombre, c.email
FROM Clientes c
LEFT JOIN Ubicaciones u ON u.entidad_tipo = 'Cliente' AND u.entidad_id = c.id
WHERE u.id IS NULL;

-- 6. Calcular el total de ventas por cada cliente
SELECT c.id, c.nombre, IFNULL(SUM(p.total), 0) AS total_ventas
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- 7. Mostrar el salario promedio de los empleados
SELECT AVG(pu.salario) AS salario_promedio
FROM Empleados e
INNER JOIN Puestos pu ON e.puesto_id = pu.id;

-- 8. Consultar el tipo de productos disponibles (usando CategoriasProductos como TiposProductos)
SELECT id, nombre, descripcion, categoria_padre
FROM CategoriasProductos;

-- 9. Seleccionar los 3 productos más caros
SELECT id, nombre, precio, proveedor_id, categoria_id
FROM Productos
ORDER BY precio DESC
LIMIT 3;

-- 10. Consultar el cliente con el mayor número de pedidos
SELECT c.id, c.nombre, COUNT(p.id) AS total_pedidos
FROM Clientes c
LEFT JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre
ORDER BY total_pedidos DESC
LIMIT 1;