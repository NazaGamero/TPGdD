CREATE PROCEDURE BI_RECLAMO_CREAR
AS
SELECT * 
INTO CAFE61.BI_RECLAMO
FROM CAFE61.RECLAMO
GO

--PK BI_RECLAMO
ALTER TABLE CAFE61.BI_RECLAMO
ADD CONSTRAINT PK_BI_RECLAMO_NUMERO
PRIMARY KEY (RECLAMO_NUMERO);
GO

--Col Tiempo
ALTER TABLE CAFE61.BI_RECLAMO
ADD RECLAMO_TIEMPO INT;
GO

--Agrego datos a Col TIEMPO
UPDATE CAFE61.BI_RECLAMO
SET RECLAMO_TIEMPO = t.tiempo_codigo
FROM CAFE61.BI_RECLAMO r
	INNER JOIN  CAFE61.BI_TIEMPO t 
		ON t.tiempo_anio = YEAR(r.RECLAMO_FECHA)
		AND t.tiempo_mes = MONTH(r.RECLAMO_FECHA)
		AND t.tiempo_dia = DATEPART(WEEKDAY, r.RECLAMO_FECHA)
		AND t.tiempo_franjahoraria = CONCAT(
            RIGHT('00' + CAST(DATEPART(HOUR, r.RECLAMO_FECHA) AS VARCHAR(2)), 2), ':00 - ', 
            RIGHT('00' + CAST(DATEPART(HOUR, r.RECLAMO_FECHA) + 2 AS VARCHAR(2)), 2), ':00'
        )
GO

--FK a TIEMPO
ALTER TABLE CAFE61.BI_RECLAMO
ADD CONSTRAINT FK_BI_RECLAMO_TIEMPO
FOREIGN KEY (RECLAMO_TIEMPO) REFERENCES CAFE61.BI_TIEMPO (tiempo_codigo);
GO

-- Col RangoEtarioOperador
ALTER TABLE CAFE61.BI_RECLAMO
ADD RECLAMO_RANGO_ETARIO_OPERADOR INT;
GO

-- Agrego datos a Col RangoEtarioOperador
UPDATE CAFE61.BI_RECLAMO
SET RECLAMO_RANGO_ETARIO_OPERADOR = e.RANGOETARIO_CODIGO
FROM CAFE61.BI_RECLAMO r
	INNER JOIN CAFE61.OPERADOR_RECLAMO o ON r.RECLAMO_OPERADOR = o.OPERADOR_CODIGO
	INNER JOIN CAFE61.BI_RANGOETARIO e ON DATEDIFF(year, o.OPERADOR_RECLAMO_FECHA_NAC, GETDATE()) BETWEEN e.RANGOETARIO_DESDE AND e.RANGOETARIO_HASTA;
GO

-- FK a RangoEtarioOperador
ALTER TABLE CAFE61.BI_RECLAMO
ADD CONSTRAINT FK_BI_RECLAMO_RANGO_ETARIO_OPERADOR
FOREIGN KEY (RECLAMO_RANGO_ETARIO_OPERADOR) REFERENCES CAFE61.BI_RANGOETARIO (RANGOETARIO_CODIGO);

-- FK a Tipo Reclamo
ALTER TABLE CAFE61.BI_RECLAMO
ADD CONSTRAINT FK_BI_RECLAMO_TIPO
FOREIGN KEY (RECLAMO_TIPO) REFERENCES CAFE61.BI_TIPO_RECLAMO (TIPO_RECLAMO_CODIGO);

-- FK a PEDIDO 
ALTER TABLE CAFE61.BI_RECLAMO
ADD CONSTRAINT FK_BI_RECLAMO_PEDIDO_NUMERO
FOREIGN KEY (RECLAMO_PEDIDO_NUMERO) REFERENCES CAFE61.BI_PEDIDO (PEDIDO_NUMERO);