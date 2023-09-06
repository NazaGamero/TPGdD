CREATE PROCEDURE CAFE61.BI_ENVIO_MENSAJERIA_CREAR
AS
SELECT * 
INTO CAFE61.BI_ENVIO_MENSAJERIA
FROM CAFE61.ENVIO_MENSAJERIA
GO

--PK BI_PEDIDO
ALTER TABLE cafe61.BI_ENVIO_MENSAJERIA
ADD CONSTRAINT PK_BI_ENVIO_MENSAJERIA_NUMERO
PRIMARY KEY (ENVIO_MENSAJERIA_NUMERO);
GO


--Col Tiempo
ALTER TABLE CAFE61.BI_ENVIO_MENSAJERIA
ADD ENVIO_MENSAJERIA_TIEMPO INT;
GO

--Agrego datos a Col TIEMPO
UPDATE CAFE61.BI_ENVIO_MENSAJERIA
SET ENVIO_MENSAJERIA_TIEMPO = t.tiempo_codigo
FROM CAFE61.BI_ENVIO_MENSAJERIA e
	INNER JOIN  CAFE61.BI_TIEMPO t 
		ON t.tiempo_anio = YEAR(e.ENVIO_MENSAJERIA_FECHA_PEDIDO)
		AND t.tiempo_mes = MONTH(e.ENVIO_MENSAJERIA_FECHA_PEDIDO)
		AND t.tiempo_dia = DATEPART(WEEKDAY, e.ENVIO_MENSAJERIA_FECHA_PEDIDO)
		AND t.tiempo_franjahoraria = CONCAT(
            RIGHT('00' + CAST(DATEPART(HOUR, e.ENVIO_MENSAJERIA_FECHA_PEDIDO) AS VARCHAR(2)), 2), ':00 - ', 
            RIGHT('00' + CAST(DATEPART(HOUR, e.ENVIO_MENSAJERIA_FECHA_PEDIDO) + 2 AS VARCHAR(2)), 2), ':00'
        )
GO

--FK a TIEMPO
ALTER TABLE cafe61.BI_ENVIO_MENSAJERIA
ADD CONSTRAINT FK_BI_ENVIO_MENSAJERIA_TIEMPO
FOREIGN KEY (ENVIO_MENSAJERIA_TIEMPO) REFERENCES CAFE61.BI_TIEMPO (tiempo_codigo);
GO

--FK a Paquete
ALTER TABLE cafe61.BI_ENVIO_MENSAJERIA
ADD CONSTRAINT FK_BI_ENVIO_MENSAJERIA_PAQUETE
FOREIGN KEY (ENVIO_MENSAJERIA_PAQUETE) REFERENCES CAFE61.BI_PAQUETE (tiempo_codigo);
GO


-- Col RangoEtarioRepartidor
ALTER TABLE CAFE61.BI_ENVIO_MENSAJERIA
ADD ENVIO_MENSAJERIA_RANGO_ETARIO_REPARTIDOR INT;
GO

-- Agrego datos a Col RangoEtarioRepartidor
UPDATE CAFE61.BI_ENVIO_MENSAJERIA
SET ENVIO_MENSAJERIA_RANGO_ETARIO_REPARTIDOR = re.RANGOETARIO_CODIGO
FROM CAFE61.BI_ENVIO_MENSAJERIA e
	INNER JOIN CAFE61.REPARTIDOR r ON e.ENVIO_MENSAJERIA_REPARTIDOR = r.REPARTIDOR_CODIGO
	INNER JOIN CAFE61.BI_RANGOETARIO re ON DATEDIFF(year, r.REPARTIDOR_FECHA_NAC, GETDATE()) BETWEEN re.RANGOETARIO_DESDE AND re.RANGOETARIO_HASTA;
GO

-- FK a RangoEtarioRepartidor
ALTER TABLE CAFE61.BI_ENVIO_MENSAJERIA
ADD CONSTRAINT FK_BI_ENVIO_MENSAJERIA_RANGO_ETARIO_REPARTIDOR
FOREIGN KEY (ENVIO_MENSAJERIA_RANGO_ETARIO_REPARTIDOR) REFERENCES CAFE61.BI_RANGOETARIO (RANGOETARIO_CODIGO);

-- FK a Repartidor
ALTER TABLE CAFE61.BI_ENVIO_MENSAJERIA
ADD CONSTRAINT FK_BI_ENVIO_MENSAJERIA_REPARTIDOR
FOREIGN KEY (ENVIO_MENSAJERIA_REPARTIDOR) REFERENCES CAFE61.BI_REPARTIDOR (REPARTIDOR_CODIGO);
