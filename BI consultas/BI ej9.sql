/*
Cantidad de reclamos mensuales recibidos por cada local en función del
día de la semana y rango horario.*/-- Revisar si tienen que aparecer todas las horas y dias y meses o solo las que tienen datosSELECT 
	l.LOCAL_CODIGO CodLocal,
	l.LOCAL_NOMBRE NombreLocal,
	MONTH(ped.PEDIDO_FECHA) Mes,
	DATEPART(WEEKDAY, ped.PEDIDO_FECHA) AS DiaSemana,
    CONCAT(
		RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) AS VARCHAR(2)), 2), ':00 - ', 
        RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) + 2 AS VARCHAR(2)), 2), ':00'
        ) AS FranjaHoraria,
	ISNULL(COUNT(r.RECLAMO_NUMERO),0) CantidadReclamos
FROM CAFE61.LOCAL l
	LEFT JOIN CAFE61.PEDIDO ped ON ped.PEDIDO_LOCAL = l.LOCAL_CODIGO
	LEFT JOIN CAFE61.RECLAMO r ON r.RECLAMO_PEDIDO_NUMERO = ped.PEDIDO_NUMERO
GROUP BY 
	l.LOCAL_CODIGO,l.LOCAL_NOMBRE,MONTH(ped.PEDIDO_FECHA),DATEPART(WEEKDAY, ped.PEDIDO_FECHA),
    CONCAT(
		RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) AS VARCHAR(2)), 2), ':00 - ', 
        RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) + 2 AS VARCHAR(2)), 2), ':00'
        )
ORDER BY l.LOCAL_CODIGO,MONTH(ped.PEDIDO_FECHA),DATEPART(WEEKDAY, ped.PEDIDO_FECHA),
    CONCAT(
		RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) AS VARCHAR(2)), 2), ':00 - ', 
        RIGHT('00' + CAST(DATEPART(HOUR, ped.PEDIDO_FECHA) + 2 AS VARCHAR(2)), 2), ':00'
        )
