/*Día de la semana y franja horaria con mayor cantidad de pedidos según la
localidad y categoría del local, para cada mes de cada año.*/


WITH CTE AS (
    SELECT
        YEAR(ped.PEDIDO_FECHA) AS Anio,
        MONTH(ped.PEDIDO_FECHA) AS Mes,
        l.LOCAL_LOCALIDAD AS Localidad,
        l.LOCAL_TIPO AS Categoria,
        DATEPART(WEEKDAY, ped.PEDIDO_FECHA) AS DiaSemana,
        CONCAT(
            RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) AS VARCHAR(2)), 2), ':00 - ', 
            RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) + 2 AS VARCHAR(2)), 2), ':00'
        ) AS FranjaHoraria,
        COUNT(*) AS CantidadPedidos,
        ROW_NUMBER() OVER (PARTITION BY YEAR(ped.PEDIDO_FECHA), MONTH(ped.PEDIDO_FECHA), l.LOCAL_LOCALIDAD, l.LOCAL_TIPO 
                           ORDER BY COUNT(*) DESC) AS RowNum
    FROM CAFE61.PEDIDO ped
    LEFT JOIN CAFE61.LOCAL l ON l.LOCAL_CODIGO = ped.PEDIDO_LOCAL
    GROUP BY YEAR(ped.PEDIDO_FECHA), MONTH(ped.PEDIDO_FECHA), l.LOCAL_LOCALIDAD, l.LOCAL_TIPO, DATEPART(WEEKDAY, ped.PEDIDO_FECHA),
             CONCAT(
                RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) AS VARCHAR(2)), 2), ':00 - ', 
                RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) + 2 AS VARCHAR(2)), 2), ':00'
            )
)
SELECT Anio, Mes, Localidad, Categoria, DiaSemana, FranjaHoraria, CantidadPedidos, RowNum
FROM CTE
WHERE RowNum = 1
ORDER BY Localidad


	  
