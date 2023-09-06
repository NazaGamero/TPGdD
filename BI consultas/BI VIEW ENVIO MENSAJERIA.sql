/* Promedio mensual del valor asegurado (valor declarado por el usuario) de
los paquetes enviados a trav�s del servicio de mensajer�a en funci�n del
tipo de paquete.*/
CREATE VIEW CAFE61.BI_VIEW_PROM_VALOR_ASEGURADO
AS
SELECT 
	t.tiempo_mes Mes,
	tp.PAQUETE_TIPO_CODIGO TipoPaqueteCod,
	tp.PAQUETE_TIPO_PRECIO TipoPaquete,
	AVG(e.ENVIO_MENSAJERIA_PRECIO_SEGURO) PromedioValorAsegurado
FROM CAFE61.BI_ENVIO_MENSAJERIA e
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = e.ENVIO_MENSAJERIA_TIEMPO
	JOIN CAFE61.BI_PAQUETE p ON p.PAQUETE_CODIGO = e.ENVIO_MENSAJERIA_PAQUETE
	JOIN CAFE61.BI_TIPO_PAQUETE tp ON p.PAQUETE_TIPO = tp.PAQUETE_TIPO_CODIGO
GROUP BY 
	t.tiempo_mes,
	tp.PAQUETE_TIPO_CODIGO,
	tp.PAQUETE_TIPO_PRECIO

/*Desv�o promedio en tiempo de entrega seg�n el tipo de movilidad, el d�a
de la semana y la franja horaria.
El desv�o debe calcularse en minutos y representa la diferencia entre la
fecha/hora en que se realiz� el pedido y la fecha/hora que se entreg� en
comparaci�n con los minutos de tiempo estimados.
Este indicador debe tener en cuenta todos los env�os, es decir, sumar tanto
los env�os de pedidos como los de mensajer�a.*/
CREATE VIEW CAFE61.BI_VIEW_DESVIO_PROM_TIEMPO_ENTREGA
AS
WITH CTE AS (
SELECT 
	t.tiempo_dia Dia,
	t.tiempo_franjahoraria FranjaHoraria,
	tm.TIPO_MOVILIDAD_CODIGO TipoMovilidadCod,
	tm.TIPO_MOVILIDAD_DESCRIPCION TipoMovilidad,
	DATEDIFF(minute, e.ENVIO_MENSAJERIA_FECHA_ESTIMADO, e.ENVIO_MENSAJERIA_FECHA_ENTREGA) MinutosDemora
FROM CAFE61.BI_ENVIO_MENSAJERIA e
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = e.ENVIO_MENSAJERIA_TIEMPO
	JOIN CAFE61.BI_REPARTIDOR r ON r.REPARTIDOR_CODIGO = e.ENVIO_MENSAJERIA_REPARTIDOR
	JOIN CAFE61.BI_TIPO_MOVILIDAD tm ON r.REPARTIDOR_TIPO_MOVILIDAD = tm.TIPO_MOVILIDAD_CODIGO
GROUP BY 
	t.tiempo_dia,
	t.tiempo_franjahoraria,
	tm.TIPO_MOVILIDAD_CODIGO,
	tm.TIPO_MOVILIDAD_DESCRIPCION,
	DATEDIFF(minute, e.ENVIO_MENSAJERIA_FECHA_ESTIMADO, e.ENVIO_MENSAJERIA_FECHA_ENTREGA)
UNION
	SELECT 
	t.tiempo_dia Dia,
	t.tiempo_franjahoraria FranjaHoraria,
	tm.TIPO_MOVILIDAD_CODIGO TipoMovilidadCod,
	tm.TIPO_MOVILIDAD_DESCRIPCION TipoMovilidad,
	DATEDIFF(minute, DATEADD(minute, e.ENVIO_PEDIDO_TIEMPO_ESTIMADO_ENTREGA, p.PEDIDO_FECHA), e.ENVIO_PEDIDO_FECHA_ENTREGA) MinutosDemora
FROM CAFE61.BI_PEDIDO p
	JOIN CAFE61.BI_TIEMPO t ON t.tiempo_codigo = p.PEDIDO_TIEMPO
	JOIN CAFE61.BI_ENVIO_PEDIDO e ON p.PEDIDO_ENVIO_PEDIDO = e.ENVIO_PEDIDO_CODIGO
	JOIN CAFE61.BI_REPARTIDOR r ON r.REPARTIDOR_CODIGO = e.ENVIO_PEDIDO_REPARTIDOR
	JOIN CAFE61.BI_TIPO_MOVILIDAD tm ON r.REPARTIDOR_TIPO_MOVILIDAD = tm.TIPO_MOVILIDAD_CODIGO
GROUP BY 
	t.tiempo_dia,
	t.tiempo_franjahoraria,
	tm.TIPO_MOVILIDAD_CODIGO,
	tm.TIPO_MOVILIDAD_DESCRIPCION,
	DATEDIFF(minute, DATEADD(minute, e.ENVIO_PEDIDO_TIEMPO_ESTIMADO_ENTREGA, p.PEDIDO_FECHA), e.ENVIO_PEDIDO_FECHA_ENTREGA)
)
SELECT Dia, FranjaHoraria, TipoMovilidadCod, TipoMovilidad, AVG(MinutosDemora) MinutosDemoraPromedio
FROM CTE
GROUP BY Dia, FranjaHoraria, TipoMovilidadCod, TipoMovilidad

/*Porcentaje de pedidos y mensajer�a entregados mensualmente seg�n el
rango etario de los repartidores y la localidad.
Este indicador se debe tener en cuenta y sumar tanto los env�os de pedidos
como los de mensajer�a.
El porcentaje se calcula en funci�n del total general de pedidos y env�os
mensuales entregados.*/