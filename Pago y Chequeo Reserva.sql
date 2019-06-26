

drop procedure LOS_QUE_VAN_A_APROBAR.pagarReserva
CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.PagarReserva(@IdReserva int, @Fecha_Actual datetime2(3))
AS
BEGIN

DECLARE @IdCliente int
DECLARE @IdViaje int
DECLARE @NroPiso int
DECLARE @NroCabina int
DECLARE @Fecha_Salida datetime2(3)


IF EXISTS (SELECT 1 FROM LOS_QUE_VAN_A_APROBAR.Reserva WHERE IdReserva = @IdReserva AND Estado = 'Disponible')
	BEGIN

		select @IdCliente = IdCliente, @IdViaje = IdViaje, @NroPiso = NroPiso, @NroCabina = NroCabina, @Fecha_Salida = Fecha_Salida
		from LOS_QUE_VAN_A_APROBAR.Reserva WHERE IdReserva = @IdReserva

		update LOS_QUE_VAN_A_APROBAR.Reserva
		set Estado = 'Expirada'
		WHERE IdReserva = @IdReserva

		insert into LOS_QUE_VAN_A_APROBAR.Pasaje(IdCliente, IdViaje, NroPiso, NroCabina, Fecha_Salida, Fecha_Pago)
		VALUES(@IdCliente, @IdViaje, @NroPiso, @NroCabina, @Fecha_Salida, @Fecha_Actual)

		
	END
END
GO

--exec LOS_QUE_VAN_A_APROBAR.PagarReserva 491265, '2019-10-02'

DROP PROCEDURE LOS_QUE_VAN_A_APROBAR.ChequearReservas
CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.ChequearReservas(@Fecha_Actual datetime2(3))
AS
BEGIN
DECLARE @IdReserva int
DECLARE @IdCliente int
DECLARE @IdViaje int
DECLARE @NroPiso int
DECLARE @NroCabina int
DECLARE @Fecha_Salida datetime2(3)
DECLARE @Fecha_Reserva datetime2(3)
DECLARE @IdCrucero nvarchar(50)

DECLARE cur CURSOR FOR
 SELECT IdReserva, IdCliente, IdViaje, NroPiso, NroCabina, Fecha_Salida, Fecha_Reserva
 FROM LOS_QUE_VAN_A_APROBAR.Reserva
 WHERE convert(datetime2(3),Fecha_Salida) > convert(datetime2(3),@Fecha_Actual) AND Estado = 'Disponible'
 
OPEN cur

FETCH NEXT FROM cur into @IdReserva, @IdCliente, @IdViaje, @NroPiso, @NroCabina, @Fecha_Salida, @Fecha_Reserva

WHILE @@FETCH_STATUS = 0
BEGIN
IF (DATEDIFF(day, convert(datetime2(3),@Fecha_Reserva), convert(datetime2(3),@Fecha_Actual)) > 3)
	BEGIN
	SET @IdCrucero = (SELECT TOP 1 IdCrucero FROM LOS_QUE_VAN_A_APROBAR.Viaje where IdViaje = @IdViaje)

	update LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
	SET Estado = 'Disponible'
	WHERE IdCrucero = @IdCrucero AND NroPiso = @NroPiso AND NroCabina = @NroCabina AND Fecha_Salida = @Fecha_Salida
	
	update LOS_QUE_VAN_A_APROBAR.Reserva
		set Estado = 'Expirada'
		WHERE IdReserva = @IdReserva
	END
	FETCH NEXT FROM cur into @IdReserva, @IdCliente, @IdViaje, @NroPiso, @NroCabina, @Fecha_Salida, @Fecha_Reserva
END
	close cur
	DEALLOCATE cur
END





/*
insert into 


exec LOS_QUE_VAN_A_APROBAR.ChequearReservas '2020-10-10'


SELECT * FROM LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = 2042

select * from LOS_QUE_VAN_A_APROBAR.Reserva
order by idreserva desc

select * from LOS_QUE_VAN_A_APROBAR.Pasaje
order by idpasaje desc
DELETE FROM LOS_QUE_VAN_A_APROBAR.Reserva
WHERE IdReserva < 245629


INSERT INTO LOS_QUE_VAN_A_APROBAR.C


select * from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero


DELETE  FROM LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
*/