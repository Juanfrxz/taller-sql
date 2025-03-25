-- 1. Consultar el producto más caro en cada categoría
SELECT p.id AS producto_id, p.nombre AS producto, p.precio, p.categoria_id
FROM Productos p
WHERE p.precio = (SELECT MAX(p2.precio)
                  FROM Productos p2
                  WHERE p2.categoria_id = p.categoria_id);

-- 2. Encontrar el cliente con mayor total en pedidos
SELECT c.id AS cliente_id, c.nombre AS cliente, c.email,
       SUM(p.total) AS total_pedidos
FROM Clientes c
INNER JOIN Pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre, c.email
HAVING SUM(p.total) = (SELECT MAX(total_sum)
                       FROM (SELECT SUM(ped.total) AS total_sum
                             FROM Pedidos ped
                             GROUP BY ped.cliente_id) t);

-- 3. Listar empleados que ganan más que el salario promedio
SELECT e.id AS empleado_id, e.nombre AS empleado, pu.salario
FROM Empleados e
INNER JOIN Puestos pu ON e.puesto_id = pu.id
WHERE pu.salario > (SELECT AVG(salario) FROM Puestos);

-- 4. Consultar productos que han sido pedidos más de 5 veces
SELECT p.id AS producto_id, p.nombre AS producto, COUNT(dp.id) AS veces_pedido
FROM Productos p
INNER JOIN DetallesPedido dp ON p.id = dp.producto_id
GROUP BY p.id, p.nombre
HAVING COUNT(dp.id) > 5;

-- 5. Listar pedidos cuyo total es mayor al promedio de todos los pedidos
SELECT p.id AS pedido_id, p.cliente_id, p.fecha, p.total
FROM Pedidos p
WHERE p.total > (SELECT AVG(total) FROM Pedidos);

-- 6. Seleccionar los 3 proveedores con más productos
SELECT TOP 3 pr.id AS proveedor_id, pr.nombre AS proveedor,
       (SELECT COUNT(prd.id) FROM Productos prd WHERE prd.proveedor_id = pr.id) AS total_productos
FROM Proveedores pr
ORDER BY total_productos DESC;

-- 7. Consultar productos con precio superior al promedio en su tipo
SELECT p.id AS producto_id, p.nombre AS producto, p.precio, p.categoria_id
FROM Productos p
WHERE p.precio > (SELECT AVG(prod2.precio)
                  FROM Productos prod2
                  WHERE prod2.categoria_id = p.categoria_id);

-- 8. Mostrar clientes que han realizado más pedidos que la media
SELECT c.id AS cliente_id, c.nombre AS cliente, c.email,
       (SELECT COUNT(ped.id) FROM Pedidos ped WHERE ped.cliente_id = c.id) AS total_pedidos
FROM Clientes c
WHERE (SELECT COUNT(ped.id) FROM Pedidos ped WHERE ped.cliente_id = c.id) >
      (SELECT AVG(cant) FROM (SELECT COUNT(ped2.id) AS cant FROM Pedidos ped2 GROUP BY ped2.cliente_id) sub);

-- 9. Encontrar productos cuyo precio es mayor que el promedio de todos los productos
SELECT p.id AS producto_id, p.nombre AS producto, p.precio, p.categoria_id
FROM Productos p
WHERE p.precio > (SELECT AVG(precio) FROM Productos);

-- 10. Mostrar empleados cuyo salario es menor al promedio del departamento
SELECT e.id AS empleado_id, e.nombre AS empleado, pu.salario, pu.puesto
FROM Empleados e
INNER JOIN Puestos pu ON e.puesto_id = pu.id
WHERE pu.salario < (SELECT AVG(pu2.salario)
                    FROM Empleados e2
                    INNER JOIN Puestos pu2 ON e2.puesto_id = pu2.id
                    WHERE e2.puesto_id = pu.id); 