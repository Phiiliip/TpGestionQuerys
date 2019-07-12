-- Rol

create function LOS_QUE_VAN_A_APROBAR.ObtenerNuevoRolInsertado()
returns int as
begin
return (select TOP(1) IdRol from LOS_QUE_VAN_A_APROBAR.Rol order by IdRol DESC)
end
GO








-------------------------------------- Validacion de admin------------------------------------------


create function LOS_QUE_VAN_A_APROBAR.ValidarAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
returns int as
begin
declare @Resultado tinyint
if  exists(select * 
from LOS_QUE_VAN_A_APROBAR.Administrador
where NombreUsuario = @Username and Contraseña = HASHBYTES('SHA2_256', @Password))
set @Resultado = 1
else
begin
set @Resultado = 0
end
return @Resultado
end
GO




--- Id de rol dado un usuario

create function LOS_QUE_VAN_A_APROBAR.IdDeRol(@Username NVARCHAR(100), @Password NVARCHAR(255))
returns int as
begin
declare @Resultado int
set @Resultado = (select top(1) IdRol from LOS_QUE_VAN_A_APROBAR.Administrador where NombreUsuario = @Username and Contraseña = HASHBYTES('SHA2_256',@Password))
return @Resultado
end
GO




select * from LOS_QUE_VAN_A_APROBAR.Viaje order by Fecha_Llegada DESC

---------------------------------- COMPRA Y RESERVA ----------------------------------------------

drop function LOS_QUE_VAN_A_APROBAR.ListarViajes
CREATE FUNCTION LOS_QUE_VAN_A_APROBAR.ListarViajes(@Fecha_Salida datetime2(3), @Puerto_Salida nvarchar(255), @Puerto_Llegada nvarchar(255))
RETURNS TABLE
AS
RETURN
	SELECT v.IdViaje as 'Numero De Viaje', v.IdCrucero as 'Identificador Crucero', v.Fecha_Salida as 'Fecha de salida', v.Fecha_Llegada as 'Fecha de llegada',
			(select count(*) from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			 where IdCrucero = v.IdCrucero AND TipoServicio = 'suite' AND cast(Fecha_Salida as date) = cast(@Fecha_Salida as date) AND Estado = 'Disponible')'Cantidad suites disponibles',
			 (select count(*) from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			 where IdCrucero = v.IdCrucero AND TipoServicio = 'Cabina Balcón' AND cast(Fecha_Salida as date) = cast(@Fecha_Salida as date) AND Estado = 'Disponible')'Cantidad Cabina Balcon disponibles',
			 (select count(*) from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			 where IdCrucero = v.IdCrucero AND TipoServicio = 'Cabina estandar' AND cast(Fecha_Salida as date) = cast(@Fecha_Salida as date) AND Estado = 'Disponible')'Cantidad Cabina estandar disponibles',
			 (select count(*) from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			 where IdCrucero = v.IdCrucero AND TipoServicio = 'Ejecutivo' AND cast(Fecha_Salida as date) = cast(@Fecha_Salida as date) AND Estado = 'Disponible')'Cantidad Ejecutivo disponibles',
			 (select count(*) from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			 where IdCrucero = v.IdCrucero AND TipoServicio = 'Cabina Exterior' AND cast(Fecha_Salida as date) = cast(@Fecha_Salida as date) AND Estado = 'Disponible')'Cantidad Cabina exterior disponibles'
    from LOS_QUE_VAN_A_APROBAR.Viaje v
	WHERE cast(Fecha_Salida as DATE) = cast(@Fecha_Salida as DATE) AND CAST(Fecha_Salida as date) > CAST((select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha) as date)
	AND @Puerto_Salida IN (select Puerto_Salida from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
							JOIN LOS_QUE_VAN_A_APROBAR.Tramo t ON (r.CodigoTramo = t.IdTramo)
							where r.CodigoRecorrido =  v.IdRecorrido)
	AND @Puerto_Llegada IN (SELECT Puerto_Llegada from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
							JOIN LOS_QUE_VAN_A_APROBAR.Tramo t ON (r.CodigoTramo = t.IdTramo)
							where r.CodigoRecorrido = V.IdRecorrido)
GO



create function LOS_QUE_VAN_A_APROBAR.InformacionReserva(@IdCliente int, @IdViaje int)
returns table as
return
select r.IdReserva,v.IdViaje, v.IdCrucero, r.NroCabina, r.NroPiso ,v.Fecha_Salida, v.Fecha_Llegada, v.CodigoRecorrido from LOS_QUE_VAN_A_APROBAR.Reserva r
join LOS_QUE_VAN_A_APROBAR.Viaje v on (v.IdViaje = r.IdViaje)
where IdCliente = @IdCliente and r.IdViaje = @IdViaje
GO




create function LOS_QUE_VAN_A_APROBAR.InformacionPasaje(@IdCliente int, @IdViaje int)
returns table as
return
select p.IdPasaje,v.IdViaje, v.IdCrucero, p.NroCabina, p.NroPiso, v.Fecha_Salida, v.Fecha_Llegada, v.CodigoRecorrido, p.Fecha_Pago from LOS_QUE_VAN_A_APROBAR.Pasaje p
join LOS_QUE_VAN_A_APROBAR.Viaje v on (v.IdViaje = p.IdViaje)
where p.IdCliente = @IdCliente and p.IdViaje = @IdViaje
GO

create function LOS_QUE_VAN_A_APROBAR.ValidarReserva(@IdReserva int)
returns int as
begin
declare @Resultado binary

if exists (select 1 from LOS_QUE_VAN_A_APROBAR.Reserva where IdReserva = @IdReserva and Estado = 'Disponible')
set @Resultado = 1
else
set @Resultado = 0

return @Resultado
end
GO


create function LOS_QUE_VAN_A_APROBAR.precioReserva(@IdReserva int)
returns decimal(18,2) as
begin

declare @Precio decimal(18,2)

set @Precio = (select PrecioTotal from LOS_QUE_VAN_A_APROBAR.Reserva r join LOS_QUE_VAN_A_APROBAR.Viaje v ON (r.IdViaje = v.IdViaje)
join LOS_QUE_VAN_A_APROBAR.Recorrido re ON (re.IdRecorrido = v.IdRecorrido)
where r.IdReserva = @IdReserva
)

return @Precio
END
GO


create function LOS_QUE_VAN_A_APROBAR.clienteSeleccionado(@DNI decimal(18,0), @Nombre nvarchar(255), @Apellido nvarchar(255), @Direccion nvarchar(255))
returns int as
begin

declare @idCliente int

set @idCliente= (select IdCliente from LOS_QUE_VAN_A_APROBAR.Cliente where DNI = @DNI AND Nombre = @Nombre and Apellido = @Apellido AND Direccion = @Direccion)

return @idCliente
end
go

-------------------------------------------- VIAJE --------------------------------------------

CREATE FUNCTION LOS_QUE_VAN_A_APROBAR.crucerosParaViaje(@Fecha_SalidaNueva datetime2(3), @Fecha_LlegadaNueva datetime2(3))
RETURNS TABLE
AS	
RETURN 
select * from LOS_QUE_VAN_A_APROBAR.Crucero
where IdCrucero not in
 (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje
  WHERE (convert(datetime2(3), Fecha_Salida) BETWEEN convert(datetime2(3), @Fecha_SalidaNueva) AND convert(datetime2(3), @Fecha_LlegadaNueva)) OR
   convert(datetime2(3), Fecha_Llegada) BETWEEN CONVERT(datetime2(3), @Fecha_SalidaNueva) AND convert(datetime2(3), @Fecha_LlegadaNueva)
   OR (convert(datetime2(3), @Fecha_SalidaNueva) > convert(datetime2(3),Fecha_Salida) AND convert(datetime2(3), @Fecha_LlegadaNueva) < convert(datetime2(3), Fecha_Llegada))
   )
GO


create function LOS_QUE_VAN_A_APROBAR.ClienteNoPuedeComprar(@IdCliente int, @FechaSalida DateTime2(3), @IdViaje int)
returns int
as
begin
declare @Retorno int
if exists (select 1 from LOS_QUE_VAN_A_APROBAR.Pasaje p join LOS_QUE_VAN_A_APROBAR.Viaje v on v.IdViaje = p.IdViaje where p.IdCliente = @IdCliente and v.IdViaje != @IdViaje and @FechaSalida between v.Fecha_Salida and v.Fecha_Llegada)
begin
set @Retorno = 0
end
else
begin
set @Retorno = 1
end
return @Retorno
end
GO



---- Recorrido

create function LOS_QUE_VAN_A_APROBAR.PuertosDeRecorrido(@IdReco int)
returns TABLE
as
return 
select DISTINCT p.Nombre as NombrePuerto from LOS_QUE_VAN_A_APROBAR.Puerto p
join LOS_QUE_VAN_A_APROBAR.Tramo T on (T.Puerto_Llegada = p.Nombre or T.Puerto_Salida = p.Nombre)
join LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo RPT on T.IdTramo = RPT.CodigoTramo
where RPT.CodigoRecorrido = @IdReco
GO


-- Puertos extremos de un recorrido
create function LOS_QUE_VAN_A_APROBAR.PuertosExtremos(@IdReco int)
returns NVARCHAR(255)
as
begin
declare @Retorno NVARCHAR(255)
set @Retorno = (select TOP(1) ('Puerto salida: ' + t1.Puerto_Salida + ' - Puerto llegada: ' + t2.Puerto_Llegada) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo RPT
join LOS_QUE_VAN_A_APROBAR.Tramo t1 on t1.IdTramo = (select TOP(1) MIN(CodigoTramo) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo rpt where rpt.CodigoRecorrido = @IdReco)
join LOS_QUE_VAN_A_APROBAR.Tramo t2 on t2.IdTramo = (select TOP(1) MAX(CodigoTramo) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo ptr where ptr.CodigoRecorrido = @IdReco))
return @Retorno
end
GO


