
DROP PROCEDURE LOS_QUE_VAN_A_APROBAR.GenerarPasaje
create procedure LOS_QUE_VAN_A_APROBAR.GenerarPasaje(@IdCliente int, @IdViaje int, @TipoServicio nvarchar(255),@NroPiso int, @NroCabina int, @Fecha_Salida datetime2(3), @Fecha_Actual datetime2(3))
AS
BEGIN
	
	DECLARE @IdCrucero nvarchar(50)

	set @IdCrucero = (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = @IdViaje)
	
	IF EXISTS (select 1 from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero 
				WHERE IdCrucero = @IdCrucero AND TipoServicio = @TipoServicio AND NroPiso = @NroPiso AND @NroCabina = @NroCabina)
		BEGIN
			INSERT INTO LOS_QUE_VAN_A_APROBAR.Pasaje(IdCliente, IdViaje, NroPiso, NroCabina, Fecha_Salida, Fecha_Pago)
			values(@IdCliente, @IdViaje, @NroPiso, @NroCabina, convert(datetime2(3),@Fecha_Salida),convert(datetime2(3),@Fecha_Actual))

			UPDATE LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			SET Estado = 'Ocupado'
			WHERE IdCrucero = @IdCrucero AND TipoServicio = @TipoServicio AND NroPiso = @NroPiso AND NroCabina = @NroCabina AND Fecha_Salida = @Fecha_Salida
		END
END
GO

drop procedure LOS_QUE_VAN_A_APROBAR.generarReserva
create procedure LOS_QUE_VAN_A_APROBAR.GenerarReserva(@IdCliente int, @IdViaje int, @TipoServicio nvarchar(255),@NroPiso int, @NroCabina int, @Fecha_Salida datetime2(3), @Fecha_Actual datetime2(3))
AS
BEGIN
	
	DECLARE @IdCrucero nvarchar(50)

	set @IdCrucero = (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = @IdViaje)
	IF EXISTS (select 1 from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero 
				WHERE IdCrucero = @IdCrucero AND TipoServicio = @TipoServicio AND NroPiso = @NroPiso AND @NroCabina = @NroCabina)
		BEGIN
			INSERT INTO LOS_QUE_VAN_A_APROBAR.Reserva(IdCliente, IdViaje, NroPiso, NroCabina, Fecha_Salida, Fecha_Reserva)
			values(@IdCliente, @IdViaje, @NroPiso, @NroCabina, convert(datetime2(3),@Fecha_Salida),convert(datetime2(3),@Fecha_Actual))

			set @IdCrucero = (select top 1 IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = @IdViaje)

			UPDATE LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			SET Estado = 'Ocupado'
			WHERE IdCrucero = @IdCrucero AND TipoServicio = @TipoServicio AND NroPiso = @NroPiso AND NroCabina = @NroCabina AND Fecha_Salida = @Fecha_Salida
		END
END
GO


CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.IngresarCliente(@Nombre nvarchar(255), @Apellido nvarchar(255), @DNI decimal(18,0), @Direccion nvarchar(255), @Telefono int, @Mail nvarchar(255), @FechaNacimiento datetime2(3))
AS
BEGIN
	insert into LOS_QUE_VAN_A_APROBAR.Cliente(Nombre, Apellido, DNI, Direccion, Telefono, Mail, FechaNacimiento)
	values(@Nombre, @Apellido, @DNI, @Direccion, @Telefono, @Mail, @FechaNacimiento)
END
GO



DROP FUNCTION LOS_QUE_VAN_A_APROBAR.ListarViajes

CREATE FUNCTION LOS_QUE_VAN_A_APROBAR.ListarViajes(@Fecha_Salida datetime2(3), @Puerto_Salida nvarchar(255), @Puerto_Llegada nvarchar(255))
RETURNS TABLE
AS
RETURN
	SELECT v.IdViaje, v.IdRecorrido from LOS_QUE_VAN_A_APROBAR.Viaje v
	WHERE Fecha_Salida = @Fecha_Salida 
	AND @Puerto_Salida IN (select Puerto_Salida from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
							JOIN LOS_QUE_VAN_A_APROBAR.Tramo t ON (r.CodigoTramo = t.IdTramo)
							where r.CodigoRecorrido =  v.IdRecorrido)
	AND @Puerto_Llegada IN (SELECT Puerto_Llegada from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
							JOIN LOS_QUE_VAN_A_APROBAR.Tramo t ON (r.CodigoTramo = t.IdTramo)
							where r.CodigoRecorrido = V.IdRecorrido)







