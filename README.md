# Daniel Navas Becerra (Base de Datos para la Tienda en Línea "Tech Haven")



## Consultas

1. Obtener la lista de todos los productos con sus precios.

   ```mysql
   SELECT nombre, precio
   FROM productos;
   ```

   

2. Encontrar todos los pedidos realizados por un usuario específico, por ejemplo, `Juan Perez`.

   ```mysql
   SELECT p.id, p.fecha, p.total
   FROM usuarios AS u
   JOIN pedidos AS p ON u.id = p.id_usuario
   WHERE u.nombre = 'Juan Perez';
   ```

   

3. Listar los detalles de todos los pedidos, incluyendo el nombre del producto, cantidad y precio unitario.

   ```mysql
   SELECT p.id AS PedidoID, pr.nombre AS Producto, dp.cantidad, dp.precio_unitario
   FROM pedidos AS p
   JOIN detalles_pedidos AS dp ON p.id = dp.id_pedido
   JOIN productos AS pr ON dp.id_producto = pr.id;
   ```

   

4. Calcular el total gastado por cada usuario en todos sus pedidos.

   ```mysql
   SELECT u.nombre, p.total AS TotalGastado
   FROM usuarios AS u
   JOIN pedidos AS p ON u.id = p.id_usuario;
   ```

   

5. Encontrar los productos más caros (precio mayor a $500).

   ```mysql
   SELECT nombre, precio
   FROM productos
   WHERE precio > 500;
   ```

   

6. Listar los pedidos realizados en una fecha específica, por ejemplo, `2024-03-10`.

   ```mysql
   SELECT id, id_usuario, fecha, total
   FROM pedidos
   WHERE fecha = '2024-03-10';
   ```

   

7. Obtener el número total de pedidos realizados por cada usuario.

   ```mysql
   SELECT u.nombre, COUNT(p.id) AS NumeroDePedidos
   FROM usuarios AS u
   JOIN pedidos AS p ON u.id = p.id_usuario
   GROUP BY u.id, u.nombre;
   ```

   

8. Encontrar el nombre del producto más vendido (mayor cantidad total vendida).

   ```mysql
   SELECT p.nombre, dp.cantidad AS CantidadTotal
   FROM productos AS p
   JOIN detalles_pedidos AS dp ON p.id = dp.id_producto
   ORDER BY CantidadTotal DESC
   LIMIT 1;
   ```

   

9. Listar todos los usuarios que han realizado al menos un pedido.

   ```mysql
   SELECT u.nombre, u.correo_electronico
   FROM usuarios AS u
   JOIN pedidos AS p ON u.id = p.id_usuario;
   ```

   

10. Obtener los detalles de un pedido específico, incluyendo los productos y cantidades, por
    ejemplo, pedido con `id` 1.

    ```mysql
    SELECT p.id AS PedidoID, u.nombre AS Usuario, pr.nombre AS Producto, dp.cantidad, dp.precio_unitario
    FROM usuarios AS u
    JOIN pedidos AS p ON u.id = p.id_usuario
    JOIN detalles_pedidos AS dp ON p.id = dp.id_pedido
    JOIN productos AS pr ON dp.id_producto = pr.id
    WHERE p.id = 1;
    ```

    



## Subconsultas

1. Encontrar el nombre del usuario que ha gastado más en total.

   ```mysql
   SELECT u.nombre
   FROM usuarios AS u
   JOIN (
       SELECT id_usuario, SUM(total) AS total_gastado
       FROM pedidos
       GROUP BY id_usuario
   ) AS gastos ON u.id = gastos.id_usuario
   ORDER BY gastos.total_gastado DESC
   LIMIT 1;
   ```

   

2. Listar los productos que han sido pedidos al menos una vez.

   ```mysql
   SELECT p.nombre
   FROM productos AS p
   WHERE id IN (
       SELECT id_producto
       FROM detalles_pedidos
   );
   ```

   

3. Obtener los detalles del pedido con el total más alto.

   ```mysql
   SELECT p.id, p.id_usuario, p.fecha, p.total
   FROM pedidos AS p
   JOIN (
       SELECT id
       FROM pedidos
       ORDER BY total DESC
       LIMIT 1
   ) AS pedido_max ON p.id = pedido_max.id;
   ```

   

4. Listar los usuarios que han realizado más de un pedido.

   ```mysql
   SELECT u.nombre, u.correo_electronico
   FROM usuarios AS u
   JOIN (
       SELECT id_usuario, COUNT(id) AS cantidad_pedidos
       FROM pedidos
       GROUP BY id_usuario
       HAVING COUNT(id) > 1
   ) AS pedidos_usuario ON u.id = pedidos_usuario.id_usuario;
   ```

   

5. Encontrar el producto más caro que ha sido pedido al menos una vez.

   ```mysql
   SELECT p.nombre, p.precio
   FROM productos AS p
   JOIN detalles_pedidos AS dp ON p.id = dp.id_producto
   GROUP BY p.id, p.nombre, p.precio
   HAVING p.precio = (
       SELECT MAX(precio)
       FROM productos
       WHERE id IN (
           SELECT id_producto
           FROM detalles_pedidos
       )
   );
   ```

   



## Procedimientos Almacenados

### Crear un procedimiento almacenado para agregar un nuevo producto

**Enunciado:** Crea un procedimiento almacenado llamado `AgregarProducto` que reciba como parámetros el nombre, descripción y precio de un nuevo producto y lo inserte en la tabla `Productos` .

```mysql
DELIMITER $$

DROP PROCEDURE IF EXISTS AgregarProducto;
CREATE PROCEDURE AgregarProducto(
    IN nombre_producto VARCHAR(100),
    IN descripcion_producto TEXT,
    IN precio_producto DECIMAL(10, 2)
)
BEGIN
    INSERT INTO productos (nombre, descripcion, precio)
    VALUES (nombre_producto, descripcion_producto, precio_producto);
END $$

DELIMITER ;



CALL AgregarProducto('Nuevo Producto', 'Descripción del nuevo producto', 99.99);

```



### Crear un procedimiento almacenado para obtener los detalles de un pedido

**Enunciado:** Crea un procedimiento almacenado llamado `ObtenerDetallesPedido` que reciba como parámetro el ID del pedido y devuelva los detalles del pedido, incluyendo el nombre del producto, cantidad y precio unitario.

```mysql
DELIMITER $$

DROP PROCEDURE IF EXISTS ObtenerDetallesPedido;
CREATE PROCEDURE ObtenerDetallesPedido(
    IN pedido_id INT
)
BEGIN
	SELECT pr.nombre AS nombre_producto, dp.cantidad, dp.precio_unitario
    FROM detalles_pedidos AS dp
    JOIN productos AS pr ON dp.id_producto = pr.id
    WHERE dp.id_pedido = pedido_id
    LIMIT 1;
END $$

DELIMITER ;



CALL ObtenerDetallesPedido(1);

```



### Crear un procedimiento almacenado para actualizar el precio de un producto

**Enunciado:** Crea un procedimiento almacenado llamado `ActualizarPrecioProducto` que reciba como parámetros el ID del producto y el nuevo precio, y actualice el precio del producto en la tabla `Productos` .

```mysql
DELIMITER $$

DROP PROCEDURE IF EXISTS ActualizarPrecioProducto;
CREATE PROCEDURE ActualizarPrecioProducto(
    IN producto_id INT,
    IN nuevo_precio DECIMAL(10, 2)
)
BEGIN
    UPDATE productos
    SET precio = nuevo_precio
    WHERE id = producto_id;
END $$

DELIMITER ;



CALL ActualizarPrecioProducto(1, 99.99);

```



### Crear un procedimiento almacenado para eliminar un producto

**Enunciado:** Crea un procedimiento almacenado llamado `EliminarProducto` que reciba como parámetro el ID del producto y lo elimine de la tabla `Productos` .

```mysql
DELIMITER $$

DROP PROCEDURE IF EXISTS EliminarProducto;
CREATE PROCEDURE EliminarProducto(
    IN producto_id INT
)
BEGIN
    DELETE FROM productos
    WHERE id = producto_id;
END $$

DELIMITER ;



CALL EliminarProducto(1);

```



### Crear un procedimiento almacenado para obtener el total gastado por un usuario

**Enunciado:** Crea un procedimiento almacenado llamado `TotalGastadoPorUsuario` que reciba como parámetro el ID del usuario y devuelva el total gastado por ese usuario en todos sus pedidos.

```mysql
DELIMITER $$

DROP PROCEDURE IF EXISTS TotalGastadoPorUsuario;
CREATE PROCEDURE TotalGastadoPorUsuario(
    IN usuario_id INT
)
BEGIN
    SELECT SUM(p.total) AS total_gastado
    FROM pedidos p
    WHERE p.id_usuario = usuario_id;
END $$

DELIMITER ;



CALL TotalGastadoPorUsuario(1);

```

