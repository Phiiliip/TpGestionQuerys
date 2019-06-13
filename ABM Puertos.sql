
-- Crear puerto
create procedure CrearPuerto(@NombrePuerto VARCHAR(50), @Descripcion NVARCHAR(255))
as
begin
insert into dbo.Puerto(Nombre,Descripcion)
values(@NombrePuerto,@Descripcion)
end

-- Modificar puerto
create procedure ModificarPuerto(@NombrePuerto NVARCHAR(255), @Descripcion VARCHAR(50))
as
begin
update dbo.Puerto
set Nombre = @NombrePuerto, Descripcion = @Descripcion
end

-- Dar De baja
GO
drop procedure EliminarPuerto
create Procedure EliminarPuerto(@NombrePuertoBorrado NVARCHAR(255)) 
as 
begin
declare @IdRecorrido int
declare @IdTramo int
declare MiCursor CURSOR for
select CodigoRecorrido, IdTramo from RecorridoPorTramo r
join Tramo t on t.IdTramo = r.CodigoTramo
where Puerto_Llegada = @NombrePuertoBorrado or Puerto_Salida = @NombrePuertoBorrado

open MiCursor 
fetch next from MiCursor into @IdRecorrido, @IdTramo

while @@FETCH_STATUS = 0

BEGIN

delete from Reserva
where IdViaje in(select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from Pasaje
where IdViaje in(select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from RecorridoPorTramo 
where CodigoRecorrido = @IdRecorrido

delete from Viaje
where IdViaje in (select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from Recorrido
where IdRecorrido = @IdRecorrido

fetch next from MiCursor into @IdRecorrido, @IdTramo

END

close MiCursor
deallocate MiCursor

delete from Tramo
where Puerto_Salida = @NombrePuertoBorrado OR Puerto_Llegada = @NombrePuertoBorrado

delete from Puerto 
where Nombre = @NombrePuertoBorrado

END



