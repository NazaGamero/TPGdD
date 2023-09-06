/*Cantidad de reclamos mensuales recibidos por cada local en función del
día de la semana y rango horario.*/

CREATE VIEW CAFE61.BI_VIEW_CANT_RECLAMO_LOCAL
AS
SELECT	
	l.LOCAL_CODIGO Local_Codigo, --- TRAJE AL LOCAL AL RECLAMO, OTRA POSIBLE SOLUCION ERA TRAERLO ATRAVEZ DEL PEDIDO// Definimos en traer lo de Atravez de pedido
	l.LOCAL_NOMBRE Local_Categoria,
	t.tiempo_mes Mes,
	t.tiempo_dia DiaSemana,
	t.tiempo_franjahoraria FranjaHoraria,
	COUNT(*) CantidadReclamo
FROM CAFE61.BI_RECLAMO r
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = r.RECLAMO_TIEMPO
	JOIN CAFE61.BI_PEDIDO p ON p.PEDIDO_NUMERO = r.RECLAMO_PEDIDO_NUMERO
	JOIN CAFE61.BI_LOCAL l ON l.LOCAL_CODIGO = p.PEDIDO_LOCAL
GROUP BY 
	l.LOCAL_CODIGO,
	l.LOCAL_NOMBRE,
	t.tiempo_mes,
	t.tiempo_dia,
	t.tiempo_franjahoraria

/*Tiempo promedio de resolución de reclamos mensual según cada tipo de
reclamo y rango etario de los operadores.
El tiempo de resolución debe calcularse en minutos y representa la
diferencia entre la fecha/hora en que se realizó el reclamo y la fecha/hora
que se resolvió.*/
CREATE VIEW CAFE61.BI_VIEW_TIEMPO_PROM_SOLUCION_RECLAMO
AS
SELECT	
	t.TIPO_RECLAMO_CODIGO TipoCod,
	t.TIPO_RECLAMO_DESCRIPCION Tipo,
	e.RANGOETARIO_CODIGO RangoEtarioCod,
	e.RANGOETARIO_DESDE Desde,
	e.RANGOETARIO_HASTA Hasta,
	AVG(DATEDIFF(minute, r.RECLAMO_FECHA, r.RECLAMO_FECHA_SOLUCION))TiempoResolucionPromedioMinutos
FROM CAFE61.BI_RECLAMO r
	JOIN CAFE61.BI_TIPO_RECLAMO t ON t.TIPO_RECLAMO_CODIGO = r.RECLAMO_TIPO
	JOIN CAFE61.BI_RANGOETARIO e ON e.RANGOETARIO_CODIGO = r.RECLAMO_RANGO_ETARIO_OPERADOR
GROUP BY 
	t.TIPO_RECLAMO_CODIGO,
	t.TIPO_RECLAMO_DESCRIPCION,
	e.RANGOETARIO_CODIGO,
	e.RANGOETARIO_DESDE,
	e.RANGOETARIO_HASTA

/*Monto mensual generado en cupones a partir de reclamos.*/
CREATE VIEW CAFE61.BI_VIEW_MONTO_RECLAMO_CUPONES
AS
SELECT	
	t.tiempo_mes Mes,
	ISNULL(SUM(p.PEDIDO_TOTAL_CUPONES),0) --- TRAJE AL MONTO ATRAVEZ DEL PEDIDO, OTRA POSIBLE SOLUCION ERA TRAERLO AL RECLAMO COMO EL LOCAL
FROM CAFE61.BI_RECLAMO r
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = r.RECLAMO_TIEMPO
	JOIN CAFE61.BI_PEDIDO p ON p.PEDIDO_NUMERO = r.RECLAMO_PEDIDO_NUMERO
GROUP BY 
	t.tiempo_mes
 
