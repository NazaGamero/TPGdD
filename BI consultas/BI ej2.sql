/*Monto total no cobrado por cada local en función de los pedidos
cancelados según el día de la semana y la franja horaria (cuentan como
pedidos cancelados tanto los que cancela el usuario como el local).*/

SELECT
	l.LOCAL_CODIGO,
	l.LOCAL_NOMBRE,
    DATEPART(WEEKDAY, ped.PEDIDO_FECHA) AS DiaSemana,
    CONCAT(
		RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) AS VARCHAR(2)), 2), ':00 - ', 
        RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) + 2 AS VARCHAR(2)), 2), ':00'
        ) AS FranjaHoraria,
    ISNULL(SUM(ped.PEDIDO_TOTAL_SERVICIO),0) AS MontoNoCobrado
FROM CAFE61.PEDIDO ped
	LEFT JOIN CAFE61.LOCAL l ON l.LOCAL_CODIGO = ped.PEDIDO_LOCAL
WHERE ped.PEDIDO_ESTADO = 2
GROUP BY DATEPART(WEEKDAY, ped.PEDIDO_FECHA),l.LOCAL_CODIGO,l.LOCAL_NOMBRE,
             CONCAT(
                RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) AS VARCHAR(2)), 2), ':00 - ', 
                RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) + 2 AS VARCHAR(2)), 2), ':00'
            )
ORDER BY l.LOCAL_NOMBRE

