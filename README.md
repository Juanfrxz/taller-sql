# Proyecto de Base de Datos "vtaszfs" 🚀

Este repositorio contiene la solución completa para el proyecto de base de datos "vtaszfs". El proyecto incluye:

- Comandos DDL para la creación de la base de datos y tablas. 🏗️
- Comandos DML para la inserción de datos de prueba. 🍀
- Consultas SQL desarrolladas, cada una con su solución y prueba.

## Archivos del Repositorio

- **db.sql**: (DDL) Contiene los comandos para la creación de la base de datos y todas las tablas principales.
- **dml.sql**: (DML) Incluye comandos para la inserción de datos de prueba en las tablas.
- **consultas_simples.sql**: Contiene 10 consultas simples.
- **subconsultas.sql**: Contiene 10 subconsultas que resuelven problemas complejos.
- **procedimientos_almacenados.sql**: Incluye 10 procedimientos almacenados para operaciones específicas.
- **triggers.sql**: Contiene 10 triggers que automatizan diversas acciones en la base de datos.
- **funciones.sql**: Funciones definidas por el usuario para cálculos personalizados y validaciones.

## Descripción de las Consultas y Pruebas

### Consultas Simples
1. **Productos con precio > $50**: 
   - **Solución:** Filtra los productos cuyo precio supera los $50.
   - **Prueba:** Se insertaron productos con precios variados y se verificó que solo se muestren aquellos que cumplen la condición.

2. **Clientes por ciudad**: 
   - **Solución:** Recupera clientes que tienen registrada una ubicación en una ciudad específica.
   - **Prueba:** Se probó asociando múltiples clientes a diferentes ciudades y validando el filtrado.

3. **Empleados recientes**: 
   - **Solución:** Muestra a los empleados contratados en los últimos 2 años.
   - **Prueba:** Se insertaron registros con fechas de contratación diversas para validar la consulta.

4. **Proveedores con más de 5 productos**: 
   - **Solución:** Agrupa a los proveedores y muestra aquellos que suministran más de 5 productos.
   - **Prueba:** Se probaron casos con proveedores que tienen distintos volúmenes de productos.

5. **Clientes sin dirección registrada**: 
   - **Solución:** Utiliza LEFT JOIN para identificar clientes sin una dirección asignada.
   - **Prueba:** Se verificó que los clientes sin dirección en la tabla de ubicaciones aparezcan correctamente.

6. **Total de ventas por cliente**: 
   - **Solución:** Suma el total de ventas de los pedidos realizados por cada cliente.
   - **Prueba:** Se realizaron sumas y se compararon los resultados esperados con los totales de la tabla de pedidos.

7. **Salario promedio de empleados**: 
   - **Solución:** Calcula el salario promedio uniendo las tablas de Empleados y Puestos.
   - **Prueba:** Se comprobó el cálculo promediando salarios registrados en la base de datos.

8. **Tipos de productos**: 
   - **Solución:** Consulta la tabla de categorías para listar los diferentes tipos de productos disponibles.
   - **Prueba:** Se verificó la salida comparando los tipos de productos disponibles en la tabla de categorías.

9. **Top 3 productos más caros**: 
   - **Solución:** Ordena los productos por precio y limita la salida a los 3 productos más costosos.
   - **Prueba:** Se insertaron productos con precios altos y se comprobó que solo se muestren los tres primeros.

10. **Cliente con mayor número de pedidos**: 
    - **Solución:** Ordena los clientes por la cantidad de pedidos y selecciona el que tiene el mayor número.
    - **Prueba:** Se validó contando el número de pedidos por cliente y comparando con el valor máximo.

### Subconsultas
- **Producto más caro por categoría**: Utiliza una subconsulta correlacionada para encontrar el producto más caro en cada categoría.
- **Cliente con mayor acumulado en pedidos**: Emplea una subconsulta anidada para determinar el cliente con el mayor total acumulado en pedidos.
- **Empleados con salario superior/inferior al promedio**: Filtra empleados según su salario comparado con la media.
- (Otros ejemplos de subconsultas se documentan de forma similar.)

### Procedimientos Almacenados
- **ActualizarPreciosProveedor**: Actualiza los precios de productos de un proveedor aplicando un porcentaje de aumento.
- **ObtenerDireccionCliente**: Recupera la dirección del cliente a partir de su ID.
- **RegistrarPedido**: Inserta un nuevo pedido y sus detalles correspondientes.
- **CalcularTotalVentasCliente**: Calcula el total de ventas y el promedio de los pedidos realizados por un cliente.
- (Otros procedimientos se describen en detalle en el archivo.)

### Triggers
- **HistorialSalarios**: Registra cada cambio en el salario de los empleados.
- **No borrar productos con pedidos activos**: Previene la eliminación de productos que tienen pedidos asociados.
- **Actualización de inventario**: Ajusta el stock tras la inserción de un nuevo pedido.
- (Otros triggers se documentan de forma similar.)

## Cómo Probar el Proyecto 🧪

1. Ejecuta el archivo **db.sql** para crear la base de datos y las tablas. 🚀
2. Ejecuta el archivo **dml.sql** para poblar las tablas con datos de prueba. 🎉
3. Ejecuta las consultas en **consultas_simples.sql** y **subconsultas.sql** para validar sus soluciones y comprobar los resultados.
4. Prueba los **procedimientos almacenados** ejecutándolos y verificando que realicen las operaciones correctas.
5. Realiza acciones en las tablas para activar los **triggers** y observa cómo se registran los cambios automáticos.
6. Utiliza las **funciones** (en funciones.sql) para realizar cálculos y validaciones personalizadas.
