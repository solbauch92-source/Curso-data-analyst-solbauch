USE TechStore_Clase4;
IF COL_LENGTH('clientes', 'region') IS NULL
    ALTER TABLE clientes ADD region VARCHAR(50);

IF COL_LENGTH('productos', 'categoria') IS NULL
    ALTER TABLE productos ADD categoria VARCHAR(50);

UPDATE clientes SET region = 'Norte'  WHERE id_cliente % 3 = 1;
UPDATE clientes SET region = 'Centro' WHERE id_cliente % 3 = 2;
UPDATE clientes SET region = 'Sur'    WHERE id_cliente % 3 = 0;

UPDATE productos SET categoria = 'Computación' WHERE id_producto % 3 = 1;
UPDATE productos SET categoria = 'Accesorios'  WHERE id_producto % 3 = 2;
UPDATE productos SET categoria = 'Audio'       WHERE id_producto % 3 = 0;
GO

-- Consulta 1: Vista base del proyecto (INNER JOIN)
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre                           AS cliente,
    c.region,
    p.nombre_producto                  AS producto,
    p.categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario     AS total_venta
FROM ventas AS v
INNER JOIN clientes  AS c ON v.id_cliente  = c.id_cliente
INNER JOIN productos AS p ON v.id_producto = p.id_producto
ORDER BY v.fecha_venta;
GO

-- =====================================================================
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- =====================================================================
USE TechStore_Clase4;
GO

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL
ORDER BY c.fecha_registro;

-- =====================================================================
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- =====================================================================
USE TechStore_Clase4;
GO

SELECT
    p.nombre_producto,
    p.categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas AS v ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL
ORDER BY p.precio DESC;
GO
-- =====================================================================
-- Consulta 4: Consolidado por período (UNION ALL)
USE TechStore_Clase4;
GO

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Primera quincena' AS canal
    FROM ventas
    WHERE DAY(fecha_venta) <= 15

    UNION ALL

    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Segunda quincena' AS canal
    FROM ventas
    WHERE DAY(fecha_venta) > 15
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;
GO
