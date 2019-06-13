-- Creacion de un viaje

create procedure CrearViaje(@IdCrucero nvarchar(50), @IdRecorrido int, @Fecha_Salida datetime2(3), @Fecha_Llegada datetime2(3), @CodigoRecorrido decimal(18,0))
as
begin
insert dbo.Viaje(IdCrucero,IdRecorrido,Fecha_Salida,Fecha_Llegada,CodigoRecorrido)
values(@IdCrucero,@IdRecorrido,@Fecha_Salida, @Fecha_Llegada, @CodigoRecorrido)
end

