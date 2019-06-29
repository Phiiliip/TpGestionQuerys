-- LOGIN Y SEGURIDAD:


GO
-- Creacion de administrador
create procedure LOS_QUE_VAN_A_APROBAR.CrearAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
insert LOS_QUE_VAN_A_APROBAR.Administrador(NombreUsuario,Contraseña)
values (@Username, HASHBYTES('SHA2_256', @Password))
end
GO
--





-----------------------------------------------------------ROL----------------------------------------------------------------------------










-- ROL

create procedure LOS_QUE_VAN_A_APROBAR.NuevoRol (@NuevoNombre NVARCHAR(20))
as
begin
insert into LOS_QUE_VAN_A_APROBAR.Rol(Nombre)
values (@Nuevonombre)
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.NuevaFuncionalidad(@NuevoNombre NVARCHAR(255))
as 
begin
insert into LOS_QUE_VAN_A_APROBAR.Funcionalidad(Descripcion)
values(@NuevoNombre)
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.FuncionalidadParaRol(@IdRol int, @IdFuncionalidad int)
as
begin
insert into LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol(IdFuncionalidad, IdRol) 
values (@IdFuncionalidad, @IdRol)
end
GO

--
create procedure LOS_QUE_VAN_A_APROBAR.ModificarRol(@IdRol int, @Nombre NVARCHAR(20))
as
begin
update LOS_QUE_VAN_A_APROBAR.Rol
set Nombre = @Nombre
where IdRol = @IdRol
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.BajaRol(@IdRol int)
as
begin
update LOS_QUE_VAN_A_APROBAR.Rol
set Estado = 'Inhabilitado'
where IdRol = @IdRol
end
GO
--

Create procedure LOS_QUE_VAN_A_APROBAR.AltaRol(@IdRol int)
as
begin
update LOS_QUE_VAN_A_APROBAR.Rol
set Estado = 'Habilitado'
where IdRol = @Idrol
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.BajaFuncionalidadDeRol(@IdRol int, @IdFuncionalidad int)
as
begin
update LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol
set Estado = 'Inhabilitado'
where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad
end
GO



create procedure LOS_QUE_VAN_A_APROBAR.BajaFuncionalidadesDelRol(@IdRol int)
as
begin
update LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol
set Estado = 'Inhabilitado'
where IdRol = @IdRol
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.AltaFuncionalidadDelRol(@IdRol int, @IdFuncionalidad int)
as
begin
update LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol
set Estado = 'Habilitado'
where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad
end
GO

--





-------------------------------------------------------PUERTO--------------------------------------------------















-- PUERTO

-- Crear puerto
create procedure LOS_QUE_VAN_A_APROBAR.CrearPuerto(@NombrePuerto NVARCHAR(255), @Descripcion VARCHAR(50))
as
begin
insert into LOS_QUE_VAN_A_APROBAR.Puerto(Nombre,Descripcion)
values(@NombrePuerto,@Descripcion)
end
GO
-- Modificar puerto
create procedure LOS_QUE_VAN_A_APROBAR.ModificarPuerto(@NombrePuerto NVARCHAR(255), @Descripcion VARCHAR(50))
as
begin
update LOS_QUE_VAN_A_APROBAR.Puerto
set Descripcion = @Descripcion
where Nombre = @NombrePuerto
end

GO

-- Dar De baja
GO
create Procedure LOS_QUE_VAN_A_APROBAR. EliminarPuerto(@NombrePuertoBorrado NVARCHAR(255)) 
as 
begin
declare @IdRecorrido int
declare @IdTramo int
declare MiCursor CURSOR for
select CodigoRecorrido, IdTramo from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
join LOS_QUE_VAN_A_APROBAR.Tramo t on t.IdTramo = r.CodigoTramo
where Puerto_Llegada = @NombrePuertoBorrado or Puerto_Salida = @NombrePuertoBorrado

open MiCursor 
fetch next from MiCursor into @IdRecorrido, @IdTramo

while @@FETCH_STATUS = 0

BEGIN

delete from LOS_QUE_VAN_A_APROBAR.Reserva
where IdViaje in(select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from LOS_QUE_VAN_A_APROBAR.Pasaje
where IdViaje in(select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo 
where CodigoRecorrido = @IdRecorrido

delete from LOS_QUE_VAN_A_APROBAR.Viaje
where IdViaje in (select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from LOS_QUE_VAN_A_APROBAR.Recorrido
where IdRecorrido = @IdRecorrido

fetch next from MiCursor into @IdRecorrido, @IdTramo

END

close MiCursor
deallocate MiCursor

delete from LOS_QUE_VAN_A_APROBAR.Tramo
where Puerto_Salida = @NombrePuertoBorrado OR Puerto_Llegada = @NombrePuertoBorrado

delete from LOS_QUE_VAN_A_APROBAR.Puerto 
where Nombre = @NombrePuertoBorrado

END
GO
--





---------------------------------------------------------------RECORRIDO------------------------------------------------------------------------






-- Recorrido

Create procedure LOS_QUE_VAN_A_APROBAR.CrearRecorrido(@CodigoRecorrido decimal(18,2), @Descripcion varchar(50), @Precio decimal(18,2))
AS
BEGIN
INSERT INTO LOS_QUE_VAN_A_APROBAR.Recorrido(Codigo_Recorrido, Descripcion, PrecioTotal)
VALUES (@CodigoRecorrido, @Descripcion, @Precio)
END
GO
--Crear tramo de recorrido

CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.InsertarTramoDeRecorrido(@CodigoRecorrido int, @PuertoSalida NVARCHAR(255), @PuertoLlegada NVARCHAR(255), @Precio decimal(18,2))
AS
BEGIN
declare @CodigoTramo int
if NOT EXISTS(select 1 from LOS_QUE_VAN_A_APROBAR.Tramo t  where t.Puerto_Llegada = @PuertoLlegada and t.Puerto_Salida = @PuertoSalida)
begin
	insert into LOS_QUE_VAN_A_APROBAR.Tramo(Puerto_Salida, Puerto_Llegada, Precio)
	values(@PuertoSalida, @PuertoLlegada, @Precio)
end
set @CodigoTramo = (select top(1) IdTramo from LOS_QUE_VAN_A_APROBAR.Tramo where Puerto_Llegada = @PuertoLlegada and Puerto_Salida = @PuertoSalida)
INSERT INTO LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo(CodigoRecorrido, CodigoTramo, PrecioTramo)
values(@CodigoRecorrido, @CodigoTramo, @Precio)
END
GO
--modificar tramo de recorrido

select * from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo

Create PROCEDURE LOS_QUE_VAN_A_APROBAR.modificarTramoDeRecorrido(@IdRecorrido int,@TramoViejo int, @TramoNuevo int)
AS
BEGIN

update LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo
set CodigoTramo = @TramoNuevo
WHERE CodigoRecorrido = @IdRecorrido AND CodigoTramo = @TramoViejo

end
GO


--DAR DE BAJA RECORRIDO
CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.BajaRecorrido(@IdRecorrido int)
AS
BEGIN

IF NOT EXISTS (SELECT R.IdRecorrido
FROM LOS_QUE_VAN_A_APROBAR.Pasaje p
 JOIN LOS_QUE_VAN_A_APROBAR.Viaje v ON (v.IdViaje = p.IdViaje)
 JOIN LOS_QUE_VAN_A_APROBAR.Recorrido r ON (v.IdRecorrido = r.IdRecorrido)
WHERE p.Fecha_Salida > GETDATE() AND r.IdRecorrido = @IdRecorrido
)

BEGIN
UPDATE LOS_QUE_VAN_A_APROBAR.Recorrido
SET  Estado = 'Inhabilitado'
WHERE IdRecorrido = @IdRecorrido
END

ELSE
BEGIN
PRINT 'Hay pasajes vendidos para un viaje que todavía no se realizó'
END

END
GO





----------------------------------------------------------------------CRUCERO--------------------------------------






--




-- Creacion de un crucero

create procedure LOS_QUE_VAN_A_APROBAR.AltaCrucero(@IdCrucero NVARCHAR(50), @IdMarca int, @IdModelo int, @CantidadCabinas int)
as
begin
insert LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero,IdMarca,IdModelo,FechaAlta,CantidadCabinas)
values(@IdCrucero,@IdMarca,@IdModelo,SYSDATETIME(), @CantidadCabinas)
end
GO
-- Modificar Marca y modelo de crucero

create procedure LOS_QUE_VAN_A_APROBAR.ModificarMarcaYModelo(@IdCrucero NVARCHAR(50), @IdMarca int, @IdModelo int)
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdMarca = @IdMarca, IdModelo = @IdModelo
where IdCrucero = @IdCrucero
end
GO
-- Baja definitiva de crucero

create procedure LOS_QUE_VAN_A_APROBAR.BajaDefinitiva(@IdCrucero NVARCHAR(50))
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set FechaAlta = NULL
where IdCrucero = @IdCrucero

insert LOS_QUE_VAN_A_APROBAR.FueraDeServicio(IdCrucero,FechaBaja,MotivoBaja)
values(@IdCrucero, SYSDATETIME(), 'Vida util finalizada')

end
GO
-- Baja fuera de servicio

create procedure LOS_QUE_VAN_A_APROBAR.BajaFueraDeServicio(@IdCrucero NVARCHAR(50), @FechaDeAlta datetime2(3))
as
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set FechaAlta = @FechaDeAlta
where IdCrucero = @IdCrucero

insert LOS_QUE_VAN_A_APROBAR.FueraDeServicio(IdCrucero, FechaBaja, MotivoBaja, FechaReinicio)
values(@IdCrucero,SYSDATETIME(), 'Fuera de servicio', @FechaDeAlta)

end
GO

declare @Fecha DATETIME2(3)
set @Fecha = (select TOP(1) * from LOS_QUE_VAN_A_APROBAR.TablaFecha)
exec LOS_QUE_VAN_A_APROBAR.GenerarCabinasPorCrucero 'OPQXIP-19781', @Fecha

select * from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero order by Fecha_Salida DESC

select CantidadCabinas from LOS_QUE_VAN_A_APROBAR.Crucero where IdCrucero = 'OPQXIP-19781'


--- Generar las cabinas para un crucero



create procedure LOS_QUE_VAN_A_APROBAR.GenerarCabinasPorCrucero(@IdCrucero NVARCHAR(50), @FechaViaje DATETIME2(3))
as 
begin
declare @CantidadCabinasCrucero int
declare @CantidadCabinaBalcon int
declare @CantidadCabinaEstandar int
declare @CantidadCabinaExterior int
declare @CantidadCabinaEjecutivo int
declare @CantidadCabinaSuite int
declare @Incremental int
declare @NroCabina int
declare @NroPiso int



set @CantidadCabinasCrucero = (select CantidadCabinas from LOS_QUE_VAN_A_APROBAR.Crucero where IdCrucero = @IdCrucero)

set @CantidadCabinaBalcon = @CantidadCabinasCrucero / 5

set @CantidadCabinaEstandar = @CantidadCabinasCrucero / 5

set @CantidadCabinaExterior = @CantidadCabinasCrucero / 5

set @CantidadCabinaEjecutivo = @CantidadCabinasCrucero / 5

set @CantidadCabinaSuite  = @CantidadCabinasCrucero - @CantidadCabinaEjecutivo - @CantidadCabinaExterior - @CantidadCabinaEstandar - @CantidadCabinaBalcon

set @Incremental = 0
set @NroCabina = 0
set @NroPiso = 0


-- Cabinas Balcon
while( @Incremental < @CantidadCabinaBalcon)
begin
	insert into LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero(IdCrucero,TipoServicio,NroPiso,NroCabina,Fecha_Salida)
	values(@IdCrucero, 'Cabina Balcón ', @NroPiso, @NroCabina, @FechaViaje)
	if(@NroCabina > @CantidadCabinasCrucero / 2)
	begin
		set @NroCabina = 0
		set @NroPiso = @NroPiso + 1
	end
	else
	begin
		set @NroCabina = @NroCabina +1
	end
	set @Incremental = @Incremental +1
end

set @Incremental = 0


-- Cabinas estandar
while(@Incremental < @CantidadCabinaEstandar)
begin
	insert into LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero(IdCrucero,TipoServicio,NroPiso,NroCabina,Fecha_Salida)
	values(@IdCrucero, 'Cabina estandar', @NroPiso, @NroCabina, @FechaViaje)
	if(@NroCabina > @CantidadCabinasCrucero / 2)
	begin
		set @NroCabina = 0
		set @NroPiso = @NroPiso + 1
	end
	else
	begin
		set @NroCabina = @NroCabina +1
	end
	set @Incremental = @Incremental +1
end

set @Incremental = 0

-- Cabinas exterior
while(@Incremental < @CantidadCabinaExterior)
begin
	insert into LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero(IdCrucero,TipoServicio,NroPiso,NroCabina,Fecha_Salida)
	values(@IdCrucero, 'Cabina Exterior', @NroPiso, @NroCabina, @FechaViaje)
	if(@NroCabina > @CantidadCabinasCrucero / 2)
	begin
		set @NroCabina = 0
		set @NroPiso = @NroPiso + 1
	end
	else
	begin
		set @NroCabina = @NroCabina +1
	end
	set @Incremental = @Incremental +1
end

set @Incremental = 0

-- Cabina ejecutivo

while(@Incremental < @CantidadCabinaEjecutivo)
begin
	insert into LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero(IdCrucero,TipoServicio,NroPiso,NroCabina,Fecha_Salida)
	values(@IdCrucero, 'Ejecutivo', @NroPiso, @NroCabina, @FechaViaje)
	if(@NroCabina > @CantidadCabinasCrucero / 2)
	begin
		set @NroCabina = 0
		set @NroPiso = @NroPiso + 1
	end
	else
	begin
		set @NroCabina = @NroCabina +1
	end
	set @Incremental = @Incremental +1
end

set @Incremental = 0

-- Suite

while(@Incremental < @CantidadCabinaSuite)
begin
	insert into LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero(IdCrucero,TipoServicio,NroPiso,NroCabina,Fecha_Salida)
	values(@IdCrucero, 'Suite', @NroPiso, @NroCabina, @FechaViaje)
	if(@NroCabina > @CantidadCabinasCrucero / 2)
	begin
		set @NroCabina = 0
		set @NroPiso = @NroPiso + 1
	end
	else
	begin
		set @NroCabina = @NroCabina +1
	end
	set @Incremental = @Incremental +1
end

end

GO
--










--------------------------------------------------------VIAJE------------------------------------------


-- VIAJE

-- Creacion de un viaje

CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.GenerarViaje(@IdCrucero nvarchar(50), @IdRecorrido int, @Fecha_Salida datetime2(3), @Fecha_Llegada datetime2(3))
AS
BEGIN
DECLARE @Fecha_Actual datetime2(3)

SET @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

if CONVERT(datetime2(3),@Fecha_Salida) > CONVERT(datetime2(3), @Fecha_Actual)
BEGIN
	insert into LOS_QUE_VAN_A_APROBAR.Viaje(IdCrucero, IdRecorrido, Fecha_Salida, Fecha_Llegada)
	values(@IdCrucero, @IdRecorrido, @Fecha_Salida, @Fecha_Llegada)
END

ELSE
	Print 'la fecha de salida debe ser mayor a la actual' -- ver como pasar error a visual
END
GO












------------------------------------------PAGO Y CHEQUEO DE RESERVAS------------------------------------------


CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.PagarReserva(@IdReserva int)
AS
BEGIN

DECLARE @Fecha_Actual datetime2(3)
DECLARE @IdCliente int
DECLARE @IdViaje int
DECLARE @NroPiso int
DECLARE @NroCabina int
DECLARE @Fecha_Salida datetime2(3)

SET @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

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
CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.ChequearReservas
AS
BEGIN

DECLARE @Fecha_Actual datetime2(3)
DECLARE @IdReserva int
DECLARE @IdCliente int
DECLARE @IdViaje int
DECLARE @NroPiso int
DECLARE @NroCabina int
DECLARE @Fecha_Salida datetime2(3)
DECLARE @Fecha_Reserva datetime2(3)
DECLARE @IdCrucero nvarchar(50)


SET @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

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
GO











----------------------------------------------------COMPRA Y RESERVA ----------------------------------------------------


create procedure LOS_QUE_VAN_A_APROBAR.GenerarPasaje(@IdCliente int, @IdViaje int, @TipoServicio nvarchar(255),@NroPiso int, @NroCabina int, @Fecha_Salida datetime2(3))
AS
BEGIN
	
	DECLARE @Fecha_Actual datetime2(3)
	DECLARE @IdCrucero nvarchar(50)

	set @IdCrucero = (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = @IdViaje)
	set @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

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



create procedure LOS_QUE_VAN_A_APROBAR.GenerarReserva(@IdCliente int, @IdViaje int, @TipoServicio nvarchar(255),@NroPiso int, @NroCabina int, @Fecha_Salida datetime2(3))
AS
BEGIN
	
	DECLARE @Fecha_Actual datetime2(3)
	DECLARE @IdCrucero nvarchar(50)

	set @IdCrucero = (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = @IdViaje)
	set @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)
	
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


---------------- TABLA FECHA

CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.ActualizarFecha(@Fecha DATETIME2(3))
as
begin
update LOS_QUE_VAN_A_APROBAR.TablaFecha
set Fecha = @Fecha
where Fecha = (select TOP(1) * from LOS_QUE_VAN_A_APROBAR.TablaFecha)
end
GO


create procedure LOS_QUE_VAN_A_APROBAR.TramosARecorrido
as
begin
declare @IdRecorrido int
declare @CodigoTramo int
declare @Precio decimal(18,2)
declare @Incremental decimal(18,0)
declare Cursorsito CURSOR FOR
select IdTramo, Precio from LOS_QUE_VAN_A_APROBAR.Tramo

open Cursorsito

set @Incremental = 250000

fetch next from Cursorsito into @CodigoTramo, @Precio

while @@FETCH_STATUS = 0

begin

insert into LOS_QUE_VAN_A_APROBAR.Recorrido(Codigo_Recorrido,Descripcion,PrecioTotal)
values(@Incremental,'Prueba',@Precio)
-- Roles

set @IdRecorrido = (select TOP(1) IdRecorrido from LOS_QUE_VAN_A_APROBAR.Recorrido order by IdRecorrido DESC)

insert into LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo(CodigoRecorrido, CodigoTramo, PrecioTramo)
values(@IdRecorrido, @CodigoTramo, @Precio)

set @Incremental = @Incremental +1

fetch next from Cursorsito into @CodigoTramo, @Precio

end

close Cursorsito
deallocate Cursorsito

end 
GO





