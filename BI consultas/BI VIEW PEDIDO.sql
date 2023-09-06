/*Día de la semana y franja horaria con mayor cantidad de pedidos según la
localidad y categoría del local, para cada mes de cada año*/


CREATE VIEW CAFE61.BI_VIEW_CANT_PEDIDO
AS
WITH CTE AS (
SELECT	
	t.tiempo_anio Anio,
	t.tiempo_mes Mes,
	l.LOCAL_LOCALIDAD Localidad,
	l.LOCAL_TIPO Categoria,
	t.tiempo_dia DiaSemana,
	t.tiempo_franjahoraria FranjaHoraria,
	COUNT(*) as CantidadPedidos,
	ROW_NUMBER() OVER (PARTITION BY t.tiempo_anio, t.tiempo_mes, l.LOCAL_LOCALIDAD, l.LOCAL_TIPO 
                           ORDER BY COUNT(*) DESC) AS RowNum

FROM CAFE61.BI_PEDIDO p
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = p.PEDIDO_TIEMPO
	JOIN CAFE61.BI_LOCAL l ON l.LOCAL_CODIGO = p.PEDIDO_LOCAL
GROUP BY 
	t.tiempo_anio,
	t.tiempo_mes,
	t.tiempo_dia,
	t.tiempo_franjahoraria,
	l.LOCAL_LOCALIDAD,
	l.LOCAL_TIPO
)
SELECT Anio, Mes, Localidad, Categoria, DiaSemana, FranjaHoraria, CantidadPedidos, RowNum
FROM CTE
WHERE RowNum = 1

SELECT * FROM BI_VIEW_CANT_PEDIDO

/*Monto total no cobrado por cada local en función de los pedidos
cancelados según el día de la semana y la franja horaria (cuentan como
pedidos cancelados tanto los que cancela el usuario como el local).
*/

CREATE VIEW CAFE61.BI_VIEW_TOTAL_NO_COBRADO
AS
SELECT	
	l.LOCAL_CODIGO Local_Codigo,
	l.LOCAL_NOMBRE Local_Categoria,
	t.tiempo_dia DiaSemana,
	t.tiempo_franjahoraria FranjaHoraria,
	ISNULL(SUM(p.PEDIDO_TOTAL_SERVICIO),0) AS MontoNoCobrado
FROM CAFE61.BI_PEDIDO p
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = p.PEDIDO_TIEMPO
	JOIN CAFE61.BI_LOCAL l ON l.LOCAL_CODIGO = p.PEDIDO_LOCAL
WHERE p.PEDIDO_ESTADO = 2
GROUP BY 
	l.LOCAL_CODIGO,
	l.LOCAL_NOMBRE,
	t.tiempo_dia,
	t.tiempo_franjahoraria

/*Valor promedio mensual que tienen los envíos de pedidos en cada
localidad.
*/
CREATE VIEW CAFE61.BI_VIEW_PROM_ENVIO_PEDIDO
AS
SELECT
	t.tiempo_mes Mes,
	l.LOCAL_LOCALIDAD Localidad,
	AVG(e.ENVIO_PEDIDO_PRECIO_ENVIO) PromedioValorEnvio
FROM CAFE61.BI_PEDIDO p
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = p.PEDIDO_TIEMPO
	JOIN CAFE61.BI_ENVIO_PEDIDO e ON e.ENVIO_PEDIDO_CODIGO = p.PEDIDO_ENVIO_PEDIDO
	JOIN CAFE61.BI_LOCAL l ON l.LOCAL_CODIGO = p.PEDIDO_LOCAL
GROUP BY 
	t.tiempo_mes,
	l.LOCAL_LOCALIDAD


/*Monto total de los cupones utilizados por mes en función del rango etario
de los usuarios*/
CREATE VIEW CAFE61.BI_VIEW_TOTAL_CUPONES
AS
SELECT
	r.RANGOETARIO_CODIGO RangoEtario,
	r.RANGOETARIO_DESDE Desde,
	r.RANGOETARIO_HASTA Hasta,
	t.tiempo_mes Mes,
	ISNULL(SUM(p.PEDIDO_TOTAL_CUPONES),0) MontoTotalCupones
FROM CAFE61.BI_PEDIDO p
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = p.PEDIDO_TIEMPO
	JOIN CAFE61.BI_RANGOETARIO r ON r.RANGOETARIO_CODIGO = p.PEDIDO_RANGO_ETARIO 
GROUP BY 
	r.RANGOETARIO_CODIGO,
	r.RANGOETARIO_DESDE,
	r.RANGOETARIO_HASTA,
	t.tiempo_mes


/*Promedio de calificación mensual por local.*/
CREATE VIEW CAFE61.BI_VIEW_PROM_CALIFICACION
AS
SELECT 
	l.LOCAL_CODIGO CodLocal,
	l.LOCAL_NOMBRE NombreLocal,
	t.tiempo_mes Mes,
	CAST(ISNULL(AVG(p.PEDIDO_CALIFICACION), 0) AS decimal(10,1)) PromedioCalificacion
FROM CAFE61.BI_PEDIDO p
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = p.PEDIDO_TIEMPO
	JOIN CAFE61.BI_LOCAL l ON l.LOCAL_CODIGO = p.PEDIDO_LOCAL
GROUP BY 
	l.LOCAL_CODIGO,
	l.LOCAL_NOMBRE,
	t.tiempo_mes

