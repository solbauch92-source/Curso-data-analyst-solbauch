--Consulta 1 — Resumen ejecutivo mensual --
use TechStore_Clase4
SELECT
    MONTH(fecha_venta)AS mes,
    SUM(cantidad * precio_unitario)  AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
   AVG(cantidad * precio_unitario) AS ticket_promedio    
   FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

--Consulta 2 — Ranking de productos--
SELECT TOP 5
    id_producto,
    SUM(cantidad)                    AS unidades_vendidas,
    SUM(cantidad * precio_unitario)  AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- Consulta 3 — Clientes recurrentes--
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)  AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

--Consulta 4  Productos por encima/por debajo del promedio--
WITH totales_por_producto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    id_producto,
    total_facturado,
    (SELECT AVG(total_facturado) FROM totales_por_producto) AS promedio_por_producto,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM totales_por_producto)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM totales_por_producto
ORDER BY total_facturado DESC;

-- COMENTARIOS / HALLAZGOS--
--1  En Mayo se registro el ingreso mas alto del año, se facturaron $3450 en 6 pedidos, con un ticket
--    promedio de $ 575 por pedido, sin embargo el ticket promedio mas grande fue en Febrero con $966.66
-- 2. El producto 1 lidera la facturación con $11950, lo que equivale al 75% del total.
-- 3. El 80% de los clientes realizaron más de un pedido. El cliente 101
--    es el más valioso, con 6 pedidos y $4360 gastados.
-- 4. Solo 1 de 6 productos quedaron por encima del promedio
--           de facturación por producto $2367 